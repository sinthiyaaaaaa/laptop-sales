import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(25),
      child: const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 20,
              ),
              child: Text(
                "ElecTrons",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            
            )
          ]
        ),
    );
  }
}
