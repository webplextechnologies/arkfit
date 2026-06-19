import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/name_controller.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  late NameScreenController nameScreenController;
  @override
  void initState() {
    nameScreenController = Get.put(NameScreenController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        SizedBox(height: 40),
         Text(tr("whats_your_name"), style: AppTextStyles.headling),

        Expanded(
          child: Align(
            alignment: const Alignment(0, -0.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: nameScreenController.firstNameCtrl,
                fillColor: Colors.white,
                  hintText: tr("first_name"),
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/Profile.svg",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                CustomTextField(
                   controller: nameScreenController.lastNameCtrl,
                 fillColor: Colors.white,
                  hintText: tr("last_name"),
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/Profile.svg",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
