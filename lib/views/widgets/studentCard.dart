import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fe_manager/views/screens/student_detail_screen.dart';

class StudentCard extends StatelessWidget {
  StudentCard({
    Key? key,
    required this.id,
    required this.name,
    required this.std,
    required this.dateJoined,
    required this.monthJoined,
    required this.yearJoined,
    this.lastPaidDate = "NA",
    this.lastPaidmonth = "NA",
    this.lastPaidYear = "NA",
    required this.balance,
    required this.fees,
    this.lastPaidAmount = 0,
    required this.totalfees,
  }) : super(key: key);
  final String name;
  final String std;
  final int totalfees;
  final String dateJoined;
  final String id;
  final String monthJoined;
  final String yearJoined;
  final int fees;
  int lastPaidAmount;
  String lastPaidDate;
  String lastPaidmonth;
  String lastPaidYear;
  int balance;

  ColorLizer colorLizer = ColorLizer();
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purpleAccent,
    Colors.teal,
    Colors.blueAccent,
    Colors.pinkAccent,
    Colors.brown,
    Colors.purple,
    Colors.blueGrey,
    Colors.cyan,
    Colors.deepOrange,
    Colors.lime,
    Colors.redAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Get.to(() => StudentDetail(
              balance: balance,
              id: id,
              name: name,
              std: std,
              fees: fees,
              lastPaidAmount: lastPaidAmount,
              dateJoined: dateJoined,
              lastPaidDate: lastPaidDate,
              lastPaidYear: lastPaidYear,
              lastPaidmonth: lastPaidmonth,
              monthJoined: monthJoined,
              yearJoined: yearJoined,
              totalfees: totalfees,
            )),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: colorLizer.getSpecialFiledColor(colors),
            child: Text(
              name[0],
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          title: Text(
            name,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          subtitle: Text(
            "Std $std",
            style: TextStyle(color: Colors.black45, fontSize: 15),
          ),
          trailing: Text(
            "$balance",
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ));
  }
}
