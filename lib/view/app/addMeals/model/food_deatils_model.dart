import 'dart:convert';

class FoodDetailsModel {
  bool? success;
  FoodDetails? data;

  FoodDetailsModel({this.success, this.data});

  FoodDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new FoodDetails.fromJson(json['data']) : null;
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

class FoodDetails {
  String? id;
  String? categoryId;
  String? name;
  String? description;
  String? calories;
  String? protein;
  String? carbs;
  String? fats;
  String? fiber;
  String? vitamins;
  String? minerals;

  /// decoded maps for UI usage
  Map<String, dynamic> vitaminsMap = {};
  Map<String, dynamic> mineralsMap = {};

  String? servingUnit;
  String? servingSize;
  String? image;
  bool? isFavorite;
  List<String>? availableUnits;


  FoodDetails({
    this.id,
    this.categoryId,
    this.name,
    this.description,
    this.calories,
    this.protein,
    this.carbs,
    this.fats,
    this.fiber,
    this.vitamins,
    this.minerals,
    this.servingUnit,
    this.servingSize,
    this.image,
    this.isFavorite,
    this.availableUnits
  });

  FoodDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    description = json['description'];
    calories = json['calories'];
    protein = json['protein'];
    carbs = json['carbs'];
    fats = json['fats'];
    fiber = json['fiber'];
    vitamins = json['vitamins'];
    minerals = json['minerals'];
    servingUnit = json['serving_unit']??'g';
    servingSize = json['serving_size']??"1";
    image = json['image'];
    isFavorite = json['isFavorite'];
    availableUnits = json['available_units'].cast<String>();
    if (vitamins != null && vitamins!.isNotEmpty) {
      try {
        vitaminsMap = jsonDecode(vitamins!);
      } catch (_) {
        vitaminsMap = {};
      }
    }

    if (minerals != null && minerals!.isNotEmpty) {
      try {
        mineralsMap = jsonDecode(minerals!);
      } catch (_) {
        mineralsMap = {};
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['name'] = name;
    data['description'] = description;
    data['calories'] = calories;
    data['protein'] = protein;
    data['carbs'] = carbs;
    data['fats'] = fats;
    data['fiber'] = fiber;
    data['vitamins'] = vitamins;
    data['minerals'] = minerals;
    data['serving_unit'] = servingUnit;
    data['image'] = image;
    data['isFavorite'] = isFavorite;
    data['available_units'] = availableUnits;
    return data;
  }
}
