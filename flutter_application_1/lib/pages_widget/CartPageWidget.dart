import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/CartItem.dart';
import 'package:flutter_application_1/widgets/HomeAppBar.dart';

class CartPageWidget extends StatelessWidget {
  const CartPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          const Row(
            children: [
              HomeAppBar(),
              Text("Cart")
            ],
          ),
          Container(
            height: 3000,
            padding: const EdgeInsets.only(top: 15),
            decoration: const BoxDecoration(
              color: Color(0xFFEDECF2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35)
              )),
              child: const Column(
                children: [
                  CartItem(),
                  // CartCheckout()
                ],
              ),
          )
        ],
      );
  }
}
