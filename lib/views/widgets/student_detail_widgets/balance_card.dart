import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard(
      {Key? key,
      required this.colorLizer,
      required this.colors,
      required this.balance})
      : super(key: key);

  final ColorLizer colorLizer;
  final List<Color> colors;
  final int balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 120,
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: colorLizer.getSpecialFiledColor(colors),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Balance",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          Text(
            "Amount : ₹ $balance",
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
