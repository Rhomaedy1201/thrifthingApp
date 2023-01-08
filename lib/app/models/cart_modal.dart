class CartModal {
  CartModal({
    this.idKeranjang,
    this.idProduk,
    this.idUserPembeli,
    this.idUserPenjual,
    this.jumlah,
    this.total,
    this.idKategori,
    this.namaProduk,
    this.harga,
    this.stok,
    this.gambar,
    this.berat,
    this.id_kota_penjual,
    this.nama_penjual,
  });

  String? idKeranjang;
  String? idProduk;
  String? idUserPembeli;
  String? idUserPenjual;
  int? jumlah;
  int? total;
  String? idKategori;
  String? namaProduk;
  int? harga;
  int? stok;
  String? gambar;
  int? berat;
  String? id_kota_penjual;
  String? nama_penjual;

  factory CartModal.fromJson(Map<String, dynamic> json) => CartModal(
        idKeranjang: json["id_keranjang"],
        idProduk: json["id_produk"],
        idUserPembeli: json["id_user_pembeli"],
        idUserPenjual: json["id_user_penjual"],
        jumlah: json["jumlah"],
        total: json["total"],
        idKategori: json["id_kategori"],
        namaProduk: json["nama_produk"],
        harga: json["harga"],
        stok: json["stok"],
        gambar: json["gambar"],
        berat: json["berat"],
        id_kota_penjual: json["id_kota_penjual"],
        nama_penjual: json["nama_penjual"],
      );

  Map<String, dynamic> toJson() => {
        "id_keranjang": idKeranjang,
        "id_produk": idProduk,
        "id_user_pembeli": idUserPembeli,
        "id_user_penjual": idUserPenjual,
        "jumlah": jumlah,
        "total": total,
        "id_kategori": idKategori,
        "nama_produk": namaProduk,
        "harga": harga,
        "stok": stok,
        "gambar": gambar,
        "berat": berat,
        "id_kota_penjual": id_kota_penjual,
        "nama_penjual": nama_penjual,
      };
}
