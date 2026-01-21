import 'dart:convert';
import 'dart:io';
import 'package:aplikasimu/models/response_data_map.dart';
import 'package:aplikasimu/models/user_login.dart';
import 'package:aplikasimu/services/url.dart' as url;
import 'package:http/http.dart' as http;

class UserService {
  // Gunakan header standar untuk API JSON
  final Map<String, String> _headers = {
    'Accept': 'application/json',
  };

  /// --- FUNGSI REGISTER ---
  Future<ResponseDataMap> registerUser(Map<String, dynamic> dataInput) async {
    try {
      final uri = Uri.parse("${url.baseUrl}/auth/register");
      final response = await http.post(uri, body: dataInput, headers: _headers);

      final dynamic decodedData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (decodedData["status"] == true) {
          return ResponseDataMap(
            status: true,
            message: "Akun berhasil didaftarkan",
            data: decodedData,
          );
        } else {
          // Mengambil pesan validasi dari API (biasanya berupa Map list)
          String errorMessage = '';
          if (decodedData["message"] is Map) {
            decodedData["message"].forEach((key, value) {
              errorMessage += "${value[0]}\n";
            });
          } else {
            errorMessage = decodedData["message"] ?? "Gagal mendaftar";
          }

          return ResponseDataMap(status: false, message: errorMessage.trim());
        }
      } else {
        return ResponseDataMap(
          status: false,
          message: "Error ${response.statusCode}: Terjadi kesalahan pada server",
        );
      }
    } on SocketException {
      return ResponseDataMap(status: false, message: "Tidak ada koneksi internet");
    } catch (e) {
      return ResponseDataMap(status: false, message: "Terjadi kesalahan: $e");
    }
  }

  /// --- FUNGSI LOGIN ---
  Future<ResponseDataMap> loginUser(Map<String, dynamic> dataInput) async {
    try {
      final uri = Uri.parse("${url.baseUrl}/auth/login");
      final response = await http.post(uri, body: dataInput, headers: _headers);

      final dynamic decodedData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (decodedData["status"] == true) {
          // Inisialisasi Model UserLogin
          UserLogin userLogin = UserLogin(
            status: decodedData["status"],
            token: decodedData["token"],
            message: decodedData["message"],
            id: decodedData["user"]["id"],
            nama_user: decodedData["user"]["nama_user"],
            email: decodedData["user"]["email"],
            role: decodedData["user"]["role"],
          );

          // Simpan ke SharedPreferences
          await userLogin.prefs();

          return ResponseDataMap(
            status: true,
            message: "Selamat datang kembali!",
            data: decodedData,
          );
        } else {
          return ResponseDataMap(
            status: false,
            message: decodedData["message"] ?? "Email atau Password salah",
          );
        }
      } else {
        return ResponseDataMap(
          status: false,
          message: "Login gagal (Code: ${response.statusCode})",
        );
      }
    } on SocketException {
      return ResponseDataMap(status: false, message: "Koneksi internet terputus");
    } catch (e) {
      return ResponseDataMap(status: false, message: "Gagal terhubung ke server");
    }
  }
}