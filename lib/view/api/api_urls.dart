class ApiUrls {
  static const String privacyPolicyUrl = 'https://the-arkfit.com/privacy-policy.php';
  static const String baseUrl = "https://api-arkfit.ai8.in";
  static const String api = "$baseUrl/api/v1";

  static const String openBmiSource =
      "https://ncdip.moh.gov.jm/know-your-numbers/body-mass-index-bmi-waist-circumference/";

  //auth
  static const String auth = "$api/auth";
  static const String login = "$auth/login";
  static const String register = "$auth/register";
  static const String forgotPasswordSendOtp = "$auth/forgot-password";
  static const String forgotPasswordVerifyOtp = "$auth/verify-otp";
  static const String resetPassword = "$auth/reset-password";
  static const String logout = "$auth/logout";

  //onboarding
  static const String onboarding = "$api/onboarding";
  static const String onboardingSteps = "$onboarding/step/";
  static const String saveOnboarding = "$onboarding/questions";
  static const String getCountries = "$api/countries";
  static const String getNutrition = "$api/nutrition/calculate";
  static const String getOnboardingData = "$onboarding/data";

  //profile
  static const String getProfile = "$api/profile";

  //dasboard
  static const String dashboard = "$api/dashboard";
  static const String getAnalytics = "$api/analytics";

  //food
  static const String foods = "$api/foods/";
  static const String searchFood = "${foods}search?q=";
  static const String recentFood = "${foods}recent";
  static const String favoriteFood = "${foods}favorites";
  static const String addRecentFood = "${foods}click/";
  static const String createFood = "${foods}custom";
  static const String editCustomFood = "${foods}custom/";
  static const String customFood = "${foods}custom";

  //https://api-arkfit.ai8.in/api/v1/foods/custom

  //mealLoging
  static const String meals = "$api/meals";
  static const String addMealItem = "$meals/items/";

  //activity
  static const String searchActivity = "$api/workouts/search?q=";
  static const String addRecentActivity = "$api/workouts/click/";
  static const String saveActivity = "$api/activities";

  //activities/1
  static const String getActivityByDate = "$api/activities?date=";
  static const String deleteActivity = "$api/activities/";
  static const String activityDetails = "$api/activities/";

  //favorites
  static const String recentActivity = "$api/workouts/recent-clicks";
  static const String favoriteActivity = "$api/workouts/favorites";
  static const String addFavoriteActivity = "$api/workouts/favorites/";

  //recent
  static const String createCustomActivity = "$api/workouts/custom";
  static const String deleteCustomActivity = "$api/workouts/custom";

  //water
  static const String todayWater = "$api/water/today";
  static const String waterHistory = "$api/water/history";
  static const String addWater = "$api/water/log";

  //steps
  static const String todaySteps = "$api/steps/today";
  static const String stepsHistory = "$api/steps/history";
  static const String addSteps = "$api/steps/manual";
  static const String deleteSteps = "$api/steps/";

  //weight
  static const String currentWeight = "$api/weight/current";
  static const String weightHistory = "$api/weight/history";
  static const String addWeight = "$api/weight/log";
  static const String currentBmi = "$api/health/bmi";
  static const String deleteweight = "$api/weight/";

  ///noah/chat
  static const String aiChat = "$api/noah/chat";
  static const String settings = "$api/settings";
  static const String deactivateAccount = "$settings/delete-account";

  //https://api-arkfit.ai8.in/api/v1/scan-food
  static const String scanFood = "$api/scan-food";
  //https://api-arkfit.ai8.in/api/v1/foods/barcode
  static const String scanBarcode = "$api/foods/barcode";
  //https://api-arkfit.ai8.in/api/v1/auth/google-login
  static const String googleLogin = "$api/auth/google-login";

  //subscription
  static const String subscriptionPlans = "$api/plans";
  static const String currentPlan = "$api/plans/current/";
  static const String createPayment = "$baseUrl/api/payment/create";
  static const String getDeviceToken = "$api/register-device";
}
