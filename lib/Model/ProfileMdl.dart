class ProfileModel {
  String f_Name;
  // String age;
//  String genderCd;
  String city;
  String stateCd;
  String stateNm;
  // String genderNm;
  // String education;
  String Email;
  String contactNo;
  String langCd;
  String language;
  String userCd;
  String imgCd;
  String bankNm;
  String acNm;
  String acNo;
  String iffcCd;
  String code;

  ProfileModel(
      {this.f_Name,
      // this.genderCd,
      // this.age,
      this.city,
      this.stateCd,
      this.stateNm,
      this.Email,
      this.contactNo,
      // this.education,
      // this.genderNm,
      this.langCd,
      this.language,
      this.userCd,
      this.imgCd,
      this.acNm,
      this.acNo,
      this.bankNm,
      this.iffcCd,
      this.code});

  factory ProfileModel.fromjson(Map<String, dynamic> json) {
    return ProfileModel(
      f_Name: json['f_Name'] as String,
      // age: json['age'] as String,
      // genderCd: json['genderCd'] as String,
      city: json['city'] as String,
      stateCd: json['stateCd'] as String,
      stateNm: json['stateNm'] as String,
      contactNo: json['mobNo'] as String,
      Email: json['Email'] as String,
      //  education: json['education'] as String,
      langCd: json['langCd'] as String,
      language: json['language'] as String,
      userCd: json['userCd'] as String,
      imgCd: json['imgPath'] as String,
      bankNm: json['bnkNm'] as String,
      acNm: json['acNm'] as String,
      acNo: json['acNo'] as String,
      iffcCd: json['iffcCd'] as String,
      code: json['Code'] as String,
    );
  }

  Map<String, dynamic> toJsonFeth() {
    return {
      "f_Name": f_Name,
      // "age": age,
      // "genderCd": genderCd,
      "city": city,
      "stateCd": stateCd,
      "stateNm": stateNm,
      "Email": Email,
      "mobNo": contactNo,
      "language": language,
      "langCd": langCd,
      //  "education": education,
      "userCd": userCd,
      "imgPath": imgCd,
      "bnkNm": bankNm,
      "acNm": acNm,
      "acNo": acNo,
      "iffcCd": iffcCd,
      "Code": code,
    };
  }

  Map<String, dynamic> toJsonAdd() {
    return {
      "f_Name": f_Name,
      // "age": age,
      // "genderCd": genderCd,
      "city": city,
      "langCd": langCd,
      "Email": Email,
      "mobNo": contactNo,
      // "education": education,
      "stateCd": stateCd,
      "imgPath": imgCd,
      "userCd": userCd,
    };
  }

  Map<String, dynamic> toJsonUpdate() {
    return {
      "f_Name": f_Name,
      // "age": age,
      // "genderCd": genderCd,
      "city": city,
      "langCd": langCd,
      "Email": Email,
      "mobNo": contactNo,
      "stateCd": stateCd,
      "imgPath": imgCd,
      // "education": education,
      "userCd": userCd,
      "Code": code,
    };
  }

  Map<String, dynamic> toJsonBnkUpdate() {
    return {
      "userCd": userCd,
      "bnkNm": bankNm,
      "acNm": acNm,
      "acNo": acNo,
      "iffcCd": iffcCd,
    };
  }

  Map<String, dynamic> toJsonProFeth() {
    return {
      "userCd": userCd,
    };
  }
}
