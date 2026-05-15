class AdsGetReportModel {
  int? errorCode;
  String? message;
  Result1? result;

  AdsGetReportModel({this.errorCode, this.message, this.result});

  AdsGetReportModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    result =
        json['result'] != null ? new Result1.fromJson(json['result']) : null;
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

class Result1 {
  int? postType;
  String? fromDate;
  String? toDate;
  int? accessOptions;
  String? festivalName;
  List<OfferImageList>? offerImageList;

  Result1(
      {this.postType,
      this.fromDate,
      this.toDate,
      this.accessOptions,
      this.festivalName,
      this.offerImageList});

  Result1.fromJson(Map<String, dynamic> json) {
    postType = json['postType'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    accessOptions = json['accessOptions'];
    festivalName = json['festivalName'];
    if (json['offerImageList'] != null) {
      offerImageList = <OfferImageList>[];
      json['offerImageList'].forEach((v) {
        offerImageList!.add(new OfferImageList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postType'] = this.postType;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['accessOptions'] = this.accessOptions;
    data['festivalName'] = this.festivalName;
    if (this.offerImageList != null) {
      data['offerImageList'] =
          this.offerImageList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OfferImageList {
  int? offerIndexId;
  String? heading;
  String? description;
  String? offerImage;

  OfferImageList(
      {this.offerIndexId, this.heading, this.description, this.offerImage});

  OfferImageList.fromJson(Map<String, dynamic> json) {
    offerIndexId = json['offerIndexId'];
    heading = json['heading'];
    description = json['description'];
    offerImage = json['offerImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offerIndexId'] = this.offerIndexId;
    data['heading'] = this.heading;
    data['description'] = this.description;
    data['offerImage'] = this.offerImage;
    return data;
  }
}
