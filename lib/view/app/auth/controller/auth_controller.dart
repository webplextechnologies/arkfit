import 'dart:convert';
import 'dart:developer';

import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/account_set_up_screen.dart';
import 'package:ark_fit_gym/view/app/auth/model/login_model.dart';
import 'package:ark_fit_gym/view/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  late SharedPreferences prefs;

  @override
  void onReady() async {
    prefs = await SharedPreferences.getInstance();
    super.onReady();
  }

  Future<void> signInWithGoogle() async {
    try {
      await initGoogleSignIn();

      final GoogleSignInAccount? account = await googleSignIn.authenticate();
      print(account?.displayName ?? '');

      if (account == null) {
        print("User cancelled Google Sign-In");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        print("Failed to get ID Token");
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);

      final UserCredential userCred = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = userCred.user;
      final userToken = await user!.getIdToken(true);

      print('Signed in successfully');

      if (user != null) {
        print("Name: ${user.displayName}");
        print("Email: ${user.email}");
        print(ApiUrls.googleLogin);
        log(userToken!);

        final response = await ApiServices.postRequest(
          ApiUrls.googleLogin,
          body: {"auth_token": userToken},
        );
        var jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          LoginModel model = LoginModel.fromJson(jsonResponse);
          AppSnackBar.showSuccess("Login successfully");
          prefs.setString('token', model.token ?? '');
          prefs.setInt('onboarding_step', model.step!);
          prefs.setString('next_step', model.next!);
          if (model.next == "onboarding") {
            Get.to(() => AccountSetUpScreen());
          } else {
            Get.offAllNamed(AppRoutes.dashboard);
          }
          print(response.body);
        } else {
          AppSnackBar.showSnackBar('Somthind went wrong');
          print(response.body);
        }
      }
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        print(e.code);
        print("User canceled login");
      } else {
        print("Google Sign-In error: ${e.code}");
      }
      // return null;
    } catch (e) {
      print("Unexpected error: $e");
      // return null;
    }
  }

  Future<void> initGoogleSignIn() async {
    await googleSignIn.initialize(
      serverClientId:
          '691755548374-u11aj563lom9e8j6hdktok5ssgeano52.apps.googleusercontent.com',
    );
    print('GoogleSignIn is initialized');
  }
}
