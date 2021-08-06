import 'package:fe_manager/controller/studentcountcontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class AddFeesScreen extends StatefulWidget {
  const AddFeesScreen({Key? key}) : super(key: key);

  @override
  _AddFeesScreenState createState() => _AddFeesScreenState();
}

class _AddFeesScreenState extends State<AddFeesScreen> {
  TextStyle styletxt = TextStyle(color: Colors.white, fontSize: 20);
  TextEditingController textEditingController = TextEditingController();
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');
  String date = "01";
  String month = "01";
  String year = "01";
  StudentCountController countcontroller = Get.find<StudentCountController>();
  Future<void> addStudent(String name, String std, int fees, String dat,
      String mon, String yea, int balmonths) {
    // Call the user's CollectionReference to add a new user
    return students
        .add({
          'name': name, // John Doe
          'std': std, // Stokes and Sons
          'fees': fees,
          'date': dat,
          'month': mon,
          'year': yea,
          'totfees': fees * balmonths,
          "balance": fees * balmonths,
          "updatedmonth" : "NA"// 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
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

  bool ispressedonce = false;

  var monthPassed;
  String standard = "1st";
  String fees = "100";
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
  List standards = [
    "1st",
    "2nd",
    "3rd",
    "4th",
    "5th",
    "6th",
    "7th",
    "8th",
    "9th",
    "Xth",
  ];
  List<Center> createcupertinoStandard() {
    List<Center> items = [];
    for (var txt in standards) {
      items.add(Center(
        child: Text(
          txt,
          style: styletxt,
        ),
      ));
    }
    return items;
  }

  ScrollController scrollControllerstd = ScrollController();

  List<Center> createcupertinofees() {
    List<Center> items = [];
    for (int i = 100; i <= 2000; i += 50) {
      items.add(Center(
        child: Text(
          i.toString(),
          style: styletxt,
        ),
      ));
    }
    return items;
  }

  void changeDate(dat, mont, yea) {
    setState(() {
      date = dat;
      month = mont;
      year = yea;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
      Container(
        width: double.infinity,
        height: 100,
        color: Color(0xff35438E),
        child: Center(
          child: Text(
            'Student Details',
            style: TextStyle(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.w300),
          ),
        ),
      ),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                autofocus: false,
                onTap: () {
                  setState(() {
                    ispressedonce = false;
                  });
                },
                controller: textEditingController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Studentname',
                    hintText: 'Enter full name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Date joined:",
                    style: TextStyle(fontSize: 15, color: Colors.black45),
                  ),
                  Text("$date/$month/$year"),
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
                        if (dateSelected != null) {
                          changeDate(
                            dateSelected.day.toString(),
                            month = dateSelected.month.toString(),
                            year = dateSelected.year.toString(),
                          );

                          DateTime currentDate = DateTime.now();

                          monthPassed = currentDate.day < int.parse(date)
                              ? (currentDate.month.toInt() - int.parse(month)) -
                                  1
                              : (currentDate.month.toInt() - int.parse(month));

                          if (currentDate.year != int.parse(year)) {
                            int totalyear =
                                (currentDate.year - int.parse(year));
                            monthPassed = monthPassed + (totalyear * 12);
                          }
                        }
                      }),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Select Standard",
                  style: TextStyle(fontSize: 20, color: Colors.black45),
                ),
                Text(
                  "Select Fees",
                  style: TextStyle(fontSize: 20, color: Colors.black45),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 140,
                    child: CupertinoPicker(
                        backgroundColor: Color(0xff35438E),
                        itemExtent: 65,
                        onSelectedItemChanged: (index) {
                          standard = standards[index];
                        },
                        children: createcupertinoStandard()),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 140,
                    child: CupertinoPicker(
                        backgroundColor: Color(0xff35438E),
                        itemExtent: 65,
                        onSelectedItemChanged: (index) {
                          fees = (50 * (index + 2)).toString();
                        },
                        children: createcupertinofees()),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: MaterialButton(
                height: 40,
                color: Color(0xff35438E),
                onPressed: 
                textEditingController.text == "" ||
                        (date == "01" && month == "01" && year == "01") ||
                        ispressedonce == true
                    ? () {
                        Get.defaultDialog(
                            title: "Please Provide all the information",
                            content: Text(
                              textEditingController.text == "" &&
                                      (date == "01" &&
                                          month == "01" &&
                                          year == "01")
                                  ? " Please add name and date of joining"
                                  : textEditingController.text == ""
                                      ? " Please Add name"
                                      : "Please add date of joining",
                            ));
                      }
                    : () {
                        int monthselec = int.parse(month);
                        addStudent(
                            textEditingController.text[0].toUpperCase() +
                                textEditingController.text.substring(1),
                            standard,
                            int.parse(fees),
                            date,
                            months[monthselec - 1],
                            year,
                            monthPassed);
                        Get.snackbar("Added",
                            "${textEditingController.text[0].toUpperCase() + textEditingController.text.substring(1)} added");

                        textEditingController.clear();
                        setState(() {
                          ispressedonce = true;
                        });
                    
                      },
                child: Text(
                  "Add Student",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]),
    ]))));
  }
}
