class CategoryModal {
  CategoryModal({
    this.idKategori,
    this.namaKategori,
    this.gambar,
  });

  String? idKategori;
  String? namaKategori;
  String? gambar;

  factory CategoryModal.fromJson(Map<String, dynamic> json) => CategoryModal(
        idKategori: json["id_kategori"],
        namaKategori: json["nama_kategori"],
        gambar: json["gambar"],
      );

  Map<String, dynamic> toJson() => {
        "id_kategori": idKategori,
        "nama_kategori": namaKategori,
        "gambar": gambar,
      };
}
