class ViewStatusdetailsModel {
  int? errorCode;
  String? message;
  Result? result;

  bool? rewards;

  ViewStatusdetailsModel({
    this.errorCode,
    this.message,
    this.result,
    this.rewards,
  });

  ViewStatusdetailsModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    rewards = json['rewards'];
    result = json['result'] != null
        ? new Result.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    data['rewards'] = this.rewards;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? icon;
  String? operator;
  String? status;
  String? category;
  String? invoiceNo;
  Reward? reward;
  List<StatusInfo>? info;

  Result({
    this.icon,
    this.operator,
    this.status,
    this.category,
    this.invoiceNo,
    this.reward,
    this.info,
  });

  Result.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    operator = json['operator'];
    status = json['status'];
    category = json['category'];
    invoiceNo = json['invoice_no'];
    reward = json['reward'] != null
        ? new Reward.fromJson(json['reward'])
        : null;
    if (json['info'] != null) {
      info = <StatusInfo>[];
      json['info'].forEach((v) {
        info!.add(new StatusInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['operator'] = this.operator;
    data['status'] = this.status;
    data['category'] = this.category;
    data['invoice_no'] = this.invoiceNo;
    if (this.reward != null) {
      data['reward'] = this.reward!.toJson();
    }
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reward {
  int? errorCode;
  String? message;

  RewardDetails? result;

  Reward({this.errorCode, this.message, this.result});

  Reward.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['Message'];

    result = json['result'] != null
        ? new RewardDetails.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['Message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }

    return data;
  }
}

class RewardDetails {
  int? id;
  String? reward_type;
  String? reward_title;
  String? reward_validity;
  String? logo;

  RewardDetails({
    this.id,
    this.reward_type,
    this.reward_title,
    this.reward_validity,
    this.logo,
  });

  RewardDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reward_type = json['reward_type'];
    reward_title = json['reward_title'];
    reward_validity = json['reward_validity'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reward_type'] = this.reward_type;
    data['reward_title'] = this.reward_title;
    data['reward_validity'] = this.reward_validity;
    data['logo'] = this.logo;
    return data;
  }
}

class StatusInfo {
  String? key;
  String? value;

  StatusInfo({this.key, this.value});

  StatusInfo.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}
