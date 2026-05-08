import 'package:flutter/material.dart';
import 'main.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  static const Color dodgerBlue = Color(0xFF1E90FF);
  static const Color lightBlue = Color(0xFFE8F4FF);
  static const Color darkBlue = Color(0xFF1565C0);

  void register() {
    if (usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text ==
            confirmPasswordController.text) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 45),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [darkBlue, dodgerBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: const [
                  Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 70,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Register to start using MyTasks",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // USERNAME
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: "Username",
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: dodgerBlue,
                        ),
                        filled: true,
                        fillColor: lightBlue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // EMAIL
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: dodgerBlue,
                        ),
                        filled: true,
                        fillColor: lightBlue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // PASSWORD
                    TextField(
                      controller: passwordController,
                      obscureText: isPasswordHidden,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: dodgerBlue,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: dodgerBlue,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordHidden =
                                  !isPasswordHidden;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: lightBlue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // CONFIRM PASSWORD
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: isConfirmPasswordHidden,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        prefixIcon: const Icon(
                          Icons.lock_reset_outlined,
                          color: dodgerBlue,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isConfirmPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: dodgerBlue,
                          ),
                          onPressed: () {
                            setState(() {
                              isConfirmPasswordHidden =
                                  !isConfirmPasswordHidden;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: lightBlue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // REGISTER BUTTON
                    GestureDetector(
                      onTap: register,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [darkBlue, dodgerBlue],
                          ),
                          borderRadius:
                              BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  dodgerBlue.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "REGISTER",
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

                    // LOGIN NAVIGATION
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: dodgerBlue,
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
}
