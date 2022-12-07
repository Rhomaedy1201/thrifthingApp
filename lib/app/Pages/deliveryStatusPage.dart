import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/app/loadingPages/loadingDeliveryStatus.dart';

class DeliveryStatusPage extends StatefulWidget {
  const DeliveryStatusPage({super.key});

  @override
  State<DeliveryStatusPage> createState() => _DeliveryStatusPageState();
}

class _DeliveryStatusPageState extends State<DeliveryStatusPage> {
  int _curreuntStep = 0;

  var kurir = "tiki";
  var noresi = "030205696069";

  List? result;
  var ms;
  void getTranck() async {
    final url =
        "http://localhost/API-Pengiriman/pengiriman.php?kurir=${kurir.toString()}&resi=${noresi.toString()}";
    final response = await http.get(Uri.parse(url));
    setState(() {
      if (response.statusCode == 200) {
        result = jsonDecode(response.body)['history'];
        userData = (response as List<dynamic>);
        ms = jsonDecode(response.body);
      } else {
        print("Loading......");
      }
    });
  }

  var userData;
  List? convertDataToJson;
  Future<void> getTrancking() async {
    Uri url = Uri.parse(
        "http://localhost/restApi_goThrift/API-Pengiriman/pengiriman.php?kurir=${kurir.toString()}&resi=${noresi.toString()}");
    var response = await http.get(url);
    setState(() {
      if (response.body == null) {
        print("cokkkkk");
      } else {
        convertDataToJson = jsonDecode(response.body)['history'];
        userData = (convertDataToJson as List<dynamic>);
        print(userData);
      }
    });
  }

  bool type = false;

  @override
  void initState() {
    getTrancking();
    Timer(Duration(seconds: 3), () {
      setState(() {});
      type = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (type == false)
        ? LoadingDeliveryStatus()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Color(0xFF9C62FF)),
              elevation: 2,
              shadowColor: Color(0xFFF4F1F6),
              title: Text(
                "Status Pengiriman",
                style: TextStyle(
                  color: Color(0xFF414141),
                  fontSize: 22,
                ),
              ),
            ),
            body: ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Diproses",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Divider(
                        color: Color(0xFFCFCFCF),
                      ),
                      Text(
                        "Dikirim dengan Regular - JNE",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff727272),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 8,
                  color: Color(0xFFF1F1F1),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "No.Resi",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff727272),
                            ),
                          ),
                          Text(
                            "JE00177773635",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: Color(0xFFCECECE),
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "20 Nov",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xff727272),
                                  ),
                                ),
                                Text(
                                  "12:01",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xff727272),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.deepPurple,
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 50,
                                color: Color(0xff883378),
                              ),
                            ],
                          ),
                          Container(
                            width: 270,
                            child: Text(
                              "Pengirim telah mengatur pengiriman. menunggu paket diserahkan ke pihak jasa kirim",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff727272),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: convertDataToJson!.length,
                        itemBuilder: (context, index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "20 Nov",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xff727272),
                                      ),
                                    ),
                                    Text(
                                      "12:01",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xff727272),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 2,
                                      minHeight: 40,
                                    ),
                                    child: Container(
                                      color: Color(0xff883378),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 270,
                                child: Text(
                                  userData![index]['message'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xff727272),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
