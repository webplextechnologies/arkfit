import 'dart:convert';

class CurrentPlanModel {
  bool? status;
  bool? hasActivePlan;
  bool? isFree;
  CurrentPlan? data;

  CurrentPlanModel({this.status, this.hasActivePlan, this.isFree, this.data});

  CurrentPlanModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    hasActivePlan = json['has_active_plan'];
    isFree = json['is_free'];
    data = json['data'] != null ? new CurrentPlan.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['has_active_plan'] = this.hasActivePlan;
    data['is_free'] = this.isFree;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CurrentPlan {
  String? id;
  String? userId;
  String? planId;
  String? startDate;
  String? endDate;
  String? status;
  String? createdAt;
  String? planName;
  String? price;
  String? durationDays;
  List<FeatureModel>? features;
  int? daysLeft;

  CurrentPlan(
      {this.id,
      this.userId,
      this.planId,
      this.startDate,
      this.endDate,
      this.status,
      this.createdAt,
      this.planName,
      this.price,
      this.durationDays,
      this.features,
      this.daysLeft});

  CurrentPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    planId = json['plan_id'];
    startDate = json['start_date']??'';
    endDate = json['end_date']??'';
    status = json['status']??'';
    createdAt = json['created_at']??'';
    planName = json['plan_name']??'';
    price = json['price']??'';
    durationDays = json['duration_days'];
    if (json['features'] != null) {
      final decoded = jsonDecode(json['features']);
      features = (decoded as List)
          .map((e) => FeatureModel.fromJson(e))
          .toList();
    }
    daysLeft = json['days_left']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['plan_id'] = this.planId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['plan_name'] = this.planName;
    data['price'] = this.price;
    data['duration_days'] = this.durationDays;
    data['features'] = this.features;
    data['days_left'] = this.daysLeft;
    return data;
  }
}

class FeatureModel {
  String? title;
  dynamic value;

  FeatureModel({this.title, this.value});

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      title: json['title'],
      value: json['value'],
    );
  }
}
