class EventDetailsTicketCountModel {
  int? errorCode;
  String? message;
  bool? iscoupon;
  TicketCountResult? result;

  EventDetailsTicketCountModel({
    this.errorCode,
    this.message,
    this.iscoupon,
    this.result,
  });

  EventDetailsTicketCountModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    iscoupon = json['iscoupon'];
    result = json['result'] != null
        ? new TicketCountResult.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    data['iscoupon'] = this.iscoupon;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class TicketCountResult {
  int? id;
  String? eventname;
  String? date;
  String? startTime;
  String? endTime;
  String? address;
  List<Ticket>? ticket;
  String? district;
  String? stateName;
  String? pincode;
  String? contactMobile;
  String? contactAltMobile;
  String? contactWhatsapp;
  String? contactEmail;
  String? image;
  String? instructionTitle;

  dynamic? instructions;

  TicketCountResult({
    this.id,
    this.eventname,
    this.date,
    this.startTime,
    this.endTime,
    this.address,
    this.ticket,
    this.district,
    this.stateName,
    this.pincode,
    this.contactMobile,
    this.contactAltMobile,
    this.contactWhatsapp,
    this.contactEmail,
    this.image,
    this.instructionTitle,
    this.instructions,
  });

  TicketCountResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventname = json['eventname'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    address = json['address'];
    if (json['ticket'] != null) {
      ticket = <Ticket>[];
      json['ticket'].forEach((v) {
        ticket!.add(new Ticket.fromJson(v));
      });
    }
    district = json['district'];
    stateName = json['state_name'];
    pincode = json['pincode'];
    contactMobile = json['contact_mobile'];
    contactAltMobile = json['contact_alt_mobile'];
    contactWhatsapp = json['contact_whatsapp'];
    contactEmail = json['contact_email'];
    image = json['image'];
    instructionTitle = json['instruction_title'];
    instructions = json['instructions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eventname'] = this.eventname;
    data['date'] = this.date;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['address'] = this.address;
    if (this.ticket != null) {
      data['ticket'] = this.ticket!.map((v) => v.toJson()).toList();
    }
    data['district'] = this.district;
    data['state_name'] = this.stateName;
    data['pincode'] = this.pincode;
    data['contact_mobile'] = this.contactMobile;
    data['contact_alt_mobile'] = this.contactAltMobile;
    data['contact_whatsapp'] = this.contactWhatsapp;
    data['contact_email'] = this.contactEmail;
    data['image'] = this.image;
    data['instruction_title'] = this.instructionTitle;
    data['instructions'] = this.instructions;
    return data;
  }
}

class Ticket {
  String? name;
  String? admitPerson;

  int? price;
  int? order;
  int? ticketcount;
  int? remaining = 0;
  String? availableTickets;
  int? iscombo;
  String? comboNotes;
  int? comboPrice;
  int ticktes = 0;

  // String? comboCount;
  dynamic comboCount;
  String? comboErrorMsg;
  String? comboSuccessMsg;

  Ticket({
    this.name,
    this.admitPerson,

    this.price,
    this.order,
    this.ticketcount,
    this.remaining,
    this.availableTickets,
    this.iscombo,
    this.comboNotes,
    this.comboPrice,
    this.comboCount,
    this.comboErrorMsg,
    this.comboSuccessMsg,
  });

  Ticket.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    admitPerson = json['admit_person'];

    price = json['price'];
    order = json['order'];
    ticketcount = json['ticketcount'];
    remaining = json['remaining'];
    availableTickets = json['available_tickets'];
    iscombo = json['iscombo'];
    comboNotes = json['combo_notes'];
    comboPrice = json['combo_price'];
    comboCount = json['combo_count'];
    comboErrorMsg = json['combo_error_msg'];
    comboSuccessMsg = json['combo_success_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;

    data['price'] = this.price;
    data['order'] = this.order;
    data['ticketcount'] = this.ticketcount;
    data['remaining'] = this.remaining;
    data['available_tickets'] = this.availableTickets;
    data['iscombo'] = this.iscombo;
    data['combo_notes'] = this.comboNotes;
    data['combo_price'] = this.comboPrice;
    data['combo_count'] = this.comboCount;
    data['combo_error_msg'] = this.comboErrorMsg;
    data['combo_success_msg'] = this.comboSuccessMsg;
    return data;
  }
}
