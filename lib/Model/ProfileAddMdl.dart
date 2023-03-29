class ProfileAddMdl {
  String pinCode;
  String locality;
  String shopNo;
  String stretNm;
  String landmark;
  String city;
  String state;
  String countryCd;
  String countryNm;
  String proAddCd;
  String userCd;

  ProfileAddMdl(
      {this.pinCode,
      this.locality,
      this.shopNo,
      this.stretNm,
      this.landmark,
      this.city,
      this.state,
      this.countryCd,
      this.proAddCd,
      this.countryNm,
      this.userCd});

  factory ProfileAddMdl.fromjson(Map<String, dynamic> json) {
    return ProfileAddMdl(
      pinCode: json['pinCode'] as String,
      locality: json['locality'] as String,
      shopNo: json['bspNo'] as String,
      stretNm: json['areaStreetNm'] as String,
      landmark: json['landmark'] as String,
      city: json['City'] as String,
      state: json['state'] as String,
      countryCd: json['countryCode'] as String,
      countryNm: json['countryNm'] as String,
      proAddCd: json['Code'] as String,
      userCd: json['userCd'] as String,
    );
  }

  Map<String, dynamic> toJsonAdd() {
    return {
      "pinCode": pinCode,
      "locality": locality,
      "bspNo": shopNo,
      "areaStreetNm": stretNm,
      "landmark": landmark,
      "city": city,
      "state": state,
      "countryCd": countryCd,
      "userCd": userCd,
    };
  }

   Map<String, dynamic> toJsonUpdate() {
    return {
      "pinCode": pinCode,
      "locality": locality,
      "bspNo": shopNo,
      "areaStreetNm": stretNm,
      "landmark": landmark,
      "city": city,
      "state": state,
      "countryCd": countryCd,
      "userCd": userCd,
      "Code":proAddCd,
    };
  }

  Map<String, dynamic> toJsonProAddFeth() {
    return {
      "userCd":userCd,
    };
  }
}
