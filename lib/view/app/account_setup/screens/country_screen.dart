import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/country_controller.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  

  late CountryController countryController;
  
  final TextEditingController countryCtrl = TextEditingController();
  @override
  void initState() {
   countryController = Get.put(CountryController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text(
          tr("select_country"),
          textAlign: TextAlign.center,
          style: AppTextStyles.headling,
        ),
        const SizedBox(height: 30),

        Obx(() {
          if (countryController.isLoading.value) {
            return const CircularProgressIndicator();
          }
          return CustomTextField(
            controller: countryCtrl,
            fillColor: Colors.white,
            hintText: tr("select_country_short"),
            readOnly: true,
            suffixIcon: const Icon(Icons.arrow_drop_down),
            onTap: () => _openCountryPicker(context),
          );
        }),
      ],
    );
  }

  void _openCountryPicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.6,
        decoration:  BoxDecoration(
       color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(
          () => ListView.builder(
            itemCount: countryController.countries.length,
            itemBuilder: (context, index) {
              final country = countryController.countries[index];
              return ListTile(
                title: Text(country.name??''),
                onTap: () {
                  countryController.selectedCountry.value = country;
                  countryCtrl.text = country.name??'';
                  Get.back();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
