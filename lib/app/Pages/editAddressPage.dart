import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '/app/models/city_model.dart';
import '/app/models/province_model.dart';
import 'package:http/http.dart' as http;

class EditAddressPage extends StatefulWidget {
  var idProv, idKota, idKec;
  var namaLengkap, noTelp, namaProv, namaKota, namaJln, namaPatokan, kodePos;
  EditAddressPage({
    super.key,
    this.idProv,
    this.idKota,
    this.namaLengkap,
    this.noTelp,
    this.namaProv,
    this.namaKota,
    this.namaJln,
    this.namaPatokan,
    this.kodePos,
  });

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  TextEditingController txtNama = TextEditingController();
  TextEditingController txtNomor = TextEditingController();
  TextEditingController txtJalan = TextEditingController();
  TextEditingController txtPatokan = TextEditingController();
  TextEditingController txtKodePos = TextEditingController();

  var idProv, idKota, idKec;
  var namaLengkap, noTelp, namaProv, namaKota, namaJln, namaPatokan, kodePos;

  _EditAddressPageState({
    this.idProv,
    this.idKota,
    this.namaLengkap,
    this.noTelp,
    this.namaProv,
    this.namaKota,
    this.namaJln,
    this.namaPatokan,
    this.kodePos,
  });

  bool nama = true,
      provinsi = false,
      kota = false,
      kecamatan = false,
      nomor = false,
      jalan = false,
      patokan = false;

  void ket() {
    Container(
      width: double.infinity,
      height: 20,
      color: const Color(0xFFF8A8A2),
      child: const Text("Nama Lengkap Kosong"),
    );
  }

