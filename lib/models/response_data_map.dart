class ResponseDataMap {
  bool status;
  String message;
  Map? data; // bagian ini bisa diisi dengan tipe data apa saja sesuai kebutuhan
  ResponseDataMap({  // inii konstruktornyaaa ya keris
    required this.status,
    required this.message,
    this.data,
  });
}