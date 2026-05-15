class NotificationModel {
  int? errorCode;
  String? message;
  List<Result>? result;

  NotificationModel({this.errorCode, this.message, this.result});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? type;
  String? shopType;
  dynamic? shopIndexId;
  int? postIndexId;
  String? postType;
  String? postHeading;
  String? fromDate;
  String? toDate;

  Result({
    this.type,
    this.shopType,
    this.shopIndexId,
    this.postIndexId,
    this.postType,
    this.postHeading,
    this.fromDate,
    this.toDate,
  });

  Result.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    shopType = json['shopType'];
    shopIndexId = json['shopIndexId'];
    postIndexId = json['postIndexId'];
    postType = json['postType'];
    postHeading = json['postHeading'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['shopType'] = this.shopType;
    data['shopIndexId'] = this.shopIndexId;
    data['postIndexId'] = this.postIndexId;
    data['postType'] = this.postType;
    data['postHeading'] = this.postHeading;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    return data;
  }
}

class NotificationDetailModel {
  int? errorCode;
  String? message;
  NotificationDetailResult? result=new NotificationDetailResult();

  NotificationDetailModel({this.errorCode, this.message, this.result});

  NotificationDetailModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];


    result = json['result'] != null
        ? new NotificationDetailResult.fromJson(json['result'])
        : null;


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;


    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class NotificationDetailResult {
  String? title;
  int? id;
  String? content_type;
  String? General;
  String? description;
  String? scheduled_date;

  String? toDate;
  String? image;
  String? time;

  NotificationDetailResult({
    this.id,
    this.title,
    this.content_type,
    this.General,
    this.description,
    this.image,
    this.scheduled_date,
    this.time,
  });

  NotificationDetailResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content_type = json['content_type'];
    General = json['General'];
    description = json['description'];
    image = json['image'];
    scheduled_date = json['scheduled_date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content_type'] = this.content_type;
    data['General'] = this.General;
    // data['description'] = this.description;
    data['image'] = this.image;
    data['scheduled_date'] = this.scheduled_date;
    data['time'] = this.time;
    return data;
  }
}
