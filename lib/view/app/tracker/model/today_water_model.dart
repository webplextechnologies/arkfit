class TodayWaterModel {
  bool? status;
  String? date;
  int? consumedMl;
  int? targetMl;
  int? remainingMl;

  TodayWaterModel(
      {this.status,
      this.date,
      this.consumedMl,
      this.targetMl,
      this.remainingMl});

  TodayWaterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    date = json['date'];
    consumedMl = json['consumed_ml']??0;
    targetMl = json['target_ml']??0;
    remainingMl = json['remaining_ml']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['date'] = this.date;
    data['consumed_ml'] = this.consumedMl;
    data['target_ml'] = this.targetMl;
    data['remaining_ml'] = this.remainingMl;
    return data;
  }
}
