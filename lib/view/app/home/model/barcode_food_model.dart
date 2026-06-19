import 'dart:convert';

class BarcodeFoodModel {
  bool? success;
  BarcodeFood? data;

  BarcodeFoodModel({this.success, this.data});

  BarcodeFoodModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new BarcodeFood.fromJson(json['data']) : null;
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

class BarcodeFood {
  String? id;
  String? name;
  String? description;
  String? servingUnit;
  String? servingSize;
  String? barcode;
  String? brand;
  String? calories;
  String? protein;
  String? carbs;
  String? fats;
  String? fiber;
  String? vitamins;
  String? minerals;

  
  Map<String, dynamic> vitaminsMap = {};
  Map<String, dynamic> mineralsMap = {};

  String? image;
  String? sugar;
  String? saturatedFat;
  String? cholesterol;
 
  String? createdAt;
  bool? isFavorite;

  BarcodeFood(
      {this.id,
     
      this.name,
      this.description,
      this.servingUnit,
      this.servingSize,
      this.barcode,
      this.brand,
      this.calories,
      this.protein,
      this.carbs,
      this.fats,
      this.fiber,
      this.vitamins,
      this.minerals,
      this.image,
      this.sugar,
      this.saturatedFat,
      this.cholesterol,
     
      this.createdAt,
      this.isFavorite});

  BarcodeFood.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']??'';
    description = json['description']??'';
    servingUnit = json['serving_unit']??'';
    servingSize = json['serving_size']??'';
    barcode = json['barcode']??'';
    brand = json['brand']??'';
    calories = json['calories']??'';
    protein = json['protein']??'';
    carbs = json['carbs']??'0';
    fats = json['fats']??'0';
    fiber = json['fiber']??'0';
    vitamins = json['vitamins']??'';
    minerals = json['minerals']??'';

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
    image = json['image']??'';
    sugar = json['sugar']??'';
    saturatedFat = json['saturated_fat']??'';
    cholesterol = json['cholesterol']??'';
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['serving_unit'] = this.servingUnit;
    data['serving_size'] = this.servingSize;
    data['barcode'] = this.barcode;
    data['brand'] = this.brand;
    data['calories'] = this.calories;
    data['protein'] = this.protein;
    data['carbs'] = this.carbs;
    data['fats'] = this.fats;
    data['fiber'] = this.fiber;
    data['vitamins'] = this.vitamins;
    data['minerals'] = this.minerals;
    data['image'] = this.image;
    data['sugar'] = this.sugar;
    data['saturated_fat'] = this.saturatedFat;
    data['cholesterol'] = this.cholesterol;
 
    data['created_at'] = this.createdAt;
    data['isFavorite'] = this.isFavorite;
    return data;
  }
}
