class ActivityDetailsModel {
  bool? status;
  ActivityDetails? data;

  ActivityDetailsModel({this.status, this.data});

  ActivityDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new ActivityDetails.fromJson(json['data']) : null;
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

class ActivityDetails {
  int? id;
  String? name;
  String? description;
  String? image;
  String? imageUrl;
  num? caloriesPerMin;
  num? defaultDurationMin;
  num? estimatedCalories;
  bool? isFavorite;
  String? createdAt;

  ActivityDetails(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.imageUrl,
      this.caloriesPerMin,
      this.defaultDurationMin,
      this.estimatedCalories,
      this.isFavorite,
      this.createdAt});

  ActivityDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']??'';
    description = json['description']??'';
   
    image = json['image']??'';
    imageUrl = json['image_url']??'';
    caloriesPerMin = json['calories_per_min']??0.0;
    defaultDurationMin = json['default_duration_min']??0.0;
    estimatedCalories = json['estimated_calories']??0.0;
    isFavorite = json['is_favorite']??false;
    createdAt = json['created_at']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    
    data['image'] = this.image;
    data['image_url'] = this.imageUrl;
    data['calories_per_min'] = this.caloriesPerMin;
    data['default_duration_min'] = this.defaultDurationMin;
    data['estimated_calories'] = this.estimatedCalories;
    data['is_favorite'] = this.isFavorite;
    data['created_at'] = this.createdAt;
    return data;
  }
}
