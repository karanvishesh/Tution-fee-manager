import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';

class FeesCard extends StatelessWidget {
  const FeesCard({
    Key? key,
    required this.colorLizer,
    required this.colors,
    required this.fees,
  }) : super(key: key);

  final ColorLizer colorLizer;
  final List<Color> colors;
  final int fees;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 170,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: colorLizer.getSpecialFiledColor(colors),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Fees",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          Text(
            "₹ $fees",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
