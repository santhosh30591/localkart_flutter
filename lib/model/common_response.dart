class CommonResponse {
  int? errorCode;
  String? message;

  CommonResponse({this.errorCode, this.message});

  CommonResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    return data;
  }
}
