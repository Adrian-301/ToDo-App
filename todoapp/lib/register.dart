import 'package:flutter/material.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameCtrl        = TextEditingController();
  final TextEditingController _emailCtrl           = TextEditingController();
  final TextEditingController _passwordCtrl        = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  bool _isPasswordHidden        = true;
  bool _isConfirmPasswordHidden = true;

  static const Color kDodgerBlue = Color(0xFF1E90FF);
  static const Color kLightBlue  = Color(0xFFE8F4FF);
  static const Color kDarkBlue   = Color(0xFF1565C0);

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _register() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 45),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kDarkBlue, kDodgerBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.person_add_alt_1_outlined,
                      size: 70, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Buat Akun',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Daftar untuk mulai menggunakan MyTasks',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),

            // ── Form ────────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Username
                    TextField(
                      controller: _usernameCtrl,
                      decoration:
                          _inputDeco('Username', Icons.person_outline),
                    ),

                    const SizedBox(height: 18),

                    // Email
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          _inputDeco('Email', Icons.email_outlined),
                    ),

                    const SizedBox(height: 18),

                    // Password
                    TextField(
                      controller: _passwordCtrl,
                      obscureText: _isPasswordHidden,
                      decoration: _inputDeco(
                        'Password',
                        Icons.lock_outline,
                        suffix: IconButton(
                          icon: Icon(
                            _isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: kDodgerBlue,
                          ),
                          onPressed: () => setState(
                              () => _isPasswordHidden = !_isPasswordHidden),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Konfirmasi Password
                    TextField(
                      controller: _confirmPasswordCtrl,
                      obscureText: _isConfirmPasswordHidden,
                      decoration: _inputDeco(
                        'Konfirmasi Password',
                        Icons.lock_reset_outlined,
                        suffix: IconButton(
                          icon: Icon(
                            _isConfirmPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: kDodgerBlue,
                          ),
                          onPressed: () => setState(
                              () => _isConfirmPasswordHidden =
                                  !_isConfirmPasswordHidden),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Tombol Daftar
                    GestureDetector(
                      onTap: _register,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [kDarkBlue, kDodgerBlue],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: kDodgerBlue.withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'DAFTAR',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Navigasi ke Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun? ',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginPage()),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: kDodgerBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint, IconData icon, {Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: kDodgerBlue),
        suffixIcon: suffix,
        filled: true,
        fillColor: kLightBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kDodgerBlue, width: 1.5),
        ),
      );
}
