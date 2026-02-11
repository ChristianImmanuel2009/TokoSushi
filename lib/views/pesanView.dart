import 'package:aplikasimu/models/user_login.dart';
import 'package:aplikasimu/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PesanView extends StatefulWidget {
  const PesanView({super.key});

  @override
  State<PesanView> createState() => _PesanViewState();
}

class _PesanViewState extends State<PesanView> {
  UserLogin userLogin = UserLogin();
  String? nama;
  String? role;
  String activeFilter = "Selesai";

  final Color primaryBlue = const Color(0xFF0D47A1);

  final List<Map<String, dynamic>> orderData = [
    {
      "shop_name": "Doni Aldian",
      "status": "Selesai",
      "product_name": "Kartu Printable inkjet id card blueprin...",
      "variant": "isi 50",
      "quantity": 2,
      "price": "Rp 53.998",
      "total_payment": "Rp 107.836",
      "image": "https://images.unsplash.com/photo-1617196034183-421b4917c92d?w=500",
    },
    {
      "shop_name": "Owen Araki",
      "status": "Selesai",
      "product_name": "LANYARD PRINTING CUSTOM",
      "variant": "2 cm, 2 sisi",
      "quantity": 6,
      "price": "Rp 9.100",
      "total_payment": "Rp 525.420",
      "image": "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=500",
    },
    {
      "shop_name": "Andri",
      "status": "Disajikan",
      "product_name": "Salmon Mentai Roll",
      "variant": "Large Size",
      "quantity": 1,
      "price": "Rp 45.000",
      "total_payment": "Rp 45.000",
      "image": "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=500",
    },
  ];

  getUserLogin() async {
    var user = await userLogin.getUserLogin();
    if (user.status != false) {
      setState(() {
        nama = user.nama_user;
        role = user.role;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    List filteredOrders = orderData.where((o) => o['status'] == activeFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE8EAF6),
      body: Column(
        children: [
          const SizedBox(height: 60),
          // --- HEADER: Style Sushiku ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "List Pesanan",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: primaryBlue,
                      ),
                    ),
                    Text(
                      "Halo ${nama ?? '...'}, jangan lupa konfirmasi!",
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                _buildProfileAvatar(),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // --- MAIN CONTAINER ---
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // --- TAB FILTER (Badge Style) ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 25, 24, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFilterBadge("Disajikan"),
                        _buildFilterBadge("Diantar"),
                        _buildFilterBadge("Selesai"),
                      ],
                    ),
                  ),

                  // --- LIST CONTENT ---
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: filteredOrders.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              itemCount: filteredOrders.length,
                              itemBuilder: (context, index) {
                                return _buildOrderCard(filteredOrders[index]);
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(1),
    );
  }

  Widget _buildProfileAvatar() {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, color: Colors.grey[400], size: 30),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            role?.toUpperCase() ?? "USER",
            style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBadge(String label) {
    bool isActive = activeFilter == label;
    return GestureDetector(
      onTap: () => setState(() => activeFilter = label),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? primaryBlue : const Color(0xFFF0F2F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isActive ? Colors.white : primaryBlue,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Bagian Atas: Toko & Status
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.storefront, size: 16, color: primaryBlue),
                    const SizedBox(width: 8),
                    Text(data['shop_name'],
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13)),
                  ],
                ),
                Text(data['status'],
                    style: GoogleFonts.poppins(
                        color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(height: 1),
          // Bagian Tengah: Detail Produk
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(data['image'], width: 70, height: 70, fit: BoxFit.cover),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['product_name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                      Text(data['variant'],
                          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 11)),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("x${data['quantity']}", style: GoogleFonts.poppins(fontSize: 11)),
                          Text(data['price'],
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, color: primaryBlue, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Bagian Bawah: Total & Tombol
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Pesanan",
                        style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                    Text(data['total_payment'],
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 15)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  ),
                  child: Text("Konfirmasi",
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          Text("Belum ada transaksi di tab ini",
              style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 14)),
        ],
      ),
    );
  }
}