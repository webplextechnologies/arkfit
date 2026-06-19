class SearchFoodModel {
  bool? success;
  List<FoodList>? data;

  SearchFoodModel({this.success, this.data});

  SearchFoodModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <FoodList>[];
      json['data'].forEach((v) {
        data!.add(new FoodList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodList {
  String? id;
  String? name;
  String? description;
  String? image;
  

  FoodList(
      {this.id,
      this.name,
      this.description,
      this.image,
      });

  FoodList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
   
    return data;
  }
}
