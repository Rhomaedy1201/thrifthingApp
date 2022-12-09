class ProdukUser {
  final String id_produk;
  final String id_user;
  final String id_kategori;
  final String email;
  final String nama_lengkap;
  final String no_hp;
  final String profile;
  final String status;
  final String id_provinsi;
  final String provinsi;
  final String id_kota;
  final String kota;
  final String id_kecamatan;
  final String kecamatan;
  final String nama_kategori;
  final String nama_produk;
  final int harga;
  final int stok;
  final String gambar;
  final String kondisi;
  final String bahan;
  final String merek;
  final String ukuran;
  final int berat;
  final String motif;
  final String deskripsi;
  final int terjual;

  const ProdukUser({
    required this.id_produk,
    required this.id_user,
    required this.id_kategori,
    required this.email,
    required this.nama_lengkap,
    required this.no_hp,
    required this.profile,
    required this.status,
    required this.id_provinsi,
    required this.provinsi,
    required this.id_kota,
    required this.kota,
    required this.id_kecamatan,
    required this.kecamatan,
    required this.nama_kategori,
    required this.nama_produk,
    required this.harga,
    required this.stok,
    required this.gambar,
    required this.kondisi,
    required this.bahan,
    required this.merek,
    required this.ukuran,
    required this.berat,
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
      profile: json['profile'],
      status: json['status'],
      id_provinsi: json['id_provinsi'],
      provinsi: json['provinsi'],
      id_kota: json['id_kota'],
      kota: json['kota'],
      id_kecamatan: json['id_kecamatan'],
      kecamatan: json['kecamatan'],
      nama_kategori: json['nama_kategori'],
      nama_produk: json['nama_produk'],
      harga: json['harga'],
      stok: json['stok'],
      gambar: json['gambar'],
      kondisi: json['kondisi'],
      bahan: json['bahan'],
      merek: json['merek'],
      ukuran: json['ukuran'],
      berat: json['berat'],
      motif: json['motif'],
      deskripsi: json['deskripsi'],
      terjual: json['terjual'],
    );
  }
}
