class GetBusinessDetailsModel {
  int? errorCode;
  String? message;
  Result? result;

  GetBusinessDetailsModel({this.errorCode, this.message, this.result});

  GetBusinessDetailsModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
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

class Result {
  BasicDetails? basicDetails;
  AddressDetails? addressDetails;
  ContactDetails? contactDetails;
  LocationDetails? locationDetails;
  List<Tags>? tags;
  List<ServiceDetails>? serviceDetails;
  List<ImageDetails>? imageDetails;

  Result(
      {this.basicDetails,
      this.addressDetails,
      this.contactDetails,
      this.locationDetails,
      this.tags,
      this.serviceDetails,
      this.imageDetails});

  Result.fromJson(Map<String, dynamic> json) {
    basicDetails = json['basicDetails'] != null
        ? new BasicDetails.fromJson(json['basicDetails'])
        : null;
    addressDetails = json['addressDetails'] != null
        ? new AddressDetails.fromJson(json['addressDetails'])
        : null;
    contactDetails = json['contactDetails'] != null
        ? new ContactDetails.fromJson(json['contactDetails'])
        : null;
    locationDetails = json['locationDetails'] != null
        ? new LocationDetails.fromJson(json['locationDetails'])
        : null;
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(new Tags.fromJson(v));
      });
    }
    if (json['serviceDetails'] != null) {
      serviceDetails = <ServiceDetails>[];
      json['serviceDetails'].forEach((v) {
        serviceDetails!.add(new ServiceDetails.fromJson(v));
      });
    }
    if (json['imageDetails'] != null) {
      imageDetails = <ImageDetails>[];
      json['imageDetails'].forEach((v) {
        imageDetails!.add(new ImageDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.basicDetails != null) {
      data['basicDetails'] = this.basicDetails!.toJson();
    }
    if (this.addressDetails != null) {
      data['addressDetails'] = this.addressDetails!.toJson();
    }
    if (this.contactDetails != null) {
      data['contactDetails'] = this.contactDetails!.toJson();
    }
    if (this.locationDetails != null) {
      data['locationDetails'] = this.locationDetails!.toJson();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    if (this.serviceDetails != null) {
      data['serviceDetails'] =
          this.serviceDetails!.map((v) => v.toJson()).toList();
    }
    if (this.imageDetails != null) {
      data['imageDetails'] = this.imageDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BasicDetails {
  String? businessType;
  int? indexId;
  String? businessName;
  String? category;
  String? categoryId;
  String? subCategoryId;
  String? subCategory;
  String? description;
  String? shopLogo;

  BasicDetails(
      {this.businessType,
      this.indexId,
      this.businessName,
      this.category,
      this.categoryId,
      this.subCategoryId,
      this.subCategory,
      this.description,
      this.shopLogo});

  BasicDetails.fromJson(Map<String, dynamic> json) {
    businessType = json['businessType'];
    indexId = json['indexId'];
    businessName = json['businessName'];
    category = json['category'];
    categoryId = json['categoryId'];
    subCategoryId = json['subCategoryId'];
    subCategory = json['subCategory'];
    description = json['description'];
    shopLogo = json['shopLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessType'] = this.businessType;
    data['indexId'] = this.indexId;
    data['businessName'] = this.businessName;
    data['category'] = this.category;
    data['categoryId'] = this.categoryId;
    data['subCategoryId'] = this.subCategoryId;
    data['subCategory'] = this.subCategory;
    data['description'] = this.description;
    data['shopLogo'] = this.shopLogo;
    return data;
  }
}

class AddressDetails {
  String? doorNo;
  String? locality;
  String? area;
  String? taulk;
  String? landMark;
  String? state;
  String? stateId;
  String? districtId;
  String? district;
  String? pincode;

  AddressDetails(
      {this.doorNo,
      this.locality,
      this.area,
      this.taulk,
      this.landMark,
      this.state,
      this.stateId,
      this.districtId,
      this.district,
      this.pincode});

  AddressDetails.fromJson(Map<String, dynamic> json) {
    doorNo = json['doorNo'];
    locality = json['locality'];
    area = json['area'];
    taulk = json['taulk'];
    landMark = json['landMark'];
    state = json['state'];
    stateId = json['stateId'];
    districtId = json['districtId'];
    district = json['district'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doorNo'] = this.doorNo;
    data['locality'] = this.locality;
    data['area'] = this.area;
    data['taulk'] = this.taulk;
    data['landMark'] = this.landMark;
    data['state'] = this.state;
    data['stateId'] = this.stateId;
    data['districtId'] = this.districtId;
    data['district'] = this.district;
    data['pincode'] = this.pincode;
    return data;
  }
}

class ContactDetails {
  String? phoneNumber;
  String? mobileNumber;
  String? alternateNumber;
  String? watsappNumber;
  String? emailAddress;
  String? website;
  String? facebook;
  String? digitalVcard;
  String? cod;

  ContactDetails(
      {this.phoneNumber,
      this.mobileNumber,
      this.alternateNumber,
      this.watsappNumber,
      this.emailAddress,
      this.website,
      this.facebook,
      this.digitalVcard,
      this.cod});

  ContactDetails.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    mobileNumber = json['mobileNumber'];
    alternateNumber = json['alternateNumber'];
    watsappNumber = json['watsappNumber'];
    emailAddress = json['emailAddress'];
    website = json['website'];
    facebook = json['facebook'];
    digitalVcard = json['digitalVcard'];
    cod = json['cod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['mobileNumber'] = this.mobileNumber;
    data['alternateNumber'] = this.alternateNumber;
    data['watsappNumber'] = this.watsappNumber;
    data['emailAddress'] = this.emailAddress;
    data['website'] = this.website;
    data['facebook'] = this.facebook;
    data['digitalVcard'] = this.digitalVcard;
    data['cod'] = this.cod;
    return data;
  }
}

class LocationDetails {
  String? address;
  String? latitude;
  String? longitude;

  LocationDetails({this.address, this.latitude, this.longitude});

  LocationDetails.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Tags {
  String? tagName;

  Tags({this.tagName});

  Tags.fromJson(Map<String, dynamic> json) {
    tagName = json['tagName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tagName'] = this.tagName;
    return data;
  }
}

class ServiceDetails {
  String? serviceName;

  ServiceDetails({this.serviceName});

  ServiceDetails.fromJson(Map<String, dynamic> json) {
    serviceName = json['serviceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceName'] = this.serviceName;
    return data;
  }
}

class ImageDetails {
  String? imageUrl;
  int? imageIndexId;

  ImageDetails({this.imageUrl, this.imageIndexId});

  ImageDetails.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    imageIndexId = json['imageIndexId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['imageIndexId'] = this.imageIndexId;
    return data;
  }
}
