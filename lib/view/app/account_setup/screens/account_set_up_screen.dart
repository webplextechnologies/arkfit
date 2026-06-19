import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AccountSetUpScreen extends StatefulWidget {
  const AccountSetUpScreen({super.key});

  @override
  State<AccountSetUpScreen> createState() => _AccountSetUpScreenState();
}

class _AccountSetUpScreenState extends State<AccountSetUpScreen> {
  late AccountSetUpController accountSetUpController;
  @override
  void initState() {
    accountSetUpController = Get.put(AccountSetUpController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).iconTheme.color!,
              ),
              onPressed: () {
                if (accountSetUpController.step.value > 0) {
                  accountSetUpController.back();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            //
            title: Obx(() {
              if (accountSetUpController.step.value ==
                      accountSetUpController.onboardingBackgrounds.length - 1 ||
                  accountSetUpController.step.value ==
                      accountSetUpController.onboardingBackgrounds.length - 2) {
                return SizedBox();
              }
              return Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: LinearProgressIndicator(
                        value:(accountSetUpController.step.value + 1) /
                            accountSetUpController.onboardingBackgrounds.length,
                        minHeight: 10.h,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xffFF8C2B),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),
                  Text(
                    "${accountSetUpController.step.value + 1} / 12",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Obx(() {
                  final step = accountSetUpController.step.value;

                  if (Theme.of(context).brightness == Brightness.dark) {
                    return Container(color: Colors.black);
                  }

                  return Image.asset(
                    accountSetUpController.onboardingBackgrounds[step],
                    fit: BoxFit.cover,
                    color: Colors.white.withOpacity(0.85),
                    colorBlendMode: BlendMode.lighten,
                  );
                }),
              ),

              SafeArea(
                child: Obx(
                  () => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: accountSetUpController.currentSteps(
                      accountSetUpController.step.value,
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: EdgeInsets.fromLTRB(20.w, 22.w, 20.w, 30.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                // border: Border(
                //   top: BorderSide(color: Theme.of(context).dividerColor!),
                // ),
              ),
              child: Obx(
                () => CustomButton(
                  title:
                      accountSetUpController.step.value ==
                          accountSetUpController.onboardingBackgrounds.length -
                              1
                      ? tr("start_plan")
                      : tr("continue"),
                  onPressed: () {
                     accountSetUpController.submitCurrentStep();
                   // accountSetUpController.next();
                  },
                  //accountSetUpController.next,
                ),
              ),
            ),
          ),
        ),
        Obx(() {
          return accountSetUpController.isLoading.value
              ? Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    alignment: Alignment.center,
                    child: CircularLoader(),
                  ),
                )
              : const SizedBox.shrink();
        }),
      ],
    );
  }
}
