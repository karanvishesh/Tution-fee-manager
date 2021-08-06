import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';

class DetailsCardJoined extends StatelessWidget {
  const DetailsCardJoined({
    Key? key,
    required this.colorLizer,
    required this.colors,
    required this.dateJoined,
    required this.monthJoined,
    required this.yearJoined,
  }) : super(key: key);

  final ColorLizer colorLizer;
  final List<Color> colors;
  final String dateJoined;
  final String monthJoined;
  final String yearJoined;

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Date Joined:",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
          Text(
            "$dateJoined $monthJoined",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            "$yearJoined",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
