import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> items = prefs.getStringList('cart') ?? [];
    
    setState(() {
      cartItems = items.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    });
  }

  Future<void> _removeFromCart(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> items = prefs.getStringList('cart') ?? [];
    items.removeAt(index);
    await prefs.setStringList('cart', items);
    _loadCart(); // Refresh tampilan
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(
        title: Text("Keranjang Saya", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 0,
      ),
      body: cartItems.isEmpty
          ? Center(child: Text("Keranjang kosong", style: GoogleFonts.poppins()))
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item['image'] ?? "",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                      ),
                    ),
                    title: Text(item['namaBarang'] ?? "Sushi", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    subtitle: Text("Rp ${item['harga']}", style: GoogleFonts.poppins(color: Colors.orange[800], fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _removeFromCart(index),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: _buildTotalSection(),
    );
  }

  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D47A1),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () {
          // Aksi Checkout
        },
        child: Text("Checkout Sekarang", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}