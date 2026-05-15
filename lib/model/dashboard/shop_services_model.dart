class ShopServicesModel {
  int? errorCode;
  List<ShopServicesCategoryModel>? result;

  ShopServicesModel({this.errorCode, this.result});

  ShopServicesModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    if (json['result'] != null) {
      result = <ShopServicesCategoryModel>[];
      json['result'].forEach((v) {
        result!.add(new ShopServicesCategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShopServicesCategoryModel {
  String? category;
  String? id;
  String? image;

  ShopServicesCategoryModel({this.category, this.id, this.image});

  ShopServicesCategoryModel.fromJson(Map<String, dynamic> json) {
    category = json['Category'];
    id = json['Id'];
    image = json['Image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Category'] = this.category;
    data['Id'] = this.id;
    data['Image'] = this.image;
    return data;
  }
}
