import 'dart:convert';

class SubscriptionPlansModel {
  bool? status;
  List<SubscriptionPlans>? data;

  SubscriptionPlansModel({this.status, this.data});

  SubscriptionPlansModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SubscriptionPlans>[];
      json['data'].forEach((v) {
        data!.add(new SubscriptionPlans.fromJson(v));
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

class SubscriptionPlans {
  String? id;
  String? name;
  String? price;
  String? durationDays;
  List<FeatureModel>? features;
  

  SubscriptionPlans(
      {this.id,
      this.name,
      this.price,
      this.durationDays,
       this.features,
     });

  SubscriptionPlans.fromJson(Map<String, dynamic> json) {
    id = json['id']??'';
    name = json['name']??'';
    price = json['price']??'';
    durationDays = json['duration_days']??'';
  
   if (json['features'] != null) {
      final decoded = jsonDecode(json['features']);
      features = (decoded as List)
          .map((e) => FeatureModel.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['duration_days'] = this.durationDays;
     data['features'] = this.features;
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
