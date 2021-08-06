import 'package:colorlizer/colorlizer.dart';
import 'package:fe_manager/controller/studentcountcontroller.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddFees extends StatefulWidget {
  AddFees(
      {Key? key,
      required this.colorLizer,
      required this.colors,
      required this.id,
      required this.totalfees,
      required this.balance})
      : super(key: key);
  final ColorLizer colorLizer;
  final List<Color> colors;
  final int totalfees;
  final int balance;
  var id;
  @override
  _AddFeesState createState() => _AddFeesState();
}

class _AddFeesState extends State<AddFees> {
  String date = "01";

  String month = "01";

  String year = "01";
  TextEditingController textEditingController = TextEditingController();
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');
  StudentCountController countcontroller = Get.put(StudentCountController());

  Future<void> updateStudent(id, feeamount, date, month, year) {
    List months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    int selectedMonth = int.parse(month) - 1;
    return students
        .doc(id)
        .update({
          'lastpaidamount': int.parse(feeamount),
          'lastpaiddate': date,
          'lastpaidmonth': months[selectedMonth],
          'lastpaidyear': year,
          'balance': widget.balance - int.parse(feeamount),
        })
        .then((value) => print("Student Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future updatePending() async {
    int totpending = 0;
    var documents = await students.get();
    for (var docs in documents.docs) {
      if (docs["balance"] == 0) {
        totpending++;
      }
    }
    countcontroller.updateStudentPending(totpending);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Fees Paid at",
                            style: TextStyle(fontSize: 20),
                          ),
                          MaterialButton(
                              textColor: Colors.white,
                              color: Color(0xff35438E),
                              child: Text("Select date"),
                              onPressed: () async {
                                final dateSelected = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2015, 8),
                                    lastDate: DateTime.now());

                                setState(() {
                                  date = dateSelected!.day.toString();
                                  month = dateSelected.month.toString();
                                  year = dateSelected.year.toString();
                                });

                                print(dateSelected);
                              }),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Enter bill amount:",
                            style: TextStyle(
                                fontSize: 20, color: Color(0xff35438E)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Text(
                                  "₹",
                                  style: TextStyle(
                                      fontSize: 40, color: Color(0xff35438E)),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: textEditingController,
                                    onChanged: (value) {
                                      print(value);
                                    },
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        color: Color(0xff35438E),
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            onPressed: () {
                              updateStudent(
                                  widget.id,
                                  textEditingController.text,
                                  date,
                                  month,
                                  year);
                              textEditingController.clear();
                              Navigator.pop(context);
                              updatePending();
                            },
                            color: Color(0xff35438E),
                            child: Text(
                              "Confirm Payment",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
      },
      child: Container(
          padding: EdgeInsets.all(20),
          height: 100,
          width: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: widget.colorLizer.getSpecialFiledColor(widget.colors),
          ),
          child: Center(
            child: Text(
              "Add Fees",
              style: TextStyle(fontSize: 35, color: Colors.white),
            ),
          )),
    );
  }
}
