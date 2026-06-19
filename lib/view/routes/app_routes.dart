
import 'package:ark_fit_gym/view/app/auth/login_screen.dart';
import 'package:ark_fit_gym/view/app/auth/sign_up_screen.dart';
import 'package:ark_fit_gym/view/app/auth/welcome_screen.dart';
import 'package:ark_fit_gym/view/app/dashboard/dashboard_screen.dart';
import 'package:ark_fit_gym/view/app/onboarding/onboarding_screen.dart';
import 'package:ark_fit_gym/view/app/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const dashboard = '/dashboard';
  static const String home = '/home';
   static const login = '/login';
    static const welcome = '/welcome';
  static const signUp = '/signUp';

  static final List<GetPage> routes = [
     GetPage(
      name: splash,
      page: () =>  SplashScreen(),
     // binding: SplashBinding(),
    ),
    GetPage(
      name: onboarding,
      page: () =>  OnboardingScreen(),
     // binding: OnboardingBinding(),
    ),
    GetPage(
      name: dashboard,
      page: () =>  DashboardScreen(),
     // binding: DashboardBinding(),
    ),
    GetPage(
      name: welcome,
      page: () =>  WelcomeScreen(),
    //  binding: HomeBinding(),
    ),
    GetPage(
      name: login,
      page: () =>  LoginScreen(),
    
    ),
     GetPage(
      name: signUp,
      page: () =>  SignUpScreen(),
    
    ),
  ];
}
