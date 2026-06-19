class SettingsDataModel {
  bool? status;
  SettingsData? data;

  SettingsDataModel({this.status, this.data});

  SettingsDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new SettingsData.fromJson(json['data']) : null;
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

class SettingsData {
  String? id;
  String? userId;
  String? calorieGoal;
  String? calorieUnit;
  String? pushNotifications;
  String? emailNotifications;
  String? communityNotifications;
  String? weightUnit;
  String? waterUnit;
  String? waterGoal;
  String? stepGoal;
  String? weightGoal;
  String? heightUnit;
  String? theme;
  String? profileVisibility;
  String? createdAt;
  String? updatedAt;

  SettingsData(
      {this.id,
      this.userId,
      this.calorieGoal,
      this.calorieUnit,
      this.pushNotifications,
      this.emailNotifications,
      this.communityNotifications,
      this.weightUnit,
      this.waterUnit,
      this.waterGoal,
      this.stepGoal,
      this.weightGoal,
      this.heightUnit,
      this.theme,
      this.profileVisibility,
      this.createdAt,
      this.updatedAt});

  SettingsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id']??'';
    calorieGoal = json['calorie_goal']??'0';
    calorieUnit = json['calorie_unit']??'';
    pushNotifications = json['push_notifications']??'';
    emailNotifications = json['email_notifications']??'';
    communityNotifications = json['community_notifications']??'';
    weightUnit = json['weight_unit']??'';
    waterUnit = json['water_unit']??'';
    waterGoal = json['water_goal']??'0';
    stepGoal = json['step_goal']??'0';
    weightGoal = json['weight_goal']??'0';
    heightUnit = json['height_unit']??'';
    theme = json['theme']??'';
    profileVisibility = json['profile_visibility']??'';
    createdAt = json['created_at']??'';
    updatedAt = json['updated_at']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['calorie_goal'] = this.calorieGoal;
    data['calorie_unit'] = this.calorieUnit;
    data['push_notifications'] = this.pushNotifications;
    data['email_notifications'] = this.emailNotifications;
    data['community_notifications'] = this.communityNotifications;
    data['weight_unit'] = this.weightUnit;
    data['water_unit'] = this.waterUnit;
    data['water_goal'] = this.waterGoal;
    data['step_goal'] = this.stepGoal;
     data['weight_goal'] = this.weightGoal;
    //
    data['height_unit'] = this.heightUnit;
    data['theme'] = this.theme;
    data['profile_visibility'] = this.profileVisibility;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
