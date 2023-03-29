
class RegAddModel {
  String userName;
  String password;
  String sbfName;
  String mobNo;
  String city;
  String stateCd;
  String countryCd;
  String loginCode;
  String bsNo;
  String areaStreet;
  String locality;
  String landmark;
  String addressType;
  String pincode;

  RegAddModel(
      {this.userName,
      this.password,
      this.sbfName,
      this.mobNo,
      this.bsNo,
      this.stateCd,
      this.countryCd,
      this.loginCode,
      this.areaStreet,
      this.addressType,
      this.locality,
      this.landmark,
      this.pincode,
      this.city});

  factory RegAddModel.fromjson(Map<String, dynamic> json) {
    return RegAddModel(
      userName: json['userName'],
      password: json['Password'],
      sbfName: json['sbfName'],
      mobNo: json['mobNo'],
      city: json['city'],
      stateCd: json['State'],
      countryCd: json['countryCd'],
      loginCode: json['loginCode'],
      bsNo: json['bsNo'],
      areaStreet: json['areaStreet'],
      locality: json['locality'],
      landmark: json['landmark'],
      addressType: json['addressType'],
      pincode: json['pinCode'],
    );
  }

  Map<String, dynamic> toJsonAdd() {
    return {
      "userName": userName,
      "Password": password,
      "sbfName": sbfName,
      "mobNo": mobNo,
      "city": city,
      "State": stateCd,
      "countryCd": countryCd,
      "bsNo":bsNo,
      "areaStreet":areaStreet,
      "locality":locality,
      "landmark":landmark,
      "addressType":addressType,
      "pinCode":pincode,
      "loginCode":loginCode,
    };
  }

  Map<String, dynamic> toJsonUpDate() {
    return {
     "userName": userName,
      "Password": password,
      "sbfName": sbfName,
      "mobNo": mobNo,
      "city": city,
      "State": stateCd,
      "countryCd": countryCd,
      "bsNo":bsNo,
      "areaStreet":areaStreet,
      "locality":locality,
      "landmark":landmark,
      "addressType":addressType,
      "pinCode":pincode,
      "loginCode":loginCode,
    };
  }

  Map<String, dynamic> toJsonProUpDate() {
    return {
      "userName": userName,
      "Password": password,
      "sbfName": sbfName,
      "mobNo": mobNo,
      "city": city,
      "State": stateCd,
      "countryCd": countryCd,
      "bsNo":bsNo,
      "areaStreet":areaStreet,
      "locality":locality,
      "landmark":landmark,
      "addressType":addressType,
      "pinCode":pincode,
      "loginCode":loginCode,
    };
  }
}
