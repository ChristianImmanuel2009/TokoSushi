import 'package:aplikasimu/models/user_login.dart'; // Import diaktifkan
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  // Mengaktifkan kembali inisialisasi model UserLogin
  UserLogin userLogin = UserLogin(); 
  String? nama;
  String? role;

  // Menggunakan logika asli Anda untuk mengambil data session/login
  getUserLogin() async {
    var user = await userLogin.getUserLogin();
    if (user.status != false) {
      setState(() {
        // Mengambil data dari properti model Anda
        nama = user.nama_user;
        role = user.role;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserLogin(); // Memanggil data saat halaman pertama kali dibuka
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EAF6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            
            // --- HEADER: WELCOME & PROFILE ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      // Menampilkan nama asli dari database, fallback ke 'Tamu' jika null
                      "Welcome, ${nama ?? '...'}!", 
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 45, color: Colors.grey),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            // Menampilkan role asli dari database
                            role?.toUpperCase() ?? "USER",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- SEARCH BAR ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    hintText: '    Sushi Tamago',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(Icons.search, color: Colors.black, size: 30),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // --- GRID MENU (8 Fitur) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.8,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                            )
                          ]
                        ),
                        child: Icon(Icons.apps, color: Color(0xFF0D47A1)), // Contoh Ikon
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Fitur ${index + 1}",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0D47A1),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // --- SECTION WHITE CONTAINER (Bawah) ---
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildPromoCard(
                      "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=500",
                      radius: 30.0,
                    ),
                    const SizedBox(height: 20),
                    _buildPromoCard(
                      "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=500",
                      radius: 30.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Tombol Logout tetap menggunakan navigasi Anda
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.logout, color: Colors.white),
      ),
    );
  }

  Widget _buildPromoCard(String imageUrl, {double radius = 30.0}) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}