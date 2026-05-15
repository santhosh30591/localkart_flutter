class Choice {
  Choice({required this.id, required this.title, required this.icon});

  String id = "";
  String title;
  String icon;
}

class ChoiceModel {
  String? category;
  String? id;
  String? image;

  ChoiceModel({this.category, this.id, this.image});

  ChoiceModel.fromJson(Map<String, dynamic> json) {
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
