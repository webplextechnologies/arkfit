class ProfileModel {
  bool? success;
  Profile? data;

  ProfileModel({this.success, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Profile.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Profile {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? dateOfBirth;
  String? countryCode;
  String? status;
  String? onboardingCompleted;
  String? onboardingStep;
  String? phone;
  String? profileImage;
  String? isPremium;

  Profile(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.gender,
      this.dateOfBirth,
      this.countryCode,
      this.status,
      this.onboardingCompleted,
      this.onboardingStep,
      this.profileImage,
      this.phone,
      this.isPremium
    });

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name']??'';
    lastName = json['last_name']??'';
    email = json['email']??'';
    gender = json['gender']??'';
    dateOfBirth = json['date_of_birth']??'';
    countryCode = json['country_code']??'';
    status = json['status']??'';
    onboardingCompleted = json['onboarding_completed']??'';
    onboardingStep = json['onboarding_step']??'';
    profileImage = json['profile_image']??'';
    phone = json['phone']??'';
    isPremium = json['is_premium']??'0';
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
    data['status'] = this.status;
    data['onboarding_completed'] = this.onboardingCompleted;
    data['onboarding_step'] = this.onboardingStep;
    data['profile_image'] = this.profileImage;
    data['phone'] = this.phone;
    data['is_premium'] = this.isPremium;
    
    return data;
  }
}
