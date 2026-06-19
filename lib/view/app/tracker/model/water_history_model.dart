class WaterHistoryModel {
  bool? status;
  String? date;
  List<WaterHistory>? data;

  WaterHistoryModel({this.status, this.date, this.data});

  WaterHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    date = json['date'];
    if (json['data'] != null) {
      data = <WaterHistory>[];
      json['data'].forEach((v) {
        data!.add(new WaterHistory.fromJson(v));
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

class WaterHistory {
  String? id;
  String? userId;
  String? amountMl;
  String? logDate;
  String? createdAt;

  WaterHistory({this.id, this.userId, this.amountMl, this.logDate, this.createdAt});

  WaterHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    amountMl = json['amount_ml']??'0';
    logDate = json['log_date']??'';
    createdAt = json['created_at']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['amount_ml'] = this.amountMl;
    data['log_date'] = this.logDate;
    data['created_at'] = this.createdAt;
    return data;
  }
}
