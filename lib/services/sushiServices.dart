import 'dart:convert';
import 'package:aplikasimu/models/response_data_list.dart';
import 'package:aplikasimu/models/sushikuModels.dart';
import 'package:aplikasimu/models/user_login.dart';
import 'package:aplikasimu/services/url.dart' as url;
import 'package:http/http.dart' as http;

class SushiService {
  // Fungsi Helper untuk mengambil Token agar tidak duplikasi kode
  Future<String?> _getToken() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    return user.status == true ? user.token : null;
  }

  // 1. GET DATA (READ)
  Future<ResponseDataList> getbarang() async {
    String? token = await _getToken();
    
    if (token == null) {
      return ResponseDataList(
        status: false,
        message: 'Anda belum login / token invalid',
      );
    }

    var uri = Uri.parse("${url.baseUrl}/admin/getbarang");
    Map<String, String> headers = {"Authorization": 'Bearer $token'};

    try {
      var responseGet = await http.get(uri, headers: headers);
      var data = json.decode(responseGet.body);

      if (responseGet.statusCode == 200) {
        if (data["status"] == true) {
          List barang = data["data"].map((r) => sushikuModels.fromJson(r)).toList();
          return ResponseDataList(
            status: true,
            message: 'success load data',
            data: barang,
          );
        } else {
          return ResponseDataList(status: false, message: data["message"] ?? 'Failed load data');
        }
      } else {
        return ResponseDataList(status: false, message: 'Server Error: ${responseGet.statusCode}');
      }
    } catch (e) {
      return ResponseDataList(status: false, message: 'Terjadi kesalahan: $e');
    }
  }

  // 2. TAMBAH BARANG (CREATE) -> INI YANG TADI HILANG
  Future<bool> addBarang(String nama, String harga, String deskripsi, String image) async {
    String? token = await _getToken();
    var uri = Uri.parse("${url.baseUrl}/admin/tambahbarang"); 
    
    try {
      var response = await http.post(
        uri,
        headers: {
          "Authorization": 'Bearer $token',
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "nama_barang": nama,
          "harga": harga,
          "deskripsi": deskripsi,
          "image": image,
        }),
      );
      var data = json.decode(response.body);
      return data["status"] == true;
    } catch (e) {
      print("Error addBarang: $e");
      return false;
    }
  }

  // 3. UPDATE BARANG (UPDATE)
  Future<bool> updateBarang(int id, String nama, String harga, String deskripsi, String image) async {
    String? token = await _getToken();
    var uri = Uri.parse("${url.baseUrl}/admin/updatebarang/$id"); 
    
    try {
      var response = await http.put(
        uri,
        headers: {
          "Authorization": 'Bearer $token',
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "nama_barang": nama,
          "harga": harga,
          "deskripsi": deskripsi,
          "image": image,
        }),
      );
      var data = json.decode(response.body);
      return data["status"] == true;
    } catch (e) {
      print("Error updateBarang: $e");
      return false;
    }
  }

  // 4. DELETE BARANG (DELETE)
  Future<bool> deleteBarang(int id) async {
    String? token = await _getToken();
    var uri = Uri.parse("${url.baseUrl}/admin/hapusbarang/$id"); 
    
    try {
      var response = await http.delete(
        uri,
        headers: {"Authorization": 'Bearer $token'},
      );
      var data = json.decode(response.body);
      return data["status"] == true;
    } catch (e) {
      print("Error deleteBarang: $e");
      return false;
    }
  }
}