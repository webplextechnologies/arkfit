class CountryListModel {
  bool? success;
  List<CountryList>? data;

  CountryListModel({this.success, this.data});

  CountryListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <CountryList>[];
      json['data'].forEach((v) {
        data!.add(new CountryList.fromJson(v));
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

class CountryList {
  String? id;
  String? name;
  String? isoCode;
  String? phoneCode;
  String? currency;
  String? createdAt;

  CountryList(
      {this.id,
      this.name,
      this.isoCode,
      this.phoneCode,
      this.currency,
      this.createdAt});

  CountryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isoCode = json['iso_code'];
    phoneCode = json['phone_code'];
    currency = json['currency'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['iso_code'] = this.isoCode;
    data['phone_code'] = this.phoneCode;
    data['currency'] = this.currency;
    data['created_at'] = this.createdAt;
    return data;
  }
}
