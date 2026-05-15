class ListPostTypesModel {
  int? errorCode;
  String? message;
  SelectType? selectType;
  int? count;
  List<AccessOption>? accessOption;

  ListPostTypesModel(
      {this.errorCode,
      this.message,
      this.selectType,
      this.count,
      this.accessOption});

  ListPostTypesModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['Message'];
    selectType = json['selectType'] != null
        ? new SelectType.fromJson(json['selectType'])
        : null;
    count = json['count'];
    if (json['accessOption'] != null) {
      accessOption = <AccessOption>[];
      json['accessOption'].forEach((v) {
        accessOption!.add(new AccessOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['Message'] = this.message;
    if (this.selectType != null) {
      data['selectType'] = this.selectType!.toJson();
    }
    data['count'] = this.count;
    if (this.accessOption != null) {
      data['accessOption'] = this.accessOption!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectType {
  String? s1;
  String? s2;
  String? s3;

  SelectType({this.s1, this.s2, this.s3});

  SelectType.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    return data;
  }
}

class AccessOption {
  String? keyName;
  String? value;

  AccessOption({this.keyName, this.value});

  AccessOption.fromJson(Map<String, dynamic> json) {
    keyName = json['keyName'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keyName'] = this.keyName;
    data['value'] = this.value;
    return data;
  }
}
