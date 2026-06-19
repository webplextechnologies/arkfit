class StepHistoryModel {
  bool? status;
  String? date;
  List<StepHistoryList>? data;

  StepHistoryModel({this.status, this.date, this.data});

  StepHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    date = json['date'];
    if (json['data'] != null) {
      data = <StepHistoryList>[];
      json['data'].forEach((v) {
        data!.add(new StepHistoryList.fromJson(v));
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

class StepHistoryList {
  String? id;
  String? userId;
  String? steps;
  String? caloriesBurned;
  String? source;
  String? logDate;
  String? createdAt;

  StepHistoryList(
      {this.id,
      this.userId,
      this.steps,
      this.caloriesBurned,
      this.source,
      this.logDate,
      this.createdAt});

  StepHistoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    steps = json['steps']??'';
    caloriesBurned = json['calories_burned']??'';
    source = json['source']??'';
    logDate = json['log_date']??'';
    createdAt = json['created_at']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['steps'] = this.steps;
    data['calories_burned'] = this.caloriesBurned;
    data['source'] = this.source;
    data['log_date'] = this.logDate;
    data['created_at'] = this.createdAt;
    return data;
  }
}
