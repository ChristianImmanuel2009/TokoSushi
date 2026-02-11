import 'package:aplikasimu/services/url.dart' as url;

class sushikuModels {
  int? id;
  String? nama_barang;
  String? deskripsi;
  int? stok;
  int? harga;
  String? image;

  sushikuModels({
    required this.id,
    this.nama_barang,
    this.deskripsi,
    this.stok,
    this.harga,
    this.image,
  });

  sushikuModels.fromJson(Map<String, dynamic> Json) {
    // Sesuaikan Key di sini dengan JSON dari Postman kamu
    id = Json["id"];
    nama_barang = Json["nama_barang"]; // Sesuai Postman
    deskripsi = Json["deskripsi"];   // Sesuai Postman
    stok = Json["stok"];             // Sesuai Postman
    harga = Json["harga"];           // Sesuai Postman
    
    // Untuk image, gabungkan dengan Base URL
    if (Json["image"] != null) {
      image = "${url.baseUrlTanpaAPi}/${Json["image"]}";
    } else {
      image = "https://via.placeholder.com/150";
    }
  }
}