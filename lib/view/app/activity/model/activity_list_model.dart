class ActivityListModel {
  bool? status;
  String? date;
  int? totalCalories;
  List<ActivityList>? data;

  ActivityListModel({this.status, this.date,this.totalCalories, this.data});

  ActivityListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    date = json['date'];
    totalCalories = json['total_calories']??0;
    if (json['data'] != null) {
      data = <ActivityList>[];
      json['data'].forEach((v) {
        data!.add(new ActivityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['date'] = this.date;
     data['total_calories'] = this.totalCalories;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActivityList {
  String? id;
  String? userId;
  String? workoutId;
  String? durationMinutes;
  String? caloriesBurned;
  String? activityDate;
  String? name;
  String? image;

  ActivityList(
      {this.id,
      this.userId,
      this.workoutId,
      this.durationMinutes,
      this.caloriesBurned,
      this.activityDate,    
      this.name,
      this.image});

  ActivityList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    workoutId = json['workout_id'];
    durationMinutes = json['duration_minutes']??'';
    caloriesBurned = json['calories_burned']??'';
    activityDate = json['activity_date']??'';
    name = json['name']??'';
    image = json['image']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['workout_id'] = this.workoutId;
    data['duration_minutes'] = this.durationMinutes;
    data['calories_burned'] = this.caloriesBurned;
    data['activity_date'] = this.activityDate;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
