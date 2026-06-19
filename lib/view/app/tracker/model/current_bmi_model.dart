class CurrentBmiModel {
  bool? status;
  CurrentBmi? data;

  CurrentBmiModel({this.status, this.data});

  CurrentBmiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new CurrentBmi.fromJson(json['data']) : null;
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

class CurrentBmi {
  String? heightCm;
  String? bmi;
  String? category;

  CurrentBmi({this.heightCm, this.bmi, this.category});

  CurrentBmi.fromJson(Map<String, dynamic> json) {
    heightCm = json['height_cm']??'';
    bmi = json['bmi']??'';
    category = json['category']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height_cm'] = this.heightCm;
    data['bmi'] = this.bmi;
    data['category'] = this.category;
    return data;
  }
}
