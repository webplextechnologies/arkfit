class MealsListModel {
  bool? status;
  String? date;
  List<MealsList>? data;

  MealsListModel({this.status, this.date, this.data});

  MealsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    date = json['date'];
    if (json['data'] != null) {
      data = <MealsList>[];
      json['data'].forEach((v) {
        data!.add(new MealsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['date'] = this.date;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MealsList {
  String? id;
  String? userId;
  String? mealType;
  String? mealDate;
  String? totalCalories;
  String? createdAt;
  String? updatedAt;
  List<Items>? items;

  MealsList(
      {this.id,
      this.userId,
      this.mealType,
      this.mealDate,
      this.totalCalories,
      this.createdAt,
      this.updatedAt,
      this.items});

  MealsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    mealType = json['meal_type']??'';
    mealDate = json['meal_date']??'';
    totalCalories = json['total_calories']??'';
    createdAt = json['created_at']??'';
    updatedAt = json['updated_at']??'';
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['meal_type'] = this.mealType;
    data['meal_date'] = this.mealDate;
    data['total_calories'] = this.totalCalories;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? id;
  String? mealId;
  String? foodId;
  String? quantity;
  String? servingUnit;
  String? calories;
  String? protein;
  String? carbs;
  String? fats;
  String? microsJson;
  String? foodName;
  String? foodImage;

  Items(
      {this.id,
      this.mealId,
      this.foodId,
      this.quantity,
      this.servingUnit,
      this.calories,
      this.protein,
      this.carbs,
      this.fats,
      this.microsJson,
      this.foodName,
      this.foodImage,});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mealId = json['meal_id']??'';
    foodId = json['food_id']??'';
    quantity = json['quantity']??'';
    servingUnit = json['serving_unit']??'';
    calories = json['calories']??'';
    protein = json['protein']??'';
    carbs = json['carbs']??'';
    fats = json['fats']??'';
    microsJson = json['micros_json']??'';
    foodName = json['name']??'';
    foodImage = json['food_image']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['meal_id'] = this.mealId;
    data['food_id'] = this.foodId;
    data['quantity'] = this.quantity;
    data['serving_unit'] = this.servingUnit;
    data['calories'] = this.calories;
    data['protein'] = this.protein;
    data['carbs'] = this.carbs;
    data['fats'] = this.fats;
    data['micros_json'] = this.microsJson;
    data['food_name'] = this.foodName;
    data['food_image'] = this.foodImage;
    return data;
  }
}
