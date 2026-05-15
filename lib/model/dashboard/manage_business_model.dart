class ManageBusinessModel {
  int? errorCode;
  String? message;
  List<Results>? results = <Results>[];

  ManageBusinessModel({this.errorCode, this.message, this.results});

  ManageBusinessModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? name;
  String? mobile;
  String? district;
  String? date;
  String? time;

  Results({this.name, this.mobile, this.district, this.date, this.time});

  Results.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    district = json['district'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['district'] = this.district;
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}

class BusinessLeadsModel {
  int? errorCode;
  String? message;
  List<LeadsResults>? results;

  BusinessLeadsModel({this.errorCode, this.message, this.results});

  BusinessLeadsModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['results'] != null) {
      results = <LeadsResults>[];
      json['results'].forEach((v) {
        results!.add(new LeadsResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeadsResults {
  String? name;
  String? mobile;
  String? district;
  int? leads;
  String? date;
  String? time;

  LeadsResults({
    this.name,
    this.mobile,
    this.district,
    this.leads,
    this.date,
    this.time,
  });

  LeadsResults.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    district = json['district'];
    leads = json['leads'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['district'] = this.district;
    data['leads'] = this.leads;
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}
