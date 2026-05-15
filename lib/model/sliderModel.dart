class SliderModel {
  String? image;
  String? actionType;
  String? dataLink;

  SliderModel({this.image, this.actionType, this.dataLink});

  SliderModel.fromJson(Map<String, dynamic> json) {
    image = json['Image'];
    actionType = json['actionType'];
    dataLink = json['dataLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Image'] = this.image;
    data['actionType'] = this.actionType;
    data['dataLink'] = this.dataLink;
    return data;
  }
}
