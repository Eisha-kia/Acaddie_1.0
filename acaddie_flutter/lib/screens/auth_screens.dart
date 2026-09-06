import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';
import '../models/user_model.dart';
import '../widgets/acaddie_logo.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LOGIN SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onGoToRegister;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onGoToRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _showPass = false;

  Future<void> _login() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Please enter both your email and password');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    final err = await AuthService.login(email, pass);
    if (!mounted) return;
    setState(() => _loading = false);
    if (err != null) {
      setState(() => _error = err);
    } else {
      widget.onLoginSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.isDark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF060D1A) : const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // Left panel — Academic branding
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF0A1628), const Color(0xFF0D1F3C)]
                      : [const Color(0xFFE2E8F0), const Color(0xFFF1F5F9)],
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AcaddieLogo(size: 52, isDark: isDark),
                      const SizedBox(height: 36),
                      Text(
                        'Think. Simulate. Decide.',
                        style: AppTypography.heading(
                          fontSize: 38,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Google Maps for Academic Decisions.\nSimulate downstream curriculum ripple effects before making syllabus modifications.',
                        style: AppTypography.body(
                          fontSize: 15,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Feature badges
                      ...[
                        '7 Core Academic Dimensions analysis',
                        'Verifiable causal dependency chains',
                        'Real-time animated curriculum ripple map',
                        'What-If comparative alternatives (Plan A/B/C)',
                      ].map((feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check,
                                      color: Color(0xFF38BDF8), size: 13),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: AppTypography.body(
                                      fontSize: 13,
                                      color: isDark
                                          ? const Color(0xFFCBD5E1)
                                          : const Color(0xFF334155),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Right panel — Login Form
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back',
                        style: AppTypography.heading(
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sign in to your university faculty account',
                        style: AppTypography.body(
                          fontSize: 14,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Error message
                      if (_error != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Color(0xFFF87171), size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _error!,
                                  style: AppTypography.body(
                                    fontSize: 13,
                                    color: const Color(0xFFF87171),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Email field
                      _label('University Email Address', isDark),
                      _inputField(
                        controller: _emailCtrl,
                        hint: 'instructor@aust.edu',
                        icon: Icons.email_outlined,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 18),

                      // Password field
                      _label('Password', isDark),
                      _inputField(
                        controller: _passCtrl,
                        hint: '••••••••',
                        icon: Icons.lock_outline,
                        obscure: !_showPass,
                        isDark: isDark,
                        suffix: IconButton(
                          icon: Icon(
                            _showPass
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF64748B),
                            size: 18,
                          ),
                          onPressed: () =>
                              setState(() => _showPass = !_showPass),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0284C7),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: _loading ? null : _login,
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  'Sign In',
                                  style: AppTypography.body(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : const Color(0xFFCBD5E1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or',
                              style: AppTypography.body(
                                fontSize: 12,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : const Color(0xFFCBD5E1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Register link
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : const Color(0xFFCBD5E1),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: widget.onGoToRegister,
                          child: Text(
                            'Create New Faculty Account',
                            style: AppTypography.body(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: AppTypography.body(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFCBD5E1),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: AppTypography.body(
          fontSize: 13,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              size: 18),
          suffixIcon: suffix,
          hintText: hint,
          hintStyle: AppTypography.body(
            fontSize: 13,
            color: const Color(0xFF64748B),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REGISTER SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegisterSuccess;
  final VoidCallback onGoToLogin;

  const RegisterScreen({
    super.key,
    required this.onRegisterSuccess,
    required this.onGoToLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _varsityCtrl = TextEditingController(
      text: 'Ahsanullah University of Science and Technology (AUST)');
  final _varsityIdCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  bool _loading = false;
  String? _error;
  bool _showPass = false;

  Future<void> _register() async {
    if (_passCtrl.text != _confirmPassCtrl.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    final user = AcaddieUser(
      fullName: _fullNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      password: _passCtrl.text.trim(),
      varsityName: _varsityCtrl.text.trim(),
      varsityId: _varsityIdCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
    );
    final err = await AuthService.register(user);
    if (!mounted) return;
    setState(() => _loading = false);
    if (err != null) {
      setState(() => _error = err);
    } else {
      widget.onRegisterSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.isDark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF060D1A) : const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // Left branding panel
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF0A1628), const Color(0xFF0D1F3C)]
                      : [const Color(0xFFE2E8F0), const Color(0xFFF1F5F9)],
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AcaddieLogo(size: 52, isDark: isDark),
                      const SizedBox(height: 36),
                      Text(
                        'Faculty\nRegistration',
                        style: AppTypography.heading(
                          fontSize: 44,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Create your official academic profile once.\nYour session will persist securely on this device.',
                        style: AppTypography.body(
                          fontSize: 15,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 36),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFF0284C7).withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Authorized Access Features:',
                              style: AppTypography.body(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF38BDF8),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...[
                              'Syllabus modification impact simulation',
                              'Automated multi-hop downstream cascade mapping',
                              'What-If comparative matrix analysis (Plans A, B, C)',
                              'Printable official academic accreditation reports',
                            ].map((t) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: Color(0xFF10B981), size: 16),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          t,
                                          style: AppTypography.body(
                                            fontSize: 12,
                                            color: isDark
                                                ? const Color(0xFF94A3B8)
                                                : const Color(0xFF475569),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Right form panel
          Expanded(
            flex: 3,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Academic Profile',
                        style: AppTypography.heading(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Fields marked with an asterisk (*) are required',
                        style: AppTypography.body(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 28),

                      if (_error != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Color(0xFFF87171), size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _error!,
                                  style: AppTypography.body(
                                    fontSize: 13,
                                    color: const Color(0xFFF87171),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Form Grid (Two Columns)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Column 1: Personal Credentials
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader('Personal Credentials', isDark),
                                _formField(
                                  label: 'Full Name *',
                                  controller: _fullNameCtrl,
                                  hint: 'Dr. John Doe',
                                  icon: Icons.person_outline,
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 14),
                                _formField(
                                  label: 'University Email *',
                                  controller: _emailCtrl,
                                  hint: 'instructor@aust.edu',
                                  icon: Icons.email_outlined,
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 14),
                                _formField(
                                  label: 'Contact Phone',
                                  controller: _phoneCtrl,
                                  hint: '+880 1XXXXXXXXX',
                                  icon: Icons.phone_outlined,
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 14),
                                _formField(
                                  label: 'Password * (min. 6 characters)',
                                  controller: _passCtrl,
                                  hint: '••••••••',
                                  icon: Icons.lock_outline,
                                  obscure: !_showPass,
                                  isDark: isDark,
                                  suffix: IconButton(
                                    icon: Icon(
                                      _showPass
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: const Color(0xFF64748B),
                                      size: 18,
                                    ),
                                    onPressed: () =>
                                        setState(() => _showPass = !_showPass),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                _formField(
                                  label: 'Confirm Password *',
                                  controller: _confirmPassCtrl,
                                  hint: '••••••••',
                                  icon: Icons.lock_outline,
                                  obscure: !_showPass,
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),

                          // Column 2: Institutional Affiliation
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader('Institutional Affiliation', isDark),
                                _formField(
                                  label: 'University Name *',
                                  controller: _varsityCtrl,
                                  hint: 'Ahsanullah University of Science...',
                                  icon: Icons.school_outlined,
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 14),
                                _formField(
                                  label: 'Faculty / University ID *',
                                  controller: _varsityIdCtrl,
                                  hint: 'e.g. 19.02.02.054',
                                  icon: Icons.badge_outlined,
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 14),
                                _formField(
                                  label: 'Department Office Address',
                                  controller: _addressCtrl,
                                  hint: 'Room 504, Dept of CSE, AUST',
                                  icon: Icons.location_on_outlined,
                                  maxLines: 4,
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Submit Button & Switch Link
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0284C7),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: _loading ? null : _register,
                                child: _loading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2),
                                      )
                                    : Text(
                                        'Create Account',
                                        style: AppTypography.body(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: widget.onGoToLogin,
                            child: Text(
                              'Already have an account? Sign In',
                              style: AppTypography.body(
                                fontSize: 13,
                                color: const Color(0xFF38BDF8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.body(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _formField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    int maxLines = 1,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFCBD5E1),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            maxLines: maxLines,
            style: AppTypography.body(
              fontSize: 13,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  size: 18),
              suffixIcon: suffix,
              hintText: hint,
              hintStyle: AppTypography.body(
                fontSize: 13,
                color: const Color(0xFF64748B),
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
