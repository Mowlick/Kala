import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Internal role constants — kept consistent between UI, logic, and database.
enum UserRole {
  student,
  organizer;

  /// Deserialize from a database / metadata string value.
  static UserRole fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'organizer':
        return UserRole.organizer;
      default:
        return UserRole.student;
    }
  }

  /// Serialize to the string value stored in the database.
  String get dbValue => name; // 'student' or 'organizer'
}

class AuthController extends ChangeNotifier {
  User? _currentUser;
  UserRole? _userRole;
  String? _userName;
  String? _organizationId;
  String? _organizationName;
  bool _isLoading = false;
  bool _pendingConfirmation = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  UserRole? get userRole => _userRole;
  String get displayName {
    if (_userName != null && _userName!.trim().isNotEmpty) return _userName!;
    final metaName = _currentUser?.userMetadata?['name']?.toString();
    if (metaName != null && metaName.trim().isNotEmpty) return metaName;
    final email = _currentUser?.email;
    if (email != null && email.isNotEmpty) return email.split('@').first;
    return 'User';
  }

  String get displayInitial {
    final name = displayName.trim();
    if (name.isEmpty) return 'U';
    return name[0].toUpperCase();
  }

  String get emailText => _currentUser?.email ?? '';
  String? get organizationId => _organizationId;
  String? get organizationName => _organizationName;

  /// The authenticated organizer's organization display name.
  String get organizationDisplayName =>
      _organizationName?.trim().isNotEmpty == true
      ? _organizationName!
      : _currentUser != null
      ? "$displayName's Organization"
      : 'My Organization';
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  bool get pendingConfirmation => _pendingConfirmation;
  String? get errorMessage => _errorMessage;
  String get currentUserId => _currentUser?.id ?? '';
  bool get isOrganizer => _userRole == UserRole.organizer;

  AuthController() {
    _initFromSession();
  }

