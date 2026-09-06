import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

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
      setState(() => _error = 'ইমেইল এবং পাসওয়ার্ড দিন');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    await Future.delayed(const Duration(milliseconds: 600));
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
    return Scaffold(
      backgroundColor: const Color(0xFF060D1A),
      body: Row(
        children: [
          // Left panel — branding
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A1628), Color(0xFF0D1F3C)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0284C7), Color(0xFF6366F1)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.school,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Text('ACADDIE',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                              letterSpacing: 2,
                            )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Think. Simulate. Decide.',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF38BDF8),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 48),
                    Text('AI-Powered Academic\nDecision Assistant',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        )),
                    const SizedBox(height: 20),
                    Text(
                        'Faculty members can simulate curriculum\nchanges before making them — understanding\nthe full impact across courses, CLOs, and students.',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF64748B),
                          fontSize: 15,
                          height: 1.7,
                        )),
                    const SizedBox(height: 48),
                    // Feature bullets
                    ...[
                      ('⚡', '7-Dimension Impact Analysis'),
                      ('🗺️', 'Live Academic Dependency Map'),
                      ('🔀', 'What-If Plan Comparison'),
                      ('🎓', 'Faculty Decision Authority'),
                    ].map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            children: [
                              Text(item.$1, style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 12),
                              Text(item.$2,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 14,
                                  )),
                            ],
                          ),
                        )),
                    const SizedBox(height: 48),
                    Text('AUST CSE Carnival 8.0 — AI Build Hackathon',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF334155),
                          fontSize: 11,
                        )),
                  ],
                ),
              ),
            ),
          ),

          // Right panel — login form
          Container(
            width: 440,
            color: const Color(0xFF080F1E),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('স্বাগতম!',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 6),
                    Text('আপনার অ্যাকাউন্টে লগইন করুন',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF64748B),
                          fontSize: 14,
                        )),
                    const SizedBox(height: 36),

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
                              child: Text(_error!,
                                  style: GoogleFonts.inter(
                                      color: const Color(0xFFF87171),
                                      fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Email field
                    _label('ইমেইল ঠিকানা'),
                    _inputField(
                      controller: _emailCtrl,
                      hint: 'example@aust.edu',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    _label('পাসওয়ার্ড'),
                    _inputField(
                      controller: _passCtrl,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscure: !_showPass,
                      suffix: IconButton(
                        icon: Icon(
                            _showPass
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF475569),
                            size: 18),
                        onPressed: () =>
                            setState(() => _showPass = !_showPass),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0284C7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _loading ? null : _login,
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : Text('লগইন করুন',
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                                color: Colors.white.withValues(alpha: 0.08))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('অথবা',
                              style: GoogleFonts.inter(
                                  color: const Color(0xFF475569),
                                  fontSize: 12)),
                        ),
                        Expanded(
                            child: Divider(
                                color: Colors.white.withValues(alpha: 0.08))),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Register link
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.15)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: widget.onGoToRegister,
                        child: Text('নতুন অ্যাকাউন্ট তৈরি করুন',
                            style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: GoogleFonts.inter(
              color: const Color(0xFF94A3B8),
              fontSize: 13,
              fontWeight: FontWeight.w500)),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      onSubmitted: (_) => _login(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
            color: const Color(0xFF334155), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF475569), size: 18),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFF0F172A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0284C7)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
  final _varsityCtrl = TextEditingController();
  final _varsityIdCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _showPass = false;

  @override
  void initState() {
    super.initState();
    // Prefill with AUST for hackathon demo
    _varsityCtrl.text = 'Ahsanullah University of Science and Technology';
  }

  Future<void> _register() async {
    if (_passCtrl.text != _confirmPassCtrl.text) {
      setState(() => _error = 'পাসওয়ার্ড দুটো মিলছে না');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    await Future.delayed(const Duration(milliseconds: 700));
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
    return Scaffold(
      backgroundColor: const Color(0xFF060D1A),
      body: Row(
        children: [
          // Left branding panel
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A1628), Color(0xFF0D1F3C)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0284C7), Color(0xFF6366F1)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.school,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Text('ACADDIE',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                              letterSpacing: 2,
                            )),
                      ],
                    ),
                    const SizedBox(height: 48),
                    Text('Faculty\nPlatform',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        )),
                    const SizedBox(height: 16),
                    Text(
                        'আপনার একাডেমিক প্রোফাইল তৈরি করুন।\nএকবার তৈরি করলে আর করতে হবে না।',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF64748B),
                          fontSize: 15,
                          height: 1.7,
                        )),
                    const SizedBox(height: 48),
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
                          Text('রেজিস্ট্রেশনের পর আপনি পারবেন:',
                              style: GoogleFonts.inter(
                                  color: const Color(0xFF38BDF8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          const SizedBox(height: 12),
                          ...[
                            'সিলেবাস পরিবর্তনের আগে impact বিশ্লেষণ করুন',
                            'CLO, prerequisite, downstream course দেখুন',
                            'What-If Plan A, B, C তুলনা করুন',
                            'Official academic report export করুন',
                          ].map((t) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Color(0xFF10B981), size: 16),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Text(t,
                                            style: GoogleFonts.inter(
                                                color: const Color(0xFF94A3B8),
                                                fontSize: 13))),
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

          // Right form panel
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFF080F1E),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('নতুন অ্যাকাউন্ট তৈরি করুন',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 6),
                      Text('সব তারকা (*) চিহ্নিত ঘর পূরণ করা বাধ্যতামূলক',
                          style: GoogleFonts.inter(
                              color: const Color(0xFF475569), fontSize: 13)),
                      const SizedBox(height: 28),

                      if (_error != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color(0xFFEF4444)
                                    .withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Color(0xFFF87171), size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(_error!,
                                    style: GoogleFonts.inter(
                                        color: const Color(0xFFF87171),
                                        fontSize: 13)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Two-column layout
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Column 1
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader('ব্যক্তিগত তথ্য'),
                                _formField('পূর্ণ নাম *', _fullNameCtrl,
                                    'আপনার পূর্ণ নাম', Icons.person_outline),
                                const SizedBox(height: 14),
                                _formField('ইমেইল ঠিকানা *', _emailCtrl,
                                    'example@aust.edu', Icons.email_outlined),
                                const SizedBox(height: 14),
                                _formField('ফোন নম্বর', _phoneCtrl,
                                    '01XXXXXXXXX', Icons.phone_outlined),
                                const SizedBox(height: 14),
                                _formField(
                                    'পাসওয়ার্ড * (কমপক্ষে ৬ অক্ষর)',
                                    _passCtrl,
                                    '••••••••',
                                    Icons.lock_outline,
                                    obscure: !_showPass,
                                    suffix: IconButton(
                                      icon: Icon(
                                          _showPass
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: const Color(0xFF475569),
                                          size: 18),
                                      onPressed: () => setState(
                                          () => _showPass = !_showPass),
                                    )),
                                const SizedBox(height: 14),
                                _formField('পাসওয়ার্ড নিশ্চিত করুন *',
                                    _confirmPassCtrl, '••••••••',
                                    Icons.lock_outline,
                                    obscure: !_showPass),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Column 2
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader('বিশ্ববিদ্যালয়ের তথ্য'),
                                _formField('বিশ্ববিদ্যালয়ের নাম *',
                                    _varsityCtrl,
                                    'Ahsanullah University of Science...',
                                    Icons.school_outlined),
                                const SizedBox(height: 14),
                                _formField('বিশ্ববিদ্যালয় আইডি *',
                                    _varsityIdCtrl, 'যেমন: 19.02.02.054',
                                    Icons.badge_outlined),
                                const SizedBox(height: 14),
                                _formField('ঠিকানা', _addressCtrl,
                                    'আপনার বর্তমান ঠিকানা',
                                    Icons.location_on_outlined,
                                    maxLines: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Register button
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0284C7),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
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
                                    : Text('অ্যাকাউন্ট তৈরি করুন',
                                        style: GoogleFonts.inter(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: widget.onGoToLogin,
                            child: Text('আগে থেকে অ্যাকাউন্ট আছে? লগইন করুন',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF38BDF8),
                                    fontSize: 13)),
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

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(title,
          style: GoogleFonts.inter(
              color: const Color(0xFF38BDF8),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5)),
    );
  }

  Widget _formField(
    String label,
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool obscure = false,
    Widget? suffix,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          maxLines: maxLines,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
                color: const Color(0xFF334155), fontSize: 13),
            prefixIcon: maxLines == 1
                ? Icon(icon, color: const Color(0xFF475569), size: 17)
                : null,
            suffixIcon: suffix,
            filled: true,
            fillColor: const Color(0xFF0F172A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0284C7)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}
