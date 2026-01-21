import 'package:aplikasimu/services/user.dart';
import 'package:aplikasimu/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserService userService = UserService();
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;
  bool showPass = true;

  // Style input dengan Poppins
  InputDecoration prototypeInput(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF004AAD), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- BACKGROUND GRADIENT ---
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE0E7FF), Color(0xFFF3E8FF)],
              ),
            ),
          ),          
          

          // --- CONTENT ---
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // --- LOGO ---
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "image/susilogo.png",
                      width: 90,
                      height: 90,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.store,
                        size: 80,
                        color: Color(0xFF004AAD),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- KARTU PUTIH (FORM) ---
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Text(
                            "Hai!",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF004AAD),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Senang bertemu kembali!",
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // INPUT EMAIL
                          TextFormField(
                            controller: email,
                            style: GoogleFonts.poppins(fontSize: 14),
                            decoration: prototypeInput("Email"),
                            validator: (val) =>
                                val!.isEmpty ? "Email wajib diisi" : null,
                          ),
                          const SizedBox(height: 15),

                          // INPUT PASSWORD
                          TextFormField(
                            controller: password,
                            obscureText: showPass,
                            style: GoogleFonts.poppins(fontSize: 14),
                            decoration: prototypeInput(
                              "Password",
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => showPass = !showPass),
                                icon: Icon(
                                  showPass
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? "Password wajib diisi" : null,
                          ),
                          const SizedBox(height: 30),

                          // --- LOGIN BUTTON ---
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  255,
                                  171,
                                  55,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 0,
                              ),
                              onPressed: isLoading ? null : _handleLogin,
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      "Login",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // --- FOOTER ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Belum punya akun? ",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/register',
                                ),
                                child: Text(
                                  "Daftar sekarang",
                                  style: GoogleFonts.poppins(
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      171,
                                      55,
                                    ),
                                    fontSize: 10,
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
          ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/register');
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      var data = {"email": email.text, "password": password.text};
      var result = await userService.loginUser(data);
      setState(() => isLoading = false);

      if (result.status == true) {
        AlertMessage().showAlert(context, result.message, true);
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/dashboard');
        });
      } else {
        AlertMessage().showAlert(context, result.message, false);
      }
    }
  }
}
