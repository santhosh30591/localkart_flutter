class ViewPlanDetailsModel {
  int? errorCode;
  String? message;
  Result? result;

  ViewPlanDetailsModel({this.errorCode, this.message, this.result});

  ViewPlanDetailsModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['errorCode'] = errorCode;
    data['message'] = message;
    if (this.result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  String? planName;
  DirectoryListing? directoryListing;
  WeeklyPost? weeklyPost;
  WeeklyPost? dailyPost;
  WeeklyPost? festivalPost;
  List<Others>? others;

  Result(
      {this.planName,
      this.directoryListing,
      this.weeklyPost,
      this.dailyPost,
      this.festivalPost,
      this.others});

  Result.fromJson(Map<String, dynamic> json) {
    planName = json['planName'];
    directoryListing = json['directoryListing'] != null
        ? DirectoryListing.fromJson(json['directoryListing'])
        : null;
    weeklyPost = json['weeklyPost'] != null
        ? WeeklyPost.fromJson(json['weeklyPost'])
        : null;
    dailyPost = json['dailyPost'] != null
        ? WeeklyPost.fromJson(json['dailyPost'])
        : null;
    festivalPost = json['festivalPost'] != null
        ? WeeklyPost.fromJson(json['festivalPost'])
        : null;
    if (json['others'] != null) {
      others = <Others>[];
      json['others'].forEach((v) {
        others!.add(new Others.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['planName'] = planName;
    if (directoryListing != null) {
      data['directoryListing'] = directoryListing!.toJson();
    }
    if (weeklyPost != null) {
      data['weeklyPost'] = weeklyPost!.toJson();
    }
    if (dailyPost != null) {
      data['dailyPost'] = dailyPost!.toJson();
    }
    if (festivalPost != null) {
      data['festivalPost'] = festivalPost!.toJson();
    }
    if (others != null) {
      data['others'] = others!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DirectoryListing {
  String? benifits;
  String? daysTotal;
  String? daysAvailable;
  String? daysUsed;

  DirectoryListing(
      {this.benifits, this.daysTotal, this.daysAvailable, this.daysUsed});

  DirectoryListing.fromJson(Map<String, dynamic> json) {
    benifits = json['benifits'];
    daysTotal = json['Days Total'].toString();
    daysAvailable = json['Days Available'];
    daysUsed = json['Days Used'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['benifits'] = benifits;
    data['Days Total'] = daysTotal.toString();
    data['Days Available'] = daysAvailable;
    data['Days Used'] = daysUsed.toString();
    return data;
  }
}

class WeeklyPost {
  String? benifits;
  String? postsTotal;
  String? postsAvailable;
  String? postsUsed;
  String? postsExpired;

  WeeklyPost(
      {this.benifits,
      this.postsTotal,
      this.postsAvailable,
      this.postsUsed,
      this.postsExpired});

  WeeklyPost.fromJson(Map<String, dynamic> json) {
    benifits = json['benifits'];
    postsTotal = json['Posts Total'];
    postsAvailable = json['Posts Available'];
    postsUsed = json['Posts Used'];
    postsExpired = json['Posts Expired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['benifits'] = benifits;
    data['Posts Total'] = postsTotal;
    data['Posts Available'] = postsAvailable;
    data['Posts Used'] = postsUsed;
    data['Posts Expired'] = postsExpired;
    return data;
  }
}

class Others {
  String? keyName;
  String? value;

  Others({this.keyName, this.value});

  Others.fromJson(Map<String, dynamic> json) {
    keyName = json['keyName'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['keyName'] = keyName.toString();
    data['value'] = value.toString();
    return data;
  }
}
