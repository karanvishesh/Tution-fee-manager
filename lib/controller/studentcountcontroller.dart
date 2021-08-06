import 'package:get/get.dart';

class StudentCountController extends GetxController {
  int totStudent = 0;
  int studentPending = 0;
  int totalfees = 0;
  int feesPending = 0;
  int monthlyearning = 0;
 
  updateMonthlyEarning(int earning) {
    monthlyearning = monthlyearning + earning;
  }

  updateFeesPending(int pending) {
    feesPending = feesPending + pending;
  }
  updatetotStudent(int no) {
    totStudent = no;
    update();
  }
  updateStudentPending(int no) {
    studentPending = no;
    update();
  }
}
