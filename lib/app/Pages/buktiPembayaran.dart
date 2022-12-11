import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BuktiPembayaran extends StatefulWidget {
  const BuktiPembayaran({super.key});

  @override
  State<BuktiPembayaran> createState() => _BuktiPembayaranState();
}

class _BuktiPembayaranState extends State<BuktiPembayaran> {
  File? image;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imagePicked =
        await _picker.pickImage(source: ImageSource.gallery);
    image = File(imagePicked!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Image.file(
                      image!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await getImage();
                    },
                    child: const Text("Pilih Foto"),
                  ),
                  SizedBox(width: 20),
                  image == null
                      ? Text("")
                      : ElevatedButton(
                          onPressed: () async {
                            await getImage();
                          },
                          child: const Text("Edit Foto"),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
