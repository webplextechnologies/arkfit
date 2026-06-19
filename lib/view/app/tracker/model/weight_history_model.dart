class WeightHistoryModel {
  bool? status;
  List<WeightHistory>? data;

  WeightHistoryModel({this.status, this.data});

  WeightHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <WeightHistory>[];
      json['data'].forEach((v) {
        data!.add(new WeightHistory.fromJson(v));
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

class WeightHistory {
  String? id;
  String? userId;
  String? weightKg;
  String? bmi;
  String? logDate;
  String? createdAt;

  WeightHistory(
      {this.id,
      this.userId,
      this.weightKg,
      this.bmi,
      this.logDate,
      this.createdAt});

  WeightHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    weightKg = json['weight_kg']??'';
    bmi = json['bmi']??'';
    logDate = json['log_date']??'';
    createdAt = json['created_at']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['weight_kg'] = this.weightKg;
    data['bmi'] = this.bmi;
    data['log_date'] = this.logDate;
    data['created_at'] = this.createdAt;
    return data;
  }
}
