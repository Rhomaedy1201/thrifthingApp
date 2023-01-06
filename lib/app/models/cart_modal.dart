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
      };
}
