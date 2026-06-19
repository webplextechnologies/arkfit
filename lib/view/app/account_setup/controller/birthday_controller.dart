import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart' show AccountSetUpController;
import 'package:get/get.dart';

class BirthdayController extends GetxController {
  final month = 1.obs;
  final day = 1.obs;
  final year = 1995.obs;

  var selectedMonthIndex = 0.obs;
  var selectedDayIndex = 0.obs;
  var selectedYearIndex = 0.obs;

  late final List<int> months;
  late final List<int> years;
  late AccountSetUpController accountController;


  @override
  void onInit() {
    super.onInit();
    final currentYear = DateTime.now().year;
    months = List.generate(12, (i) => i + 1);
    years = List.generate(70, (i) => currentYear - i);
    accountController = Get.find<AccountSetUpController>();
    //accountController.onSubmit = submit;
  }


  List<int> get days {
    final daysInMonth = DateTime(year.value, month.value + 1, 0).day;
    return List.generate(daysInMonth, (i) => i + 1);
  }

  void updateMonth(int m) {
    month.value = m;
    _validateDay();
  }

  void updateYear(int y) {
    year.value = y;
    _validateDay();
  }

  void updateDay(int d) {
    day.value = d;
  }

  void _validateDay() {
    final maxDay = DateTime(year.value, month.value + 1, 0).day;
    if (day.value > maxDay) {
      day.value = maxDay;
       selectedDayIndex.value = maxDay - 1;
    }
  }
 

  void submit() {
  final accountController = Get.find<AccountSetUpController>();

  accountController.saveStepData(
    data: {
      "date_of_birth": formattedDob,
    },
  );
}


  /// ✅ FORMAT: 1991-07-25
  String get formattedDob {
    final m = month.value.toString().padLeft(2, '0');
    final d = day.value.toString().padLeft(2, '0');
    return "${year.value}-$m-$d";
  }
  
}

