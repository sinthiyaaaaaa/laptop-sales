import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/API/api_connection.dart';
import 'dart:convert';
import 'package:intl/intl.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class BeliSekarangPage extends StatefulWidget {
  const BeliSekarangPage({super.key});

  @override
  State<BeliSekarangPage> createState() => _BeliSekarangPageState();
}

class _BeliSekarangPageState extends State<BeliSekarangPage> {
  List dataLaptopBerdasarkanId = [];
  List dataTransaksi = [];
  int? userId;

  @override
  void initState() {
    super.initState();
    // Ambil nilai id_laptop dari argumen dan panggil getAllLaptopById
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int idLaptop = ModalRoute.of(context)?.settings.arguments as int;
      getAllLaptopById(idLaptop);
      getTransaksi();
    });
  }

  Future<void> getAllLaptopById(int idLaptop) async {
    String uri = API.readBerdasarkanId;
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'id_laptop': idLaptop.toString()
        }, // Kirim id_laptop sebagai payload
      );

      if (response.statusCode == 200) {
        setState(() {
          dataLaptopBerdasarkanId = jsonDecode(response.body);
        });
      } else {
        print('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getTransaksi() async {
    String uri = API.readTransaksi;
    try {
      var response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        setState(() {
          dataTransaksi = jsonDecode(response.body);
        });
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addTransaksi(num subtotal, int idLaptop) async {
    String uri = API.createTransaksi; // Sesuaikan URI dengan endpoint API Anda
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'subtotal': subtotal.toString(),
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] && dataTransaksi.isNotEmpty) {
          String idTransaksi = dataTransaksi[0]['id_transaksi'];
          String idLaptopResponse = idLaptop.toString();
          String jumlah = '1';
          print(jumlah);
          setState(() {
            addPembelianLaptop(idLaptopResponse, idTransaksi, jumlah);
          });
        }
      } else {
        print('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addPembelianLaptop(String idLaptop, String idTransaksi, String jumlah) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id_pengguna');
    String uri = API.BeliSekarang; // Sesuaikan URI dengan endpoint API Anda
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          'id_laptop'   : idLaptop,
          'id_transaksi': idTransaksi,
          'id_pengguna' : userId.toString(),
          'jumlah'      : jumlah,
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
                  content: const Text("Pembayaran Selesai"),
                  actions: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, "/");
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
                  title: const Text("Gagal"),
                  content: const Text("Gagal melakukan pembayaran"),
                  actions: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, "/");
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
    // Mendapatkan id_laptop dari argumen
    final int idLaptop = ModalRoute.of(context)?.settings.arguments as int;

    final priceFormatted = NumberFormat.currency(locale: 'id', symbol: 'Rp. ');

    num subtotal = 0;
    if (dataLaptopBerdasarkanId.isNotEmpty && dataLaptopBerdasarkanId[0]['price'] != null) {
      subtotal =
          num.tryParse(dataLaptopBerdasarkanId[0]['price'].toString()) ?? 0;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      appBar: AppBar(
        title: const Text(
          "Pembayaran",
          style: TextStyle(),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
          width: 300,
          height: 260,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              const Text("Bayar Sekarang", style: TextStyle(fontSize: 30)),
              const SizedBox(
                height: 10,
              ),
              const Text("Total yang harus dibayarkan"),
              const SizedBox(
                height: 10,
              ),
              Text(
                  // "Rp. 64.000",
                  priceFormatted.format(subtotal),
                  style: const TextStyle(color: Colors.orange)),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    addTransaksi(subtotal, idLaptop);
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child:
                    const Text("Konfirmasi", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                  "Laman ini akan otomatis tertutup saat pembayaran di konfirmasi"),
            ],
          ),
        ),
      ),
    );
  }
}
