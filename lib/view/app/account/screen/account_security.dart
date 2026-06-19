import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/view/app/account/controller/account_security_controller.dart';
import 'package:ark_fit_gym/view/app/account/screen/change_password_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AccountSecurity extends StatefulWidget {
  const AccountSecurity({super.key});

  @override
  State<AccountSecurity> createState() => _AccountSecurityState();
}

class _AccountSecurityState extends State<AccountSecurity> {
  bool biometricId = false;
  bool faceId = false;
  bool smsAuth = false;
  bool googleAuth = false;
  late AccountSecurityController accountSecurityController;

  @override
  void initState() {
    accountSecurityController = Get.put(AccountSecurityController());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text( tr("account_security"),style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card(
            children: [
            /*  _switchTile("Biometric ID", biometricId, (v) {
                setState(() => biometricId = v);
              }),

              _switchTile("Face ID", faceId, (v) {
                setState(() => faceId = v);
              }),
              _switchTile("SMS Authenticator", smsAuth, (v) {
                setState(() => smsAuth = v);
              }),

              _switchTile("Google Authenticator", googleAuth, (v) {
                setState(() => googleAuth = v);
              }),*/
              textTile(tr("change_password"),
              onTap: () => Get.to(()=>ChangePasswordScreen()),),
             //textTile("Device Management", subtitle:"Manage your account on the various devices you own."),
             /*  textTile(tr("deactivate_account"), subtitle: tr("temporarily_deactivate"),
              onTap: () => accountSecurityController.showDeactivateAccountBottomSheet(context),), */
              textTile(tr("delete_account"), subtitle: tr("delete_account_warning"), isDeleteAccount: true,
               onTap: () => accountSecurityController.showDeleteAccountBottomSheet(context),),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      padding:  EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(
         color: Colors.white,
         width: 1.w 
        ),

        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(children: children),
    );
  }

  Widget _switchTile(String title, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
             // color: AppColors.text,
            ),
          ),
        ),
        Switch(
          value: value,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: AppColors.iconColor,
          activeThumbColor: Colors.white,
          activeTrackColor: AppColors.secondary,
          trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
          onChanged: onChanged,
        ),
      ],
    );
  }

Widget textTile(String title, {String? subtitle, VoidCallback? onTap,  bool isDeleteAccount = false,}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding:  EdgeInsets.symmetric(vertical: 5.w),
      child: Row(
        children: [
          // Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: isDeleteAccount ? Colors.red : Theme.of(context).iconTheme.color,
                  ),
                ),
                if (subtitle != null) ...[
                   SizedBox(height: 4.w),
                  Text(
                    subtitle!,
                    style:  TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                     // color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
      
          // Trailing Icon
          IconButton(onPressed: (){}, icon: Icon(Icons.chevron_right))
           ,
        ],
      ),
    ),
  );
}

}
