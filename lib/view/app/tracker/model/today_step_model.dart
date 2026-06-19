class TodayStepsModel {
  bool? status;
  String? date;
  int? steps;
  int? caloriesBurned;

  TodayStepsModel({this.status, this.date, this.steps, this.caloriesBurned});

  TodayStepsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    date = json['date'];
    steps = json['steps']??0;
    caloriesBurned = json['calories_burned']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['date'] = this.date;
    data['steps'] = this.steps;
    data['calories_burned'] = this.caloriesBurned;
    return data;
  }
}
