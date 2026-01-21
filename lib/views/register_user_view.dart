import 'package:aplikasimu/services/user.dart';
import 'package:aplikasimu/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  State<RegisterUserView> createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {
  UserService userService = UserService();
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  List<String> roleChoice = ["admin", "kasir"];
  String? selectedRole;

  // 1. Tambahkan variabel state untuk kontrol mata password
  bool _obscurePassword = true;

  // 2. Perbarui prototypeInput agar mendukung suffixIcon
  InputDecoration prototypeInput(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon, // Tambahkan baris ini
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0E7FF), Color(0xFFF3E8FF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            children: [
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
              const SizedBox(height: 12),

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
                        "Register",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF004AAD),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Isi Form dibawah yaa!",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Nama
                      TextFormField(
                        controller: name,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: prototypeInput("Nama lengkap"),
                        validator: (val) =>
                            val!.isEmpty ? "Nama wajib diisi" : null,
                      ),
                      const SizedBox(height: 15),

                      // Email
                      TextFormField(
                        controller: email,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: prototypeInput("Masukkan Email"),
                        validator: (val) =>
                            val!.isEmpty ? "Email wajib diisi" : null,
                      ),
                      const SizedBox(height: 15),

                      // Dropdown Role
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                        decoration: prototypeInput("Pilih Role Akses"),
                        items: roleChoice.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value.toUpperCase(),
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedRole = val;
                          });
                        },
                        validator: (val) =>
                            val == null ? "Pilih role terlebih dahulu" : null,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      const SizedBox(height: 15),

                      // Password (DENGAN IKON MATA)
                      TextFormField(
                        controller: password,
                        obscureText: _obscurePassword,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: prototypeInput(
                          "Masukkan Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (val) =>
                            val!.length < 6 ? "Minimal 6 karakter" : null,
                      ),
                      const SizedBox(height: 30),

                      // --- REGISTER BUTTON ---
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 171, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              var data = {
                                "name": name.text,
                                "email": email.text,
                                "role": selectedRole,
                                "password": password.text,
                              };
                              var result = await userService.registerUser(data);
                              if (result.status == true) {
                                _clearForm();
                                AlertMessage().showAlert(
                                  context,
                                  result.message,
                                  true,
                                );
                              } else {
                                AlertMessage().showAlert(
                                  context,
                                  result.message,
                                  false,
                                );
                              }
                            }
                          },
                          child: Text(
                            "Daftarkan Akun",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- FOOTER ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sudah punya akun? ",
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                              context,
                              '/login',
                            ),
                            child: Text(
                              "Login sekarang",
                              style: GoogleFonts.poppins(
                                color: const Color.fromARGB(255, 255, 171, 55),
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
    );
  }

  void _clearForm() {
    name.clear();
    email.clear();
    password.clear();
    confirmPassword.clear();
    setState(() {
      selectedRole = null;
      _obscurePassword = true; // Reset mata password saat clear
    });
  }
}