  @override
  void initState() {
    txtNama.text = widget.namaLengkap;
    txtNomor.text = widget.noTelp;
    namaProv = widget.namaProv;
    namaKota = widget.namaKota;
    txtKodePos.text = widget.kodePos;
    txtJalan.text = widget.namaJln;
    txtPatokan.text = widget.namaPatokan;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF9C62FF)),
        elevation: 2,
        shadowColor: const Color(0xFFF4F1F6),
        title: const Text(
          "Edit Alamat",
          style: TextStyle(
            color: Color(0xFF414141),
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: const Text(
              "Kontak",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xff727272),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 55,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: TextField(
                controller: txtNama,
                onChanged: (value) {
                  setState(() {
                    (txtNama.text == null || txtNama.text == "")
                        ? nama = false
                        : nama = true;
                  });
                },
                autofocus: false,
                autocorrect: false,
                cursorColor: Color(0xFF9C62FF),
                cursorWidth: 3,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Nama Lengkap",
                  hintStyle: TextStyle(fontSize: 18, color: Color(0xFF969696)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          (nama == false)
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  color: const Color(0xFFF8A8A2),
                  child: const Text(
                    "Nama Lengkap Kosong",
                    style: TextStyle(color: Color.fromARGB(255, 108, 108, 108)),
                  ),
                )
              : Container(),
          const SizedBox(height: 3),
          Container(
            width: double.infinity,
            height: 55,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: TextField(
                enabled:
                    (txtNama.text == null || txtNama.text == "") ? false : true,
                controller: txtNomor,
                onTap: () {
                  setState(() {
                    (txtNama.text == null || txtNama.text == "")
                        ? nama = false
                        : nama = true;
                  });
                },
                onChanged: (value) {
                  setState(() {});
                },
                autofocus: false,
                autocorrect: false,
                cursorColor: Color(0xFF9C62FF),
                cursorWidth: 3,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                keyboardType: TextInputType.phone,
                maxLength: 12,
                decoration: const InputDecoration(
                    counterText: '',
                    hintText: "Nomor Telepon",
                    hintStyle:
                        TextStyle(fontSize: 18, color: Color(0xFF969696)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: const Text(
              "Alamat",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xff727272),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: DropdownSearch<Province>(
                clearButtonProps: const ClearButtonProps(
                  isVisible: true,
                ),
                popupProps: PopupProps.dialog(
                  showSearchBox: true,
                  title: Container(
                      padding: const EdgeInsets.only(left: 7, top: 10),
                      child: const Text(
                        "Cari Provinsi :",
                        style: TextStyle(fontSize: 15),
                      )),
                  itemBuilder: (context, item, isSelected) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Text(
                        "${item.province}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
                itemAsString: (item) => item.province!,
                asyncItems: (String filter) async {
                  Uri url =
                      Uri.parse("https://api.rajaongkir.com/starter/province");

                  try {
                    final response = await http.get(
                      url,
                      headers: {
                        "key": "d94bc123ecd740dfcfb52e76e0439035",
                      },
                    );
                    var data =
                        json.decode(response.body) as Map<String, dynamic>;

                    var statusCode = data['rajaongkir']['status']['code'];

                    if (statusCode != 200) {
                      throw data['rajaongkir']['status']['description'];
                    }

                    var listAllProvince =
                        data['rajaongkir']['results'] as List<dynamic>;

                    var models = Province.fromJsonList(listAllProvince);
                    return models;
                  } catch (err) {
                    print(err);
                    return List<Province>.empty();
                  }
                },
                onChanged: (prov) {
                  if (prov != null) {
                    setState(() {
                      kota = true;
                      provinsi = true;
                      idProv = prov.provinceId;
                      namaProv = prov.province;
                      print("$idProv $namaProv");
                    });
                  } else {
                    print("tidak memilih provinsi");
                    setState(() {
                      kota = false;
                      provinsi = false;
                      idProv = null;
                      namaProv = null;
                    });
                  }
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: "Provinsi",
                    hintStyle:
                        TextStyle(fontSize: 18, color: Color(0xFF969696)),
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: double.infinity,
            color: Colors.white,
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: DropdownSearch<City>(
                enabled: (kota == false) ? false : true,
                clearButtonProps: const ClearButtonProps(
                  isVisible: true,
                ),
                popupProps: PopupProps.dialog(
                  showSearchBox: true,
                  title: Container(
                      padding: const EdgeInsets.only(left: 7, top: 10),
                      child: const Text(
                        "Cari Kota :",
                        style: TextStyle(fontSize: 15),
                      )),
                  itemBuilder: (context, item, isSelected) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Text(
                        "${item.type} ${item.cityName}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
                itemAsString: (item) => item.cityName!,
                asyncItems: (String filter) async {
                  Uri url = Uri.parse(
                      "https://api.rajaongkir.com/starter/city?province=${idProv.toString()}");

                  try {
                    final response = await http.get(
                      url,
                      headers: {
                        "key": "d94bc123ecd740dfcfb52e76e0439035",
                      },
                    );
                    var data =
                        json.decode(response.body) as Map<String, dynamic>;

                    var statusCode = data['rajaongkir']['status']['code'];

                    if (statusCode != 200) {
                      throw data['rajaongkir']['status']['description'];
                    }

                    var listAllCity =
                        data['rajaongkir']['results'] as List<dynamic>;

                    var models = City.fromJsonList(listAllCity);
                    return models;
                  } catch (err) {
                    print(err);
                    return List<City>.empty();
                  }
                },
                onChanged: (city) {
                  if (city != null) {
                    setState(() {
                      kecamatan = true;
                      idKota = city.cityId;
                      namaKota = city.cityName;
                      txtKodePos.text = city.postalCode.toString();
                      print("$idKota $namaKota ");
                      print("${city.postalCode} ");
                    });
                  } else {
                    print("tidak memilih kota");
                    setState(() {
                      kecamatan = false;
                      idKota = null;
                      namaKota = null;
                      txtKodePos.text = "";
                    });
                  }
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: "Kota",
                    hintStyle:
                        TextStyle(fontSize: 18, color: Color(0xFF969696)),
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: double.infinity,
            height: 55,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: TextField(
                controller: txtKodePos,
                enabled: false,
                onChanged: (value) {
                  setState(() {});
                },
                autofocus: false,
                autocorrect: false,
                cursorColor: Color(0xFF9C62FF),
                cursorWidth: 3,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Kode pos",
                  hintStyle: TextStyle(fontSize: 18, color: Color(0xFF969696)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: double.infinity,
            height: 55,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: TextField(
                controller: txtJalan,
                onChanged: (value) {
                  setState(() {});
                },
                autofocus: false,
                autocorrect: false,
                cursorColor: Color(0xFF9C62FF),
                cursorWidth: 3,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Nama Jalan, Gedung, No Rumah",
                  hintStyle: TextStyle(fontSize: 18, color: Color(0xFF969696)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: double.infinity,
            height: 55,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: TextField(
                controller: txtPatokan,
                onChanged: (value) {
                  setState(() {});
                },
                autofocus: false,
                autocorrect: false,
                cursorColor: Color(0xFF9C62FF),
                cursorWidth: 3,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Detail Lainnya (Cth: Blok / Unit No. Patokan)",
                  hintStyle: TextStyle(fontSize: 18, color: Color(0xFF969696)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: (txtNama.text == "" || txtNomor.text == "")
                  ? null
                  : (namaProv == null || namaKota == null)
                      ? null
                      : (txtJalan.text == "" || txtPatokan.text == "")
                          ? null
                          : () {
                              // postAlamat();
                            },
              child: Container(
                height: 55,
                child: Center(
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9C62FF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
