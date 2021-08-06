import 'package:colorlizer/colorlizer.dart';
import 'package:fe_manager/views/widgets/student_detail_widgets/add_fees.dart';
import 'package:fe_manager/views/widgets/student_detail_widgets/balance_card.dart';
import 'package:fe_manager/views/widgets/student_detail_widgets/datejoined_card.dart';
import 'package:fe_manager/views/widgets/student_detail_widgets/fees_card.dart';
import 'package:fe_manager/views/widgets/student_detail_widgets/last_paid_card.dart';
import 'package:flutter/material.dart';

class StudentDetail extends StatelessWidget {
  StudentDetail(
      {Key? key,
      required this.name,
      required this.id,
      required this.std,
      required this.fees,
      required this.dateJoined,
      required this.monthJoined,
      required this.yearJoined,
      required this.balance,
      this.lastPaidDate = "NA",
      this.lastPaidmonth = "NA",
      this.lastPaidYear = "NA",
      this.lastPaidAmount = 0,
      required this.totalfees})
      : super(key: key);
  final String name;
  final String std;
  final String lastPaidDate;
  final String lastPaidmonth;
  final String lastPaidYear;
  final String dateJoined;
  final String monthJoined;
  final String yearJoined;
  final int fees;
  final id;
  final int totalfees;
  int balance;
  final int lastPaidAmount;
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
    Colors.purple,
    Colors.blueGrey,
    Colors.cyan,
    Colors.deepOrange,
    Colors.lime,
    Colors.redAccent,
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: colorLizer.getRandomColors(),
                      child: Text(
                        name[0],
                        style: TextStyle(color: Colors.white, fontSize: 50),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style:
                                TextStyle(fontSize: name.length < 15 ? 25 : 18),
                          ),
                          Text(
                            "Std $std",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    PopupMenuButton(itemBuilder: (context) {
                      return [PopupMenuItem(child: Text("Edit Student"))];
                    })
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    DetailsCardJoined(
                      colorLizer: colorLizer,
                      colors: colors,
                      dateJoined: dateJoined,
                      monthJoined: monthJoined,
                      yearJoined: yearJoined,
                    ),
                    Spacer(),
                    FeesCard(
                      colorLizer: colorLizer,
                      colors: colors,
                      fees: fees,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                LastPaidCard(
                  colorLizer: colorLizer,
                  colors: colors,
                  id: id,
                  lastPaidDate: lastPaidDate,
                  lastPaidmonth: lastPaidmonth,
                  lastPaidYear: lastPaidYear,
                  lastPaidAmount: lastPaidAmount,
                ),
                SizedBox(
                  height: 20,
                ),
                BalanceCard(
                    colorLizer: colorLizer, colors: colors, balance: balance),
                SizedBox(
                  height: 20,
                ),
                AddFees(
                  colorLizer: colorLizer,
                  colors: colors,
                  id: id,
                  totalfees: totalfees,
                  balance: balance,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
