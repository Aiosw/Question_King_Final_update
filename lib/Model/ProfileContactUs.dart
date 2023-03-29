class ProfileCountactUs {
  String code;
  String userCd;
  String mobNo;
  String countryMobCd;
  String email;
  String website;
  String vcPath;
  String telNo;

  ProfileCountactUs(
      {this.code,
      this.userCd,
      this.mobNo,
      this.countryMobCd,
      this.email,
      this.website,
      this.vcPath,
      this.telNo});

  factory ProfileCountactUs.fromjson(Map<String, dynamic> json) {
    return ProfileCountactUs(
      mobNo: json['mobNo'] as String,
      countryMobCd: json['countryMobCd'] as String,
      email: json['email'] as String,
      website: json['website'] as String,
      vcPath: json['vcPath'] as String,
      userCd: json['userCd'] as String,
      telNo: json['telNo'] as String,
      code: json['Code'] as String,
    );
  }

  Map<String, dynamic> toJsonFeth() {
    return {
      "mobNo": mobNo,
      "countryMobCd": countryMobCd,
      "email": email,
      "website": website,
      "vcPath": vcPath,
      "userCd": userCd,
      "telNo": telNo,
    };
  }

  Map<String, dynamic> toJsonProFeth() {
    return {
      "userCd": userCd,
    };
  }
}
