class ScannedFoodModel {
  bool? status;
  String? message;
  ScannedFood? data;

  ScannedFoodModel({this.status, this.message, this.data});

  ScannedFoodModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new ScannedFood.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ScannedFood {
  int? scanId;
  String? imageUrl;
  String? foodItem;

  NutritionPer100g? nutritionPer100g;
  Serving? serving;
  NutritionForServing? nutritionForServing;
  Micros? micros;

  ScannedFood(
      {this.scanId,
      this.imageUrl,
      this.foodItem,
      this.nutritionPer100g,
      this.serving,
      this.nutritionForServing,
      this.micros});

  ScannedFood.fromJson(Map<String, dynamic> json) {
    scanId = json['scan_id'];
    imageUrl = json['image_url']??'';
    foodItem = json['food_item']??'';
    nutritionPer100g = json['nutrition_per_100g'] != null
        ? new NutritionPer100g.fromJson(json['nutrition_per_100g'])
        : null;
    serving =
        json['serving'] != null ? new Serving.fromJson(json['serving']) : null;
    nutritionForServing = json['nutrition_for_serving'] != null
        ? new NutritionForServing.fromJson(json['nutrition_for_serving'])
        : null;
    micros =
        json['micros'] != null ? new Micros.fromJson(json['micros']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scan_id'] = this.scanId;
    data['image_url'] = this.imageUrl;
    data['food_item'] = this.foodItem;
   if (this.nutritionPer100g != null) {
      data['nutrition_per_100g'] = this.nutritionPer100g!.toJson();
    }
    if (this.serving != null) {
      data['serving'] = this.serving!.toJson();
    }
    if (this.nutritionForServing != null) {
      data['nutrition_for_serving'] = this.nutritionForServing!.toJson();
    }
    if (this.micros != null) {
      data['micros'] = this.micros!.toJson();
    }
    return data;
  }
}

class Serving {
  int? weightG;

  Serving({this.weightG});

  Serving.fromJson(Map<String, dynamic> json) {
    weightG = json['weight_g']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weight_g'] = this.weightG;
    return data;
  }
}
class NutritionPer100g {
  num? calories;
  num? protein;
  num? carbs;
  num? fat;

  NutritionPer100g({this.calories, this.protein, this.carbs, this.fat});

  NutritionPer100g.fromJson(Map<String, dynamic> json) {
    calories = json['calories']??0.0;
    protein = json['protein']??0.0;
    carbs = json['carbs']??0.0;
    fat = json['fat']??0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calories'] = this.calories;
    data['protein'] = this.protein;
    data['carbs'] = this.carbs;
    data['fat'] = this.fat;
    return data;
  }
}


class NutritionForServing {
  num? calories;
  num? protein;
  num? carbs;
  num? fat;

  NutritionForServing({this.calories, this.protein, this.carbs, this.fat});

  NutritionForServing.fromJson(Map<String, dynamic> json) {
    calories = json['calories']??0.0;
    protein = json['protein']??0.0;
    carbs = json['carbs']??0.0;
    fat = json['fat']??0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calories'] = this.calories;
    data['protein'] = this.protein;
    data['carbs'] = this.carbs;
    data['fat'] = this.fat;
    return data;
  }
}
class Micros {
  List<Vitamins>? vitamins;
  List<Minerals>? minerals;

  Micros({this.vitamins, this.minerals});

  Micros.fromJson(Map<String, dynamic> json) {
    if (json['vitamins'] != null) {
      vitamins = <Vitamins>[];
      json['vitamins'].forEach((v) {
        vitamins!.add(new Vitamins.fromJson(v));
      });
    }
    if (json['minerals'] != null) {
      minerals = <Minerals>[];
      json['minerals'].forEach((v) {
        minerals!.add(new Minerals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vitamins != null) {
      data['vitamins'] = this.vitamins!.map((v) => v.toJson()).toList();
    }
    if (this.minerals != null) {
      data['minerals'] = this.minerals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vitamins {
  String? name;
  String? value;

  Vitamins({this.name, this.value});

  Vitamins.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}


class Minerals {
  String? name;
  String? value;

  Minerals({this.name, this.value});

  Minerals.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
