import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends ChangeNotifier {
  User? _currentUser;
  String? _userRole; // 'student' or 'organizer'
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  String? get userRole => _userRole;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentUserId => _currentUser?.id ?? '';
  bool get isOrganizer => _userRole == 'organizer';

  AuthController() {
    _initFromSession();
  }

  /// Restore active session on app startup
  Future<void> _initFromSession() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        _currentUser = session.user;
        await _fetchUserRole(_currentUser!.id);
      }
    } catch (e) {
      debugPrint('AuthController session init error: $e');
    }
    notifyListeners();
  }

  /// Fetch user role from Supabase metadata & database
  Future<void> _fetchUserRole(String userId) async {
    try {
      // First check metadata on Auth User object
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null && user.userMetadata != null && user.userMetadata!['role'] != null) {
        _userRole = user.userMetadata!['role'] as String?;
      }

      // Also query users table in Supabase DB
      final data = await Supabase.instance.client
          .from('users')
          .select('role')
          .eq('id', userId)
          .maybeSingle();
      if (data != null && data['role'] != null) {
        _userRole = data['role'] as String?;
      }
    } catch (e) {
      debugPrint('AuthController role fetch error: $e');
    }
  }

  /// Helper to convert input to a valid auth identifier
  String _toAuthEmail(String identifier, bool isPhone) {
    final clean = identifier.trim();
    // If input contains @, it is strictly an Email Address!
    if (clean.contains('@')) return clean;
    // Strip non-digits for phone numbers
    final digits = clean.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return clean;
    return 'phone_$digits@kala.app';
  }

  /// Sign up with Phone or Email + Password
  Future<bool> signUp({
    required String identifier,
    required String password,
    required String name,
    required String role, // 'student' or 'organizer'
    bool isPhone = true,
  }) async {
    _isLoading = true;
    _errorMessage = null;
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

      final response = await Supabase.instance.client.auth.signUp(
        email: authEmail,
        password: cleanPass,
        data: {
          'name': name.trim(),
          'role': role,
          'identifier': identifier.trim(),
        },
      );

      final user = response.user ?? Supabase.instance.client.auth.currentUser;

      if (user != null) {
        _currentUser = user;
        _userRole = role;

        // Try inserting into users table
        try {
          await Supabase.instance.client.from('users').upsert({
            'id': user.id,
            'name': name.trim(),
            'email': authEmail,
            'role': role,
          });
        } catch (dbErr) {
          debugPrint('Notice: DB users insert skipped/RLS: $dbErr');
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Registration failed. Please check your credentials.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('SignUp exception: $e');
      _errorMessage = 'Registration error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in with Phone or Email + Password
  Future<bool> signIn({
    required String identifier,
    required String password,
    bool isPhone = true,
  }) async {
    _isLoading = true;
    _errorMessage = null;
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
        await _fetchUserRole(_currentUser!.id);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid login credentials. Please check your details.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('email not confirmed')) {
        _errorMessage = 'Email not confirmed yet. Please check your inbox or click "Resend Confirmation".';
      } else {
        _errorMessage = e.message;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('SignIn exception: $e');
      _errorMessage = 'Login error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Resend email confirmation link
  Future<bool> resendConfirmationEmail(String email) async {
    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: email.trim(),
      );
      return true;
    } catch (e) {
      debugPrint('Resend confirmation error: $e');
      return false;
    }
  }

  /// Sign out.
  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
    _currentUser = null;
    _userRole = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
