import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/API/api_connection.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class EditKeranjangPage extends StatefulWidget {
  int idKeranjang;

  EditKeranjangPage({super.key, required this.idKeranjang});

  @override
  State<EditKeranjangPage> createState() => _EditKeranjangPageState();
}

class _EditKeranjangPageState extends State<EditKeranjangPage> {
  List dataKeranjangBerdasarkanId = [];
  int jumlah = 1;
  bool isLoading = true;

  void _tambahJumlahBarang() {
    setState(() {
      jumlah++;
    });
  }

  void _kurangJumlahBarang() {
    setState(() {
      if (jumlah > 1) {
        jumlah--;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Ambil nilai id_laptop dari argumen dan panggil getAllLaptopById
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int idKeranjang = widget.idKeranjang;
      getKeranjangById(idKeranjang);
    });
  }

  Future<void> getKeranjangById(int idKeranjang) async {
    String uri = API.readBerdasarkanIdKeranjang;
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'id_keranjang': idKeranjang.toString()
        }, // Kirim id_laptop sebagai payload
      );

      if (response.statusCode == 200) {
        setState(() {
          dataKeranjangBerdasarkanId = jsonDecode(response.body);
          if (dataKeranjangBerdasarkanId.isNotEmpty) {
            jumlah = int.parse(dataKeranjangBerdasarkanId[0]['jumlah']);
          }
          isLoading = false;
        });
      } else {
        print('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateKeranjang(int idKeranjang, int jumlah) async {
    String uri = API.updateKeranjang; // Sesuaikan URI dengan endpoint API Anda
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'id_keranjang': idKeranjang.toString(), // Ganti dengan id_pengguna yang sesuai
          'jumlah': jumlah.toString(),
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Success"),
                  content: const Text("Jumlah Produk berhasil diubah"),
                  actions: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/');
                      },
                      child: const Text("Oke"),
                    )
                  ],
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Failed"),
                  content: const Text("Gagal merubah jumlah produk "),
                  actions: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Oke"),
                    )
                  ],
                );
              });
        }
      } else {
        print('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final int idKeranjang = widget.idKeranjang;

    final priceFormatted = NumberFormat.currency(locale: 'id', symbol: 'Rp. ');

    num price = 0;
    if (dataKeranjangBerdasarkanId.isNotEmpty && dataKeranjangBerdasarkanId[0]['price'] != null) {
      price = num.tryParse(dataKeranjangBerdasarkanId[0]['price'].toString()) ?? 0;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      appBar: AppBar(
        title: const Text(
          "Keranjang",
          style: TextStyle(),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              height: 900,
              padding: const EdgeInsets.only(top: 15),
              decoration: const BoxDecoration(
                  color: Color(0xFFEDECF2),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35))),
              child: Column(
                children: [
                  // PRODUCT PAGE
                  Column(
                    children: [
                      Container(
                        height: 230,
                        margin:
                            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              margin: const EdgeInsets.only(right: 15),
                              child: Image.asset("images/5.png",
                                  fit: BoxFit.cover),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                // crossAxisAlignment:
                                //     CrossAxisAlignment.start,
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    // "Apple Macbook Air",
                                    dataKeranjangBerdasarkanId[0]['product'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4C53A5),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      const Column(
                                        children: [
                                          Column(
                                            children: [Text("500 terjual")],
                                          )
                                        ],
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            // "Rp. 21.435.000",
                                            priceFormatted.format(price),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              // fontWeight: FontWeight.bold,
                                              color: Color(0XFF4C53A5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      FloatingActionButton(
                                        mini: true,
                                        backgroundColor: Colors.blue,
                                        onPressed: () {
                                          _tambahJumlahBarang();
                                        },
                                        child: const Icon(
                                          CupertinoIcons.plus,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text("$jumlah"),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      FloatingActionButton(
                                        mini: true,
                                        backgroundColor: Colors.blue,
                                        onPressed: () {
                                          _kurangJumlahBarang();
                                        },
                                        child: const Icon(
                                          CupertinoIcons.minus,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          updateKeranjang(
                                              idKeranjang, jumlah);
                                        });
                                      },
                                      child: const Text("Ubah Jumlah Keranjang"))
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
