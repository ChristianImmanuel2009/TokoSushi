class ResponseDataList {

  bool status;
  String message;
  List? data; // Bisa diisi dengan tipe data apa saja sesuai kebutuhan
  ResponseDataList({  // Konstruktor
    required this.status,
    required this.message,
    this.data,
  });
}