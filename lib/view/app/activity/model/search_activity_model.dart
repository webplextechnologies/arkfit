class SearchActivityModel {
  bool? status;
  List<SearchActivity>? data;

  SearchActivityModel({this.status, this.data});

  SearchActivityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SearchActivity>[];
      json['data'].forEach((v) {
        data!.add(new SearchActivity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchActivity {
  String? id;
  String? name;
  String? image;
  String? caloriesPerMin;
 

  SearchActivity(
      {this.id,
      this.name,
      this.image,
      this.caloriesPerMin,
     });

  SearchActivity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']??'';
    image = json['image']??'';
    caloriesPerMin = json['calories_per_min'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
   
    data['name'] = this.name;
    data['image'] = this.image;
    data['calories_per_min'] = this.caloriesPerMin;
   
    return data;
  }
}
