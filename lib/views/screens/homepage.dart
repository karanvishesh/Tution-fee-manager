import 'package:fe_manager/controller/studentcountcontroller.dart';
import 'package:fe_manager/views/widgets/studentCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> studentsStream = FirebaseFirestore.instance
      .collection('students')
      .orderBy("balance", descending: true)
      .snapshots();

  CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  StudentCountController countcontroller = Get.put(StudentCountController());

  deleteStudent(id) {
    students.doc(id).delete().then((value) => print("user deleted")).catchError(
        (error) => print('Something went wrong can\' delete user coz $error'));
  }

  Future<void> updateStudent(id, fees, balance, totfees, updatedMonth) {
    int totfees1 = totfees + fees;
    int balance1 = balance + fees;
    return students
        .doc(id)
        .update({
          'totfees': totfees + fees,
          'balance': balance + fees,
          'updatedmonth': updatedMonth
        })
        .then((value) => print("Student Updated $totfees1 $balance1"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  updateDate(id, date, fees, balance, totalfees, month, updatedM) {
    DateTime currentDate = DateTime.now();
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

    if (int.parse(date) == currentDate.day &&
        months[currentDate.month - 1] != month &&
        months[currentDate.month - 1] != updatedM) {
      updateStudent(
          id, fees, balance, totalfees, months[currentDate.month - 1]);
    }
  }

  updateOnceEveryDay() async {
    //checking current date
    final currentdate = new DateTime.now().day;
    //you need to import this Shared preferences plugin
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //getting last date
    int lastDay = (prefs.getInt('day') ?? 0);

    //check is code already display or not
    if (currentdate != lastDay) {
      await prefs.setInt('day', currentdate);

      //your code will run once in day
      var documents = await students.get();
      for (var doc in documents.docs) {
        updateDate(doc.id, doc["date"], doc["fees"], doc["balance"],
            doc["totfees"], doc["month"], doc["updatedmonth"]);
      }
    }
  }

  showBg() {
    return Container(
      alignment: Alignment.centerRight,
      color: Colors.deepOrange,
      padding: EdgeInsets.only(right: 20),
      child: Icon(
        CupertinoIcons.trash,
        color: Colors.white,
      ),
    );
  }

  Future getDocs() async {
    var documents = await students.get();
    for (var doc in documents.docs) {
      countcontroller.updateMonthlyEarning(doc["fees"]);
      countcontroller.updateFeesPending(doc["balance"]);
    }
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
    countcontroller.updatetotStudent(documents.docs.length);
  }

  @override
  void initState() {
    getDocs();
    updatePending();
    updateOnceEveryDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff35438E),
      appBar: AppBar(
        title: Text("Fee Manager"),
        backgroundColor: Color(0xff35438E),
        elevation: 1,
      ),
      body: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 60,
                      child: GetBuilder<StudentCountController>(
                        init: StudentCountController(),
                        builder: (controller) => Text(
                          "${controller.studentPending}/${controller.totStudent}",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Paid Full Fees",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GetBuilder<StudentCountController>(
                builder: (controller) {
                  return Text(
                    "Pending total: ₹${controller.feesPending}",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              GetBuilder<StudentCountController>(
                builder: (controller) {
                  return Text(
                    "Monthly earning: ₹${controller.monthlyearning}",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  );
                },
              ),
            ],
          ),
          Spacer(),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            color: Colors.white,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 10),
                  child: Text(
                    "Max amount to be paid by",
                    style: TextStyle(color: Colors.black45, fontSize: 17),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: studentsStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print('Something went Wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final List storedocs = [];
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map a = document.data() as Map<String, dynamic>;
                          storedocs.add(a);
                          a['id'] = document.id;
                        }).toList();
                        return Scaffold(
                          body: SafeArea(
                            child: storedocs.length == 0
                                ? Center(
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "No Students yet",
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.grey),
                                      ),
                                    ],
                                  ))
                                : ListView.builder(
                                    itemCount: storedocs.length,
                                    itemBuilder: (context, index) {
                                      Future<bool?> _showConfirmationDialog(
                                          BuildContext context) async {
                                        return await showDialog<bool>(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Do you want to delete this item?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Yes'),
                                                  onPressed: () {
                                                    Navigator.pop(context,
                                                        true); // showDialog() returns true
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('No'),
                                                  onPressed: () {
                                                    Navigator.pop(context,
                                                        false); // showDialog() returns false
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }

                                      return Dismissible(
                                        direction: DismissDirection.endToStart,
                                        confirmDismiss: (val)=>
                                            _showConfirmationDialog(context),
                                        onDismissed: (direction) {
                                          Get.snackbar("Deleted",
                                              "${storedocs[index]["name"]} deleted");
                                        },
                                        background: showBg(),
                                        key: Key(storedocs[index]["name"]),
                                        child: Center(
                                            child: StudentCard(
                                          id: storedocs[index]["id"],
                                          name: storedocs[index]["name"],
                                          std: storedocs[index]["std"],
                                          dateJoined: storedocs[index]["date"],
                                          monthJoined: storedocs[index]
                                              ["month"],
                                          fees: storedocs[index]["fees"],
                                          yearJoined: storedocs[index]["year"],
                                          lastPaidDate: storedocs[index]
                                                      ["lastpaiddate"] ==
                                                  null
                                              ? "NA"
                                              : storedocs[index]
                                                  ["lastpaiddate"],
                                          lastPaidmonth: storedocs[index]
                                                      ["lastpaidmonth"] ==
                                                  null
                                              ? "NA"
                                              : storedocs[index]
                                                  ["lastpaidmonth"],
                                          lastPaidYear: storedocs[index]
                                                      ["lastpaidyear"] ==
                                                  null
                                              ? "NA"
                                              : storedocs[index]
                                                  ["lastpaidyear"],
                                          lastPaidAmount: storedocs[index]
                                                      ["lastpaidamount"] ==
                                                  null
                                              ? 0
                                              : storedocs[index]
                                                  ["lastpaidamount"],
                                          balance: storedocs[index]
                                                      ["balance"] ==
                                                  null
                                              ? 0
                                              : storedocs[index]["balance"],
                                          totalfees: storedocs[index]
                                              ["totfees"],
                                        )),
                                      );
                                    }),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
