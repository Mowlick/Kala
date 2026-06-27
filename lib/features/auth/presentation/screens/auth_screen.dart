import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';

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

  // Dynamic copy based on mode
  String get _title =>
      widget.isLogin ? 'Welcome back' : 'Create your Kalā account';

  String get _subtitle => widget.isLogin
      ? 'Sign in to continue your creative journey.'
      : "Join India's growing creative community.";

  String get _leftTitleText1 =>
      widget.isLogin ? 'Welcome\n' : 'Create your\ncreative ';
  String get _leftTitleText2 => widget.isLogin ? 'back.' : 'identity.';

  String get _leftSubtitle => widget.isLogin
      ? 'Sign in to pick up where you left off\nand continue building your creative future.'
      : 'Your portfolio, opportunities and\ncollaborations will be securely saved\nto your account.';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
            // Back arrow
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: KalaColors.charcoal),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            // Logo
            Text(
              'kalā',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 24),
            // 4-point star
            const Icon(Icons.flare, color: KalaColors.burntOrange, size: 28),
            const SizedBox(height: 12),
            // Headline
            Text(
              _title,
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 40,
                height: 1.1,
                color: KalaColors.charcoal,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Subtitle
            Text(
              _subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: KalaColors.charcoal.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 32),
            _buildAuthButtons(context),
            const SizedBox(height: 24),
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
        // Main content
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Left: branding + collage ──
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(56, 40, 40, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'kalā',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: KalaColors.charcoal,
                          letterSpacing: -1,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.flare,
                          color: KalaColors.burntOrange, size: 32),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 60,
                            height: 1.1,
                            color: KalaColors.charcoal,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(text: _leftTitleText1),
                            TextSpan(
                              text: _leftTitleText2,
                              style: const TextStyle(
                                  color: KalaColors.burntOrange),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _leftSubtitle,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: KalaColors.charcoal.withValues(alpha: 0.6),
                              height: 1.55,
                            ),
                      ),
                      const SizedBox(height: 40),
                      Expanded(
                        flex: 4,
                        child: _buildFannedCollage(context),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),

              // ── Right: auth card (no scroll, optimized heights) ──
              Expanded(
                flex: 6,
                child: Container(
                  color: KalaColors.softBeige.withValues(alpha: 0.4),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 460),
                      margin: const EdgeInsets.symmetric(horizontal: 48),
                      // Reduced padding to prevent overflow
                      padding: const EdgeInsets.fromLTRB(40, 24, 40, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card title
                          Text(
                            _title,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: KalaColors.charcoal,
                            ),
                          ),
                          // Orange underline
                          Container(
                            margin: const EdgeInsets.only(top: 6, bottom: 10),
                            height: 3,
                            width: 36,
                            decoration: BoxDecoration(
                              color: KalaColors.burntOrange,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Text(
                            _subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: KalaColors.charcoal
                                      .withValues(alpha: 0.5),
                                ),
                          ),
                          const SizedBox(height: 24),
                          _buildAuthButtons(context),
                          const SizedBox(height: 16),
                          Center(child: _buildBottomSwitch(context)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Bottom feature banner ──
        Container(
          color: KalaColors.softBeige.withValues(alpha: 0.5),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFeatureItem(context,
                  icon: Icons.shield_outlined,
                  title: 'Secure & Private',
                  description:
                      'Your data is protected with\nenterprise-grade security.'),
              _buildFeatureItem(context,
                  icon: Icons.people_outline,
                  title: 'Built for Creators',
                  description:
                      'Everything you need to grow\nyour creative career.'),
              _buildFeatureItem(context,
                  icon: Icons.star_border_rounded,
                  title: 'Real Opportunities',
                  description:
                      'Connect with verified professionals\nand discover real opportunities.'),
            ],
          ),
        ),
      ],
    );
  }

  // ─── FANNED COLLAGE ───────────────────────────────────────────────────────

  Widget _buildFannedCollage(BuildContext context) {
    const images = [
      'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
      'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
      'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
      'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
    ];
    const heights = [0.0, -20.0, -10.0, -25.0];
    const topRadii = [60.0, 80.0, 80.0, 60.0];
    const bottomRadii = [16.0, 16.0, 16.0, 16.0];

    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth = constraints.maxWidth;
      final cardWidth = (totalWidth - 24) / 4;
      final baseHeight = constraints.maxHeight;

      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: 0,
            left: 8,
            child: Icon(Icons.music_note_outlined,
                color: KalaColors.burntOrange.withValues(alpha: 0.25),
                size: 28),
          ),
          Positioned(
            top: 20,
            right: 0,
            child: Icon(Icons.videocam_outlined,
                color: KalaColors.burntOrange.withValues(alpha: 0.2),
                size: 24),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            child: Icon(Icons.headset_outlined,
                color: KalaColors.burntOrange.withValues(alpha: 0.2),
                size: 22),
          ),
          Positioned(
            bottom: 20,
            right: 4,
            child: Icon(Icons.camera_alt_outlined,
                color: KalaColors.burntOrange.withValues(alpha: 0.2),
                size: 22),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(4, (i) {
              final vertOffset = heights[i];
              final cardH = (baseHeight + vertOffset).clamp(100.0, 500.0);
              return Padding(
                padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                child: Transform.translate(
                  offset: Offset(0, vertOffset),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(topRadii[i]),
                      topRight: Radius.circular(topRadii[i]),
                      bottomLeft: Radius.circular(bottomRadii[i]),
                      bottomRight: Radius.circular(bottomRadii[i]),
                    ),
                    child: SizedBox(
                      width: cardWidth,
                      height: cardH,
                      child: Image.network(images[i], fit: BoxFit.cover,
                          loadingBuilder: (ctx, child, prog) {
                        if (prog == null) return child;
                        return Container(
                          color: KalaColors.softBeige,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: KalaColors.burntOrange,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      );
    });
  }

  // ─── AUTH BUTTONS ────────────────────────────────────────────────────────

  Widget _buildAuthButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSocialButton(
          label: 'Continue with Google',
          onPressed: () => Navigator.pushNamed(
              context, widget.isLogin ? '/home' : '/role-select'),
          icon: _googleIcon(),
        ),
        const SizedBox(height: 12),
        _buildSocialButton(
          label: 'Continue with Apple',
          onPressed: () => Navigator.pushNamed(
              context, widget.isLogin ? '/home' : '/role-select'),
          icon: const Icon(Icons.apple, color: KalaColors.charcoal, size: 24),
        ),
        const SizedBox(height: 12),
        _buildSocialButton(
          label: 'Continue with Email',
          onPressed: () => Navigator.pushNamed(
              context, widget.isLogin ? '/home' : '/role-select'),
          icon: const Icon(Icons.mail_outline_rounded,
              color: KalaColors.charcoal, size: 22),
        ),
        
        // Show phone input ONLY for Sign Up (isLogin == false)
        if (!widget.isLogin) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: Divider(
                      color: KalaColors.charcoal.withValues(alpha: 0.15),
                      thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: KalaColors.charcoal.withValues(alpha: 0.4),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Expanded(
                  child: Divider(
                      color: KalaColors.charcoal.withValues(alpha: 0.15),
                      thickness: 1)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Continue with Phone Number',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: KalaColors.charcoal,
                  fontSize: 13,
                ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: KalaColors.charcoal.withValues(alpha: 0.15),
                  width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Text('+91',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: KalaColors.charcoal,
                                fontSize: 15,
                              )),
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down,
                          color: KalaColors.charcoal.withValues(alpha: 0.6),
                          size: 18),
                    ],
                  ),
                ),
                Container(
                    width: 1,
                    height: 22,
                    color: KalaColors.charcoal.withValues(alpha: 0.15)),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: KalaColors.charcoal,
                          fontSize: 15,
                        ),
                    decoration: InputDecoration(
                      hintText: 'Enter your mobile number',
                      hintStyle: TextStyle(
                          color: KalaColors.charcoal.withValues(alpha: 0.35),
                          fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                  context, widget.isLogin ? '/home' : '/role-select'),
              style: ElevatedButton.styleFrom(
                backgroundColor: KalaColors.burntOrange,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],

        const SizedBox(height: 16),
        // Terms
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: KalaColors.charcoal.withValues(alpha: 0.8),
                    height: 1.6,
                  ),
              children: const [
                TextSpan(text: 'By continuing, you agree to our \n'),
                TextSpan(
                  text: 'Terms of Service ',
                  style: TextStyle(
                      color: KalaColors.burntOrange,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                      color: KalaColors.burntOrange,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Bottom switch link
  Widget _buildBottomSwitch(BuildContext context) {
    final prefixText = widget.isLogin
        ? "Don't have an account? "
        : 'Already have an account? ';
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: KalaColors.charcoal.withValues(alpha: 0.6),
              ),
          children: [
            TextSpan(text: prefixText),
            TextSpan(
              text: linkText,
              style: const TextStyle(
                color: KalaColors.burntOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────

  Widget _buildSocialButton({
    required String label,
    required VoidCallback onPressed,
    required Widget icon,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46, // Reduced from 50
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(
              color: KalaColors.charcoal.withValues(alpha: 0.18), width: 1.5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          children: [
            icon,
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: KalaColors.charcoal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _googleIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(painter: _GoogleGPainter()),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: KalaColors.burntOrange.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: KalaColors.charcoal, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: KalaColors.charcoal,
                    )),
            const SizedBox(height: 2),
            Text(description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: KalaColors.charcoal.withValues(alpha: 0.55),
                      height: 1.4,
                    )),
          ],
        ),
      ],
    );
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

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTWH(center.dx - paint.strokeWidth * 0.5,
            center.dy - paint.strokeWidth * 0.6, radius, paint.strokeWidth * 1.2),
        whitePaint);

    final armPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTWH(center.dx - paint.strokeWidth * 0.5,
            center.dy - paint.strokeWidth * 0.6, radius * 0.9,
            paint.strokeWidth * 1.2),
        armPaint);
  }

  double _toRad(double deg) => deg * 3.141592653589793 / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
