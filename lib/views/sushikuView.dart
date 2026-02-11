import 'dart:convert';
import 'package:aplikasimu/models/response_data_list.dart';
import 'package:aplikasimu/models/sushikuModels.dart';
import 'package:aplikasimu/services/sushiServices.dart';
import 'package:aplikasimu/views/keranjangSushi.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aplikasimu/widgets/bottomNavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SushikuView extends StatefulWidget {
  const SushikuView({super.key});

  @override
  State<SushikuView> createState() => _SushikuViewState();
}
class DetailSushiku extends StatelessWidget {
  final sushikuModels item;
  const DetailSushiku({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.nama_barang ?? "Detail"), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(item.image ?? "", width: double.infinity, height: 300, fit: BoxFit.cover, 
              errorBuilder: (context, e, s) => Container(height: 300, color: Colors.grey, child: const Icon(Icons.broken_image, size: 50))),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.nama_barang ?? "", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Rp ${item.harga}", style: GoogleFonts.poppins(fontSize: 20, color: Colors.orange[800], fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  Text("Deskripsi", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text(item.deskripsi ?? "Tidak ada deskripsi", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700], height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SushikuViewState extends State<SushikuView> {
  SushiService sushi = SushiService();
  List<dynamic>? barang;
  List<dynamic> _filteredbarang = [];
  int _cartCount = 0; // Variabel untuk jumlah keranjang

  @override
  void initState() {
    super.initState();
    getbarang();
    _loadCartCount(); // Ambil jumlah keranjang saat start
  }

  // --- API OPERATIONS ---

  Future<void> getbarang() async {
    ResponseDataList result = await sushi.getbarang();
    if (mounted) {
      setState(() {
        if (result.status == true) {
          barang = result.data;
          _filteredbarang = result.data ?? [];
        } else {
          barang = [];
          _filteredbarang = [];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.message ?? "Gagal memuat data")),
          );
        }
      });
    }
  }

  Future<void> hapusBarang(int id) async {
    bool confirm = await _showConfirmDialog();
    if (confirm) {
      bool success = await sushi.deleteBarang(id);
      if (success) {
        getbarang();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Berhasil dihapus")));
      }
    }
  }

  // --- LOCAL STORAGE OPERATION ---

  Future<void> _loadCartCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList('cart') ?? [];
    setState(() {
      _cartCount = cartItems.length;
    });
  }

  Future<void> addToCart(sushikuModels item) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList('cart') ?? [];

    cartItems.add(
      jsonEncode({
        'namaBarang': item.nama_barang,
        'harga': item.harga,
        'image': item.image,
      }),
    );

    await prefs.setStringList('cart', cartItems);
    _loadCartCount(); // Update angka badge setelah tambah barang

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${item.nama_barang} masuk keranjang!")),
    );
  }

  // --- UI DIALOGS & MODALS ---

  Future<bool> _showConfirmDialog() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Hapus Data?"),
            content: const Text("Apakah anda yakin ingin menghapus sushi ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showFormModal(sushikuModels? item) {
    final isEdit = item != null;
    final namaController = TextEditingController(text: isEdit ? item.nama_barang : "");
    final hargaController = TextEditingController(text: isEdit ? item.harga.toString() : "");
    final descController = TextEditingController(text: isEdit ? item.deskripsi : "");
    // Tambahkan controller untuk link gambar
    final imageController = TextEditingController(text: isEdit ? item.image : "https://via.placeholder.com/150");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: SingleChildScrollView( // Agar tidak overflow saat keyboard muncul
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isEdit ? "Edit Sushi" : "Tambah Sushi", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(controller: namaController, decoration: const InputDecoration(labelText: "Nama Sushi")),
              TextField(controller: hargaController, decoration: const InputDecoration(labelText: "Harga"), keyboardType: TextInputType.number),
              TextField(controller: descController, decoration: const InputDecoration(labelText: "Deskripsi"), maxLines: 3),
              TextField(controller: imageController, decoration: const InputDecoration(labelText: "Link URL Gambar")),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1), minimumSize: const Size(double.infinity, 50)),
                onPressed: () async {
                  bool success;
                  if (isEdit) {
                    success = await sushi.updateBarang(
                      item.id!, 
                      namaController.text, 
                      hargaController.text, 
                      descController.text, 
                      imageController.text // Menggunakan input gambar baru
                    );
                  } else {
                    success = await sushi.addBarang(
                      namaController.text, 
                      hargaController.text, 
                      descController.text, 
                      imageController.text
                    );
                  }
                  if (success) {
                    Navigator.pop(context);
                    getbarang();
                  }
                },
                child: Text(isEdit ? "Update Data" : "Simpan Data", style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = barang ?? [];
    } else {
      results = barang!
          .where(
            (item) => item.namaBarang!.toLowerCase().contains(
              enteredKeyword.toLowerCase(),
            ),
          )
          .toList();
    }
    setState(() {
      _filteredbarang = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: const Color(0xFFE8EAF6),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue,
        onPressed: () => _showFormModal(null),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 60),
          _buildHeader(primaryBlue),
          _buildSearchBar(primaryBlue),
          _buildProductGrid(primaryBlue),
        ],
      ),
      bottomNavigationBar: BottomNav(1),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildHeader(Color primaryBlue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "SushiKu",
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: primaryBlue,
            ),
          ),
          Row(
            children: [
              // ICON KERANJANG DENGAN BADGE
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: primaryBlue,
                      size: 28,
                    ),
                    onPressed: () async {
                      // Navigasi ke halaman keranjang
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartView(),
                        ),
                      );
                      // Setelah kembali dari halaman keranjang, refresh badge angka
                      _loadCartCount();
                    },
                  ),
                  if (_cartCount > 0) // Badge hanya muncul jika ada isi
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$_cartCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(Icons.settings, color: primaryBlue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(Color primaryBlue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) => _runFilter(value),
          decoration: InputDecoration(
            hintText: 'Cari sushi...',
            hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: primaryBlue),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(Color primaryBlue) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: barang == null
              ? const Center(child: CircularProgressIndicator())
              : (_filteredbarang.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                            ),
                        itemCount: _filteredbarang.length,
                        itemBuilder: (context, index) {
                          final sushikuModels item = _filteredbarang[index];
                          return _buildGridItem(item, primaryBlue);
                        },
                      )
                    : Center(
                        child: Text(
                          "Data tidak ditemukan",
                          style: GoogleFonts.poppins(),
                        ),
                      )),
        ),
      ),
    );
  }

 Widget _buildGridItem(sushikuModels item, Color theme) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    // Menggunakan Material & InkWell agar ada efek riak (ripple) saat kartu diklik
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // NAVIGASI KE HALAMAN DETAIL
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailSushiku(item: item),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Stack(
                children: [
                  Image.network(
                    item.image ?? "",
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                  // TOMBOL ACTION (EDIT & DELETE)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Row(
                      children: [
                        _buildActionBtn(
                          Icons.edit,
                          Colors.blue,
                          () => _showFormModal(item), // Tetap bisa edit
                        ),
                        const SizedBox(width: 4),
                        _buildActionBtn(
                          Icons.delete,
                          Colors.red,
                          () => hapusBarang(item.id!), // Tetap bisa hapus
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.nama_barang ?? "Tanpa Nama",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rp ${item.harga}",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                        ),
                        // TOMBOL KERANJANG
                        GestureDetector(
                          onTap: () => addToCart(item), // Tetap bisa add to cart
                          child: const Icon(
                            Icons.add_shopping_cart,
                            size: 20,
                            color: Colors.green,
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

  Widget _buildActionBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }
}
