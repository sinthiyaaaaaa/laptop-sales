import 'package:flutter/material.dart';

class MerkWidget extends StatelessWidget {
  const MerkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (String imagePath in [
                  "images/acer.png",
                  "images/asus.png",
                  "images/dell.png",
                  "images/hp.png",
                  "images/ipon.png",
                  "images/lenovo.png",
                  "images/masi.png",
                ])
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    imagePath,
                    width: 40,
                    height: 40,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