  /// Returns true when the Supabase backend was initialized with credentials.
  /// Accessing the client throws when the app is running in offline mode.
  bool _isSupabaseReady() {
    try {
      Supabase.instance.client;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Restore active session on app startup.
  Future<void> _initFromSession() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        _currentUser = session.user;
        _userName = session.user.userMetadata?['name']?.toString();
        await _fetchUserRole(_currentUser!.id);
        if (_userRole == UserRole.organizer) {
          await syncOrganizerProfile();
        }
      }
    } catch (_) {
      // Session init failed — start unauthenticated.
    }
    notifyListeners();
  }

  /// Fetch user role from Supabase metadata & database.
  Future<void> _fetchUserRole(String userId) async {
    try {
      // Check auth metadata first.
      final user = Supabase.instance.client.auth.currentUser;
      if (user?.userMetadata?['role'] != null) {
        _userRole = UserRole.fromString(user!.userMetadata!['role'] as String?);
      }

      // Override with the authoritative DB value.
      final data = await Supabase.instance.client
          .from('users')
          .select('role')
          .eq('id', userId)
          .maybeSingle();
      if (data != null && data['role'] != null) {
        _userRole = UserRole.fromString(data['role'] as String?);
      }
    } catch (_) {
      // Role fetch failed — keep the metadata value or default.
    }
  }

  /// Convert a phone number or email identifier to an auth-compatible email.
  String _toAuthEmail(String identifier, bool isPhone) {
    final clean = identifier.trim();
    if (clean.contains('@')) return clean;
    final digits = clean.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return clean;
    return 'phone_$digits@kala.app';
  }

  /// Ensure the authenticated organizer has a profile row in `organizations`
  /// and that the owning `users` row exists. Loads the stored org id/name into
  /// state so every organizer page can use the authenticated profile.
  /// Offline-safe: failures are ignored and state simply stays null.
  Future<void> syncOrganizerProfile() async {
    final user = _currentUser;
    if (user == null) return;
    try {
      final client = Supabase.instance.client;
      if (_userName?.trim().isNotEmpty == true) {
        await client.from('users').upsert({
          'id': user.id,
          'name': _userName,
          'email': user.email ?? '',
          'role': 'organizer',
        });
      }
      final orgName = organizationDisplayName;
      final data = await client
          .from('organizations')
          .upsert({
            'owner_id': user.id,
            'name': orgName,
            'description':
                '$orgName — hosts live auditions and events on KALĀ.',
          }, onConflict: 'owner_id')
          .select()
          .maybeSingle();
      if (data != null) {
        _organizationId = data['id']?.toString();
        _organizationName = data['name']?.toString();
      }
    } catch (_) {
      // Offline or missing permissions — keep local state.
    }
    notifyListeners();
  }

  /// Sign up with Phone or Email + Password.
  Future<bool> signUp({
    required String identifier,
    required String password,
    required String name,
    required UserRole role,
    bool isPhone = true,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _pendingConfirmation = false;
    notifyListeners();

    try {
      final authEmail = _toAuthEmail(identifier, isPhone);
      final cleanPass = password.trim();

      if (cleanPass.length < 6) {
        _errorMessage = 'Password must be at least 6 characters long.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!_isSupabaseReady()) {
        _errorMessage =
            'Registration is not available right now: the app is running '
            'in offline mode. Pass SUPABASE_URL and SUPABASE_ANON_KEY as '
            'dart-defines and restart the app.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final response = await Supabase.instance.client.auth.signUp(
        email: authEmail,
        password: cleanPass,
        data: {
          'name': name.trim(),
          'role': role.dbValue,
          'identifier': identifier.trim(),
        },
      );

      final user = response.user;
      final session = response.session;

      if (user == null) {
        _errorMessage =
            'An account with this identifier already exists. Please log in '
            'or try a different identifier.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (session == null) {
        // Account was created but the server requires email confirmation
        // (autoconfirm OFF). No session exists yet, so the user must verify
        // their inbox before they can log in.
        _pendingConfirmation = true;
        _errorMessage =
            'Registration successful! A confirmation link was '
            'sent to your email. Please confirm it before logging in.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Fully authenticated — persist local state and sync profile.
      _currentUser = user;
      _userRole = role;
      _userName = name.trim();

      try {
        await Supabase.instance.client.from('users').upsert({
          'id': user.id,
          'name': name.trim(),
          'email': authEmail,
          'role': role.dbValue,
        });
      } catch (_) {
        // DB insert skipped — RLS or offline. Auth user is still valid.
      }

      if (role == UserRole.organizer) {
        await syncOrganizerProfile();
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = _safeAuthMessage(e.message);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('signUp exception: $e');
      _errorMessage = 'Registration failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in with Phone or Email + Password.
  Future<bool> signIn({
    required String identifier,
    required String password,
    bool isPhone = true,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _pendingConfirmation = false;
    notifyListeners();

    try {
      final authEmail = _toAuthEmail(identifier, isPhone);
      final cleanPass = password.trim();

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: authEmail,
        password: cleanPass,
      );

      if (response.user != null) {
        _currentUser = response.user;
        _userName = response.user?.userMetadata?['name']?.toString();
        await _fetchUserRole(_currentUser!.id);
        if (_userRole == UserRole.organizer) {
          await syncOrganizerProfile();
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid credentials. Please check your details.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on AuthException catch (e) {
      _errorMessage = _safeAuthMessage(e.message);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Login failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Resend email confirmation link.
  Future<bool> resendConfirmationEmail(String identifier) async {
    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: _toAuthEmail(identifier, !identifier.contains('@')),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Sign out.
  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {
      // Ignore sign-out errors; clear local state regardless.
    }
    _currentUser = null;
    _userRole = null;
    _userName = null;
    _organizationId = null;
    _organizationName = null;
    _pendingConfirmation = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Converts Supabase AuthException messages to safe, user-friendly strings.
  /// Avoids leaking internal implementation details.
  String _safeAuthMessage(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('email not confirmed')) {
      return 'Email not confirmed yet. Please check your inbox or click "Resend Confirmation".';
    }
    if (lower.contains('invalid login credentials') ||
        lower.contains('invalid_credentials')) {
      return 'Invalid credentials. Please check your details.';
    }
    if (lower.contains('user already registered') ||
        lower.contains('already registered')) {
      return 'An account with this identifier already exists. Please log in.';
    }
    if (lower.contains('email rate limit') || lower.contains('rate_limit')) {
      return 'Too many requests. Please wait a moment and try again.';
    }
    if (lower.contains('network') || lower.contains('socket')) {
      return 'Network error. Please check your connection and try again.';
    }
    // Fallback — show the raw message but it is already from Supabase Auth
    // (not a stack trace or internal DB error).
    return raw;
  }
}
