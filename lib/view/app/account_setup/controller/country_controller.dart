import 'dart:convert';
import 'package:ark_fit_gym/view/app/account_setup/model/country_list_model.dart';
import 'package:get/get.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';

class CountryController extends GetxController {
  late AccountSetUpController accountController;

  var countries = <CountryList>[].obs;
  Rx<CountryList?> selectedCountry = Rx<CountryList?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    accountController = Get.find<AccountSetUpController>();
   // accountController.onSubmit = submit;
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    print("fetchCountries");
    try {
      isLoading.value = true;
      
      final response = await ApiServices.getRequest(ApiUrls.getCountries);

      final jsonResponse = jsonDecode(response.body);
      print(ApiUrls.getCountries);
      print(jsonResponse);
      if (response.statusCode == 200) {
        print(response.body);
        CountryListModel model = CountryListModel.fromJson(jsonResponse);
        countries.value = model.data??[];
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load countries");
    } finally {
      isLoading.value = false;
    }
  }

  void submit() {
    if (selectedCountry.value == null) {
      Get.snackbar("Error", "Please select a country");
      return;
    }

    accountController.saveStepData(
      data: {
        "country_code": "${selectedCountry.value!.isoCode}",
      },
    );
  }
}
