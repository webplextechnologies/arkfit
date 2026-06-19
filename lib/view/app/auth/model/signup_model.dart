class SignUpModel {
  bool? success;
  String? token;
  String? next;
  int? step;
  

  SignUpModel({this.success, this.token,this.next, this.step });

  SignUpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    token = json['token']??'';
    next = json['next']??'';
    step = json['step']??0;
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['token'] = this.token;
    data['next'] = this.next;
    data['step'] = this.step;
    return data;
  }
}
