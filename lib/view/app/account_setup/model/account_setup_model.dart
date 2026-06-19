class AccountSetupDataModel {
  bool? status;
  NutritionModel ? data;

  AccountSetupDataModel({this.status, this.data});

  AccountSetupDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new NutritionModel.fromJson(json['data']) : null;
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

class NutritionModel  {
 
  int? dailyCalories;
  Macros? macros;
  GoalPlan? goalPlan;


  NutritionModel ({ this.dailyCalories, this.macros, this.goalPlan});

  NutritionModel.fromJson(Map<String, dynamic> json) {
   
    dailyCalories = json['daily_calories'];
    macros =
        json['macros'] != null ? new Macros.fromJson(json['macros']) : null;
    goalPlan = json['goal_plan'] != null
        ? new GoalPlan.fromJson(json['goal_plan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   
    data['daily_calories'] = this.dailyCalories;
    if (this.macros != null) {
      data['macros'] = this.macros!.toJson();
    }
    if (this.goalPlan != null) {
      data['goal_plan'] = this.goalPlan!.toJson();
    }
    return data;
  }
}

class Macros {
  int? proteinGrams;
  int? carbsGrams;
  int? fatGrams;

  Macros({this.proteinGrams, this.carbsGrams, this.fatGrams});

  Macros.fromJson(Map<String, dynamic> json) {
    proteinGrams = json['protein_grams'];
    carbsGrams = json['carbs_grams'];
    fatGrams = json['fat_grams'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['protein_grams'] = this.proteinGrams;
    data['carbs_grams'] = this.carbsGrams;
    data['fat_grams'] = this.fatGrams;
    return data;
  }
  
}
class GoalPlan {
  num? pacePerMonthKg;
  num? estimatedMonths;

  GoalPlan({this.pacePerMonthKg, this.estimatedMonths});

  GoalPlan.fromJson(Map<String, dynamic> json) {
    pacePerMonthKg = json['pace_per_month_kg'];
    estimatedMonths = json['estimated_months'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pace_per_month_kg'] = this.pacePerMonthKg;
    data['estimated_months'] = this.estimatedMonths;
    return data;
  }
}