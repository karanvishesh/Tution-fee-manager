import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fe_manager/controller/studentcountcontroller.dart';
import 'package:fe_manager/views/widgets/studentCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Student_feeList_screen extends StatelessWidget {
  Student_feeList_screen({Key? key}) : super(key: key);
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');
  final Stream<QuerySnapshot> studentsStream = FirebaseFirestore.instance
      .collection('students')
      .orderBy("name")
      .snapshots();
  StudentCountController countcontroller = Get.put(StudentCountController());
  deleteStudent(id) {
    students.doc(id).delete().then((value) => print("user deleted")).catchError(
        (error) => print('Something went wrong can\' delete user coz $error'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Fee Manager"),
          backgroundColor: Color(0xff35438E),
          elevation: 1,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: studentsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print('Something went Wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                                  return Dismissible(
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      deleteStudent(storedocs[index]["id"]);

                                      Get.snackbar("Deleted",
                                          "${storedocs[index]["name"]} deleted");
                                    },
                                    background: showBg(),
                                    key: Key(storedocs[index]["name"]),
                                    child: Center(
                                        child: StudentCard(
                                      id: "234",
                                      name: storedocs[index]["name"],
                                      std: storedocs[index]["std"],
                                      dateJoined: storedocs[index]["date"],
                                      monthJoined: storedocs[index]["month"],
                                      yearJoined: storedocs[index]["year"],
                                      fees: storedocs[index]["fees"],
                                      lastPaidDate: storedocs[index]
                                                  ["lastpaiddate"] ==
                                              null
                                          ? "NA"
                                          : storedocs[index]["lastpaiddate"],
                                      lastPaidmonth: storedocs[index]
                                                  ["lastpaidmonth"] ==
                                              null
                                          ? "NA"
                                          : storedocs[index]["lastpaidmonth"],
                                      lastPaidYear: storedocs[index]
                                                  ["lastpaidyear"] ==
                                              null
                                          ? "NA"
                                          : storedocs[index]["lastpaidyear"],
                                      lastPaidAmount: storedocs[index]
                                                  ["lastpaidamount"] ==
                                              null
                                          ? 0
                                          : storedocs[index]["lastpaidamount"],
                                      balance:
                                          storedocs[index]["balance"] == null
                                              ? 0
                                              : storedocs[index]["balance"],
                                      totalfees: storedocs[index]["totfees"],
                                    )),
                                  );
                                }),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
