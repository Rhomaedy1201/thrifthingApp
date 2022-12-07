class DetailsAlamat {
  String? idAlamatUser;
  String? idUser;
  String? email;
  String? namaLengkapUser;
  String? noHpUser;
  String? namaLengkapAlamat;
  String? noHpAlamat;
  String? idProvinsi;
  String? provinsi;
  String? idKota;
  String? kota;
  String? idKecamatan;
  String? kecamatan;
  String? kodePos;
  String? detailJalan;
  String? detailPatokan;
  String? status;

  DetailsAlamat(
      {this.idAlamatUser,
      this.idUser,
      this.email,
      this.namaLengkapUser,
      this.noHpUser,
      this.namaLengkapAlamat,
      this.noHpAlamat,
      this.idProvinsi,
      this.provinsi,
      this.idKota,
      this.kota,
      this.idKecamatan,
      this.kecamatan,
      this.kodePos,
      this.detailJalan,
      this.detailPatokan,
      this.status});

  DetailsAlamat.fromJson(Map<String, dynamic> json) {
    idAlamatUser = json['id_alamat_user'];
    idUser = json['id_user'];
    email = json['email'];
    namaLengkapUser = json['nama_lengkap_user'];
    noHpUser = json['no_hp_user'];
    namaLengkapAlamat = json['nama_lengkap_alamat'];
    noHpAlamat = json['no_hp_alamat'];
    idProvinsi = json['id_provinsi'];
    provinsi = json['provinsi'];
    idKota = json['id_kota'];
    kota = json['kota'];
    idKecamatan = json['id_kecamatan'];
    kecamatan = json['kecamatan'];
    kodePos = json['kode_pos'];
    detailJalan = json['detail_jalan'];
    detailPatokan = json['detail_patokan'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_alamat_user'] = idAlamatUser;
    data['id_user'] = idUser;
    data['email'] = email;
    data['nama_lengkap_user'] = namaLengkapUser;
    data['no_hp_user'] = noHpUser;
    data['nama_lengkap_alamat'] = namaLengkapAlamat;
    data['no_hp_alamat'] = noHpAlamat;
    data['id_provinsi'] = idProvinsi;
    data['provinsi'] = provinsi;
    data['id_kota'] = idKota;
    data['kota'] = kota;
    data['id_kecamatan'] = idKecamatan;
    data['kecamatan'] = kecamatan;
    data['kode_pos'] = kodePos;
    data['detail_jalan'] = detailJalan;
    data['detail_patokan'] = detailPatokan;
    data['status'] = status;
    return data;
  }

  static List<DetailsAlamat> fromJsonList(List list) {
    if (list.length == 0) return List<DetailsAlamat>.empty();
    return list.map((item) => DetailsAlamat.fromJson(item)).toList();
  }
}
