import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../controllers/auth_controller.dart';

class AuthScreen extends StatefulWidget {
  /// When [isLogin] is true, the screen shows "Welcome back" copy.
  /// When false (default), it shows "Create your Kalā account" copy.
  final bool isLogin;

  const AuthScreen({super.key, this.isLogin = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  String _selectedRole = 'artist'; // Default to artist
  bool _isPhoneMode = true; // Preferred phone authentication
  bool _obscurePassword = true;

  String get _title => widget.isLogin ? 'Welcome back' : 'Create your Kalā account';

  String get _subtitle => widget.isLogin
      ? 'Sign in to continue your creative journey.'
      : "Join India's growing creative community.";

  String get _leftTitleText1 => widget.isLogin ? 'Welcome\n' : 'Create your\ncreative ';
  String get _leftTitleText2 => widget.isLogin ? 'back.' : 'identity.';

  String get _leftSubtitle => widget.isLogin
      ? 'Sign in to pick up where you left off\nand continue building your creative future.'
      : 'Your portfolio, opportunities and\ncollaborations will be securely saved\nto your account.';

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleAuthSubmit(BuildContext context) async {
    final auth = context.read<AuthController>();
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final rawPhone = _phoneController.text.trim();
    final rawEmail = _emailController.text.trim();
    final identifier = rawEmail.isNotEmpty ? rawEmail : rawPhone;
    final isPhoneInput = _isPhoneMode && !identifier.contains('@');
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (identifier.isEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(_isPhoneMode ? 'Please enter your mobile number or email.' : 'Please enter your email address.'),
          backgroundColor: Colors.orange.shade800,
        ),
      );
      return;
    }

    if (password.isEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Text('Please enter your password.'),
          backgroundColor: Colors.orange.shade800,
        ),
      );
      return;
    }

    if (!widget.isLogin && name.isEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Text('Please enter your full name.'),
          backgroundColor: Colors.orange.shade800,
        ),
      );
      return;
    }

    final role = _selectedRole == 'organization' ? 'organizer' : 'student';
    bool success;

    if (widget.isLogin) {
      success = await auth.signIn(
        identifier: identifier,
        password: password,
        isPhone: isPhoneInput,
      );
    } else {
      success = await auth.signUp(
        identifier: identifier,
        password: password,
        name: name,
        role: role,
        isPhone: isPhoneInput,
      );
    }

    if (!mounted) return;

    if (success) {
      if (widget.isLogin) {
        final fetchedRole = auth.userRole ?? role;
        if (fetchedRole == 'organizer') {
          navigator.pushNamedAndRemoveUntil('/organizer-home', (_) => false);
        } else {
          navigator.pushNamedAndRemoveUntil('/home', (_) => false);
        }
      } else {
        if (role == 'organizer') {
          navigator.pushNamed('/organizer-onboarding');
        } else {
          navigator.pushNamed('/student-onboarding');
        }
      }
    } else {
      final isUnconfirmed = auth.errorMessage?.toLowerCase().contains('email not confirmed') ?? false;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Authentication failed. Please try again.'),
          backgroundColor: Colors.redAccent,
          action: isUnconfirmed
              ? SnackBarAction(
                  label: 'Resend',
                  textColor: Colors.white,
                  onPressed: () async {
                    final sent = await auth.resendConfirmationEmail(identifier);
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text(sent ? 'Confirmation email resent to $identifier!' : 'Failed to resend confirmation email.'),
                          backgroundColor: sent ? Colors.green : Colors.orange,
                        ),
                      );
                    }
                  },
                )
              : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 1000) {
              return _buildLaptopLayout(context, constraints);
            }
            return _buildMobileLayout(context);
          },
        ),
      ),
    );
  }

  // ─── MOBILE ───────────────────────────────────────────────────────────────
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: KalaColors.charcoal),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Text(
              'kalā',
              style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 44, fontWeight: FontWeight.bold, color: KalaColors.charcoal, letterSpacing: -1),
            ),
            const SizedBox(height: 6),
            const Icon(Icons.flare, color: KalaColors.burntOrange, size: 26),
            const SizedBox(height: 12),
            Text(
              _title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 34, height: 1.1, color: KalaColors.charcoal, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: KalaColors.charcoal.withValues(alpha: 0.6), height: 1.4),
            ),
            const SizedBox(height: 24),
            _buildRoleSelector(),
            const SizedBox(height: 24),
            _buildAuthCardForm(context),
            const SizedBox(height: 20),
            _buildBottomSwitch(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ─── LAPTOP ───────────────────────────────────────────────────────────────
  Widget _buildLaptopLayout(BuildContext context, BoxConstraints constraints) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left branding + collage
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(56, 40, 40, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'kalā',
                        style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 42, fontWeight: FontWeight.bold, color: KalaColors.charcoal, letterSpacing: -1),
                      ),
                      const Spacer(),
                      const Icon(Icons.flare, color: KalaColors.burntOrange, size: 32),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 54, height: 1.1, color: KalaColors.charcoal, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(text: _leftTitleText1),
                            TextSpan(text: _leftTitleText2, style: const TextStyle(color: KalaColors.burntOrange)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _leftSubtitle,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: KalaColors.charcoal.withValues(alpha: 0.6), height: 1.55),
                      ),
                      const SizedBox(height: 32),
                      Expanded(flex: 4, child: _buildFannedCollage(context)),
                      const Spacer(),
                    ],
                  ),
                ),
              ),

              // Right auth card
              Expanded(
                flex: 6,
                child: Container(
                  color: KalaColors.softBeige.withValues(alpha: 0.4),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 480),
                        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                        padding: const EdgeInsets.fromLTRB(36, 28, 36, 28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 32, offset: const Offset(0, 8)),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_title, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 26, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                            Container(
                              margin: const EdgeInsets.only(top: 6, bottom: 8),
                              height: 3,
                              width: 36,
                              decoration: BoxDecoration(color: KalaColors.burntOrange, borderRadius: BorderRadius.circular(2)),
                            ),
                            Text(_subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: KalaColors.charcoal.withValues(alpha: 0.5))),
                            const SizedBox(height: 20),
                            _buildRoleSelector(),
                            const SizedBox(height: 20),
                            _buildAuthCardForm(context),
                            const SizedBox(height: 16),
                            Center(child: _buildBottomSwitch(context)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── AUTH FORM CONTAINER ──────────────────────────────────────────────────
  Widget _buildAuthCardForm(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Selector: Phone vs Email
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: KalaColors.softBeige.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isPhoneMode = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _isPhoneMode ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: _isPhoneMode ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone_android_rounded, size: 16, color: _isPhoneMode ? KalaColors.burntOrange : KalaColors.mediumGrey),
                        const SizedBox(width: 6),
                        Text(
                          'Mobile Number',
                          style: TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _isPhoneMode ? KalaColors.charcoal : KalaColors.mediumGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isPhoneMode = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: !_isPhoneMode ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: !_isPhoneMode ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mail_outline_rounded, size: 16, color: !_isPhoneMode ? KalaColors.burntOrange : KalaColors.mediumGrey),
                        const SizedBox(width: 6),
                        Text(
                          'Email Address',
                          style: TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: !_isPhoneMode ? KalaColors.charcoal : KalaColors.mediumGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Full Name (Sign Up only)
        if (!widget.isLogin) ...[
          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'e.g. Aarav Sharma',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 14),
        ],

        // Input Field (Phone or Email)
        if (_isPhoneMode) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mobile Number', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: KalaColors.lightGrey, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: KalaColors.softBeige.withValues(alpha: 0.5),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                      ),
                      child: const Row(
                        children: [
                          Text('+91', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 14, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                          SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down, size: 16, color: KalaColors.mediumGrey),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter 10-digit number',
                          hintStyle: TextStyle(fontSize: 13, color: KalaColors.mediumGrey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ] else ...[
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'e.g. aarav@email.com',
            icon: Icons.mail_outline_rounded,
          ),
        ],

        const SizedBox(height: 14),

        // Password Field
        _buildTextField(
          controller: _passwordController,
          label: 'Password',
          hint: widget.isLogin ? 'Enter your password' : 'Min 6 characters',
          icon: Icons.lock_outline_rounded,
          obscure: _obscurePassword,
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            child: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: KalaColors.mediumGrey),
          ),
        ),

        const SizedBox(height: 22),

        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: auth.isLoading ? null : () => _handleAuthSubmit(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: KalaColors.burntOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: auth.isLoading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : Text(
                    widget.isLogin ? 'Sign In' : 'Create Account',
                    style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
        ),

        const SizedBox(height: 18),

        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: KalaColors.charcoal.withValues(alpha: 0.15))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'OR',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: KalaColors.charcoal.withValues(alpha: 0.4), letterSpacing: 1),
              ),
            ),
            Expanded(child: Divider(color: KalaColors.charcoal.withValues(alpha: 0.15))),
          ],
        ),

        const SizedBox(height: 14),

        // Social Buttons
        _buildSocialButton(
          label: 'Continue with Google',
          onPressed: () => _handleAuthSubmit(context),
          icon: _googleIcon(),
        ),
      ],
    );
  }

  // ─── ROLE SELECTOR ────────────────────────────────────────────────────────
  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'I am joining as',
          style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedRole = 'artist'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  decoration: BoxDecoration(
                    color: _selectedRole == 'artist' ? const Color(0xFFFFF7ED) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedRole == 'artist' ? KalaColors.burntOrange : KalaColors.lightGrey,
                      width: _selectedRole == 'artist' ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.theater_comedy_rounded, color: _selectedRole == 'artist' ? KalaColors.burntOrange : KalaColors.mediumGrey, size: 24),
                      const SizedBox(height: 6),
                      const Text(
                        'Performer / Artist',
                        style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedRole = 'organization'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  decoration: BoxDecoration(
                    color: _selectedRole == 'organization' ? const Color(0xFFFFF7ED) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedRole == 'organization' ? KalaColors.burntOrange : KalaColors.lightGrey,
                      width: _selectedRole == 'organization' ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.business_center_rounded, color: _selectedRole == 'organization' ? KalaColors.burntOrange : KalaColors.mediumGrey, size: 24),
                      const SizedBox(height: 6),
                      const Text(
                        'Organization / Recruiter',
                        style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 18, color: KalaColors.mediumGrey),
            suffixIcon: suffixIcon,
            hintStyle: const TextStyle(fontSize: 13, color: KalaColors.mediumGrey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KalaColors.lightGrey)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String label,
    required VoidCallback? onPressed,
    required Widget icon,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: KalaColors.charcoal.withValues(alpha: 0.18), width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          children: [
            icon,
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: KalaColors.charcoal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _googleIcon() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleGPainter()),
    );
  }

  Widget _buildBottomSwitch(BuildContext context) {
    final prefixText = widget.isLogin ? "Don't have an account? " : 'Already have an account? ';
    final linkText = widget.isLogin ? 'Create one' : 'Log In';

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AuthScreen(isLogin: !widget.isLogin),
          ),
        );
      },
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: KalaColors.charcoal.withValues(alpha: 0.6)),
          children: [
            TextSpan(text: prefixText),
            TextSpan(
              text: linkText,
              style: const TextStyle(color: KalaColors.burntOrange, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFannedCollage(BuildContext context) {
    const images = [
      'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
      'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
      'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
      'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth = constraints.maxWidth;
      final cardWidth = (totalWidth - 24) / 4;
      final baseHeight = constraints.maxHeight;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(4, (i) {
          return Padding(
            padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: cardWidth,
                height: (baseHeight * 0.85).clamp(100.0, 400.0),
                child: Image.network(images[i], fit: BoxFit.cover),
              ),
            ),
          );
        }),
      );
    });
  }
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const sweeps = [
      [0.0, 90.0, Color(0xFF4285F4)],
      [90.0, 90.0, Color(0xFF34A853)],
      [180.0, 90.0, Color(0xFFFBBC05)],
      [270.0, 90.0, Color(0xFFEA4335)],
    ];

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.18;

    for (final s in sweeps) {
      paint.color = s[2] as Color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.72),
        _toRad(s[0] as double),
        _toRad(s[1] as double),
        false,
        paint,
      );
    }
  }

  double _toRad(double deg) => deg * 3.141592653589793 / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
