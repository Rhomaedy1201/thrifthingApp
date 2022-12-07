class ProdukUser {
  final String id_produk;
  final String id_user;
  final String id_kategori;
  final String email;
  final String nama_lengkap;
  final String no_hp;
  final String nama_kategori;
  final String kota;
  final String nama_produk;
  final String harga;
  final String stok;
  final String gambar;
  final String kondisi;
  final String bahan;
  final String merek;
  final String motif;
  final String deskripsi;
  final String terjual;

  const ProdukUser({
    required this.id_produk,
    required this.id_user,
    required this.id_kategori,
    required this.email,
    required this.nama_lengkap,
    required this.no_hp,
    required this.nama_kategori,
    required this.kota,
    required this.nama_produk,
    required this.harga,
    required this.stok,
    required this.gambar,
    required this.kondisi,
    required this.bahan,
    required this.merek,
    required this.motif,
    required this.deskripsi,
    required this.terjual,
  });

  factory ProdukUser.fromJson(Map<String, dynamic> json) {
    return ProdukUser(
      id_produk: json['id_produk'],
      id_user: json['id_user'],
      id_kategori: json['id_kategori'],
      email: json['email'],
      nama_lengkap: json['nama_lengkap'],
      no_hp: json['no_hp'],
      nama_kategori: json['nama_kategori'],
      kota: json['kota'],
      nama_produk: json['nama_produk'],
      harga: json['harga'],
      stok: json['stok'],
      gambar: json['gambar'],
      kondisi: json['kondisi'],
      bahan: json['bahan'],
      merek: json['merek'],
      motif: json['motif'],
      deskripsi: json['deskripsi'],
      terjual: json['terjual'],
    );
  }
}
