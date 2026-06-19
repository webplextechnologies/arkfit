class OnboardingQuesModel {
  bool? success;
  List<Questions>? data;

  OnboardingQuesModel({this.success, this.data});

  OnboardingQuesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Questions>[];
      json['data'].forEach((v) {
        data!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String? id;
  String? step;
  String? questionKey;
  String? questionText;
  String? inputType;
  String? options;
  String? createdAt;

  Questions(
      {this.id,
      this.step,
      this.questionKey,
      this.questionText,
      this.inputType,
      this.options,
      this.createdAt});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    step = json['step'];
    questionKey = json['question_key'];
    questionText = json['question_text'];
    inputType = json['input_type'];
    options = json['options'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['step'] = this.step;
    data['question_key'] = this.questionKey;
    data['question_text'] = this.questionText;
    data['input_type'] = this.inputType;
    data['options'] = this.options;
    data['created_at'] = this.createdAt;
    return data;
  }
}
