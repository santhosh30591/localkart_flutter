class EventListModel {
  int? errorCode;
  List<Events>? events;

  EventListModel({this.errorCode, this.events});

  EventListModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    if (json['result'] != null) {
      events = <Events>[];
      json['result'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
  }
}

class DashboardModel {
  int? errorCode;
  List<Events>? events;
  List<Billpayment>? billpayment;
  List<Shopping>? shopping;
  List<Shopping>? services;
  List<DashboardSlider>? topSlider;
  List<DashboardSlider>? slider1;
  List<DashboardSlider>? slider2;
  List<DashboardSlider>? slider3;
  String? news;
  Post? post;

  DashboardModel({
    this.errorCode,
    this.events,
    this.billpayment,
    this.shopping,
    this.services,
    this.topSlider,
    this.slider1,
    this.slider2,
    this.slider3,
    this.news,
    this.post,
  });

  DashboardModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
    if (json['billpayment'] != null) {
      billpayment = <Billpayment>[];
      json['billpayment'].forEach((v) {
        billpayment!.add(new Billpayment.fromJson(v));
      });
    }
    if (json['shopping'] != null) {
      shopping = <Shopping>[];
      json['shopping'].forEach((v) {
        shopping!.add(new Shopping.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <Shopping>[];
      json['services'].forEach((v) {
        services!.add(new Shopping.fromJson(v));
      });
    }
    if (json['top_slider'] != null) {
      topSlider = <DashboardSlider>[];
      json['top_slider'].forEach((v) {
        topSlider!.add(new DashboardSlider.fromJson(v));
      });
    }
    if (json['slider1'] != null) {
      slider1 = <DashboardSlider>[];
      json['slider1'].forEach((v) {
        slider1!.add(new DashboardSlider.fromJson(v));
      });
    }
    if (json['slider2'] != null) {
      slider2 = <DashboardSlider>[];
      json['slider2'].forEach((v) {
        slider2!.add(new DashboardSlider.fromJson(v));
      });
    }
    if (json['slider3'] != null) {
      slider3 = <DashboardSlider>[];
      json['slider3'].forEach((v) {
        slider3!.add(new DashboardSlider.fromJson(v));
      });
    }
    news = json['news'];
    post = json['post'] != null ? new Post.fromJson(json['post']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    if (this.billpayment != null) {
      data['billpayment'] = this.billpayment!.map((v) => v.toJson()).toList();
    }
    if (this.shopping != null) {
      data['shopping'] = this.shopping!.map((v) => v.toJson()).toList();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    if (this.topSlider != null) {
      data['top_slider'] = this.topSlider!.map((v) => v.toJson()).toList();
    }
    if (this.slider1 != null) {
      data['slider1'] = this.slider1!.map((v) => v.toJson()).toList();
    }
    if (this.slider2 != null) {
      data['slider2'] = this.slider2!.map((v) => v.toJson()).toList();
    }
    if (this.slider3 != null) {
      data['slider3'] = this.slider3!.map((v) => v.toJson()).toList();
    }
    data['news'] = this.news;
    if (this.post != null) {
      data['post'] = this.post!.toJson();
    }
    return data;
  }
}

class Events {
  int? id;
  int? eventId;
  String? eventname;
  String? date;
  String? time1;
  String? time2;
  String? address;
  String? district;
  String? image;
  int? bookingAllow;
  String? closedMessage;

  Events({
    this.id,
    this.eventId,
    this.eventname,
    this.date,
    this.time1,
    this.time2,
    this.address,
    this.district,
    this.image,
    this.bookingAllow,
    this.closedMessage,
  });

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['eventId'];
    eventname = json['eventname'];
    date = json['date'];
    time1 = json['time1'];
    time2 = json['time2'];
    address = json['address'];
    district = json['district'];
    image = json['image'];
    bookingAllow = json['booking_allow'];
    closedMessage = json['closed_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eventId'] = this.eventId;
    data['eventname'] = this.eventname;
    data['date'] = this.date;
    data['time1'] = this.time1;
    data['time2'] = this.time2;
    data['address'] = this.address;
    data['district'] = this.district;
    data['image'] = this.image;
    data['booking_allow'] = this.bookingAllow;
    data['closed_message'] = this.closedMessage;
    return data;
  }
}

class Billpayment {
  String? showType;
  String? name;
  int? id;
  String? icons;
  String? topColor;
  String? bottomColor;

  Billpayment({
    this.showType,
    this.name,
    this.id,
    this.icons,
    this.topColor,
    this.bottomColor,
  });

  Billpayment.fromJson(Map<String, dynamic> json) {
    showType = json['show_type'];
    name = json['name'];
    id = json['id'];
    icons = json['icons'];
    topColor = json['top_color'];
    bottomColor = json['bottom_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['show_type'] = this.showType;
    data['name'] = this.name;
    data['id'] = this.id;
    data['icons'] = this.icons;
    data['top_color'] = this.topColor;
    data['bottom_color'] = this.bottomColor;
    return data;
  }
}

class Shopping {
  String? showType;
  String? name;
  String? id;
  String? icons;
  String? topColor;
  String? bottomColor;

  Shopping({
    this.showType,
    this.name,
    this.id,
    this.icons,
    this.topColor,
    this.bottomColor,
  });

  Shopping.fromJson(Map<String, dynamic> json) {
    showType = json['show_type'];
    name = json['name'];
    id = json['id'];
    icons = json['icons'];
    topColor = json['top_color'];
    bottomColor = json['bottom_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['show_type'] = this.showType;
    data['name'] = this.name;
    data['id'] = this.id;
    data['icons'] = this.icons;
    data['top_color'] = this.topColor;
    data['bottom_color'] = this.bottomColor;
    return data;
  }
}

class DashboardSlider {
  String? image;
  String? actionType;
  String? dataLink;

  DashboardSlider({this.image, this.actionType, this.dataLink});

  DashboardSlider.fromJson(Map<String, dynamic> json) {
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

class Post {
  String? title;
  String? content;
  String? image;

  Post({this.title, this.content, this.image});

  Post.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['image'] = this.image;
    return data;
  }
}
