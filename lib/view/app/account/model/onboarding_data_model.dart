class OnboardingDataModel {
  bool? status;
  OnboardingData? data;

  OnboardingDataModel({this.status, this.data});

  OnboardingDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null
        ? new OnboardingData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OnboardingData {
  User? user;
  Profile? profile;

  OnboardingData({this.user, this.profile});

  OnboardingData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    profile = json['profile'] != null
        ? new Profile.fromJson(json['profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? dateOfBirth;
  String? countryCode;
  //  String? onboardingCompleted;
  // String? onboardingStep;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.countryCode,
    //this.onboardingCompleted,
    //this.onboardingStep
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'] ?? '';
    lastName = json['last_name'] ?? '';
    email = json['email'] ?? '';
    gender = json['gender'] ?? '';
    dateOfBirth = json['date_of_birth'] ?? '';
    countryCode = json['country_code'] ?? '';
    //onboardingCompleted = json['onboarding_completed'];
    //onboardingStep = json['onboarding_step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['country_code'] = this.countryCode;
    //data['onboarding_completed'] = this.onboardingCompleted;
    //data['onboarding_step'] = this.onboardingStep;
    return data;
  }
}

class Profile {
  String? heightCm;
  String? weightKg;
  String? targetWeightKg;
  String? goal;
  String? activityLevel;
  String? dietType;
  String? breakfastTime;
  String? lunchTime;
  String? snackTime;
  String? dinnerTime;
  String? bmi;
  String? dailyCalorieTarget;
  String? stepGoal;


  Profile({
    this.heightCm,
    this.weightKg,
    this.targetWeightKg,
    this.goal,
    this.activityLevel,
    this.dietType,
    this.breakfastTime,
    this.lunchTime,
    this.snackTime,
    this.dinnerTime,
    this.bmi,
    this.dailyCalorieTarget,
    this.stepGoal

  });

  Profile.fromJson(Map<String, dynamic> json) {
    heightCm = json['height_cm'] ?? '';
    weightKg = json['weight_kg'] ?? '';
    targetWeightKg = json['target_weight_kg'] ?? '';
    goal = json['goal'] ?? '';
    activityLevel = json['activity_level'] ?? '';
    dietType = json['diet_type'] ?? '';
    breakfastTime = json['breakfast_time'] ?? '';
    lunchTime = json['lunch_time'] ?? '';
    snackTime = json['snack_time'] ?? '';
    dinnerTime = json['dinner_time'] ?? '';
    bmi = json['bmi'] ?? '';
    dailyCalorieTarget = json['daily_calorie_target'] ?? '';
    stepGoal = json['step_goal']??'0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height_cm'] = this.heightCm;
    data['weight_kg'] = this.weightKg;
    data['target_weight_kg'] = this.targetWeightKg;
    data['goal'] = this.goal;
    data['activity_level'] = this.activityLevel;
    data['diet_type'] = this.dietType;
    data['breakfast_time'] = this.breakfastTime;
    data['lunch_time'] = this.lunchTime;
    data['snack_time'] = this.snackTime;
    data['dinner_time'] = this.dinnerTime;
    data['bmi'] = this.bmi;
    data['daily_calorie_target'] = this.dailyCalorieTarget;
    data['step_goal'] = this.stepGoal;
    return data;
  }
}
