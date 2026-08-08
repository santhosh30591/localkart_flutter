class AiHomeDataModel {
  int? errorCode;
  String? title;
  String? subtitle;
  List<AiItem>? shop;
  List<AiItem>? service;
  List<AiItem>? offer;

  AiHomeDataModel({
    this.errorCode,
    this.title,
    this.subtitle,
    this.shop,
    this.service,
    this.offer,
  });

  AiHomeDataModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    title = json['title'];
    subtitle = json['subtitle'];
    if (json['shop'] != null) {
      shop = <AiItem>[];
      json['shop'].forEach((v) {
        shop!.add(AiItem.fromJson(v));
      });
    }
    if (json['service'] != null) {
      service = <AiItem>[];
      json['service'].forEach((v) {
        service!.add(AiItem.fromJson(v));
      });
    }
    if (json['offer'] != null) {
      offer = <AiItem>[];
      json['offer'].forEach((v) {
        offer!.add(AiItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errorCode'] = errorCode;
    data['title'] = title;
    data['subtitle'] = subtitle;
    if (shop != null) {
      data['shop'] = shop!.map((v) => v.toJson()).toList();
    }
    if (service != null) {
      data['service'] = service!.map((v) => v.toJson()).toList();
    }
    if (offer != null) {
      data['offer'] = offer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AiItem {
  String? name;
  String? id;
  String? type;

  AiItem({this.name, this.id, this.type});

  AiItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id']?.toString();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}
