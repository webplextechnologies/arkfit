class CurrentWeightModel {
  bool? status;
  CurrentWeight? data;

  CurrentWeightModel({this.status, this.data});

  CurrentWeightModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new CurrentWeight.fromJson(json['data']) : null;
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

class CurrentWeight {
  String? id;
  String? userId;
  String? weightKg;
  String? bmi;

  CurrentWeight(
      {this.id,
      this.userId,
      this.weightKg,
      this.bmi,
      });

  CurrentWeight.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    weightKg = json['weight_kg']??'0';
    bmi = json['bmi']??'0';
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['weight_kg'] = this.weightKg;
    data['bmi'] = this.bmi;
    return data;
  }
}
