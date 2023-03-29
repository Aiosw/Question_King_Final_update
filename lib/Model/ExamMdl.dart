class ExamModel {
  String Code;
  String sessionNo;
  String Date;
  String Que;
  String o1;
  String o2;
  String o3;
  String o4;
  String Ans;
  String obtainMark;
  String AnsFl;
  String NotAttend;
  String langCd;
  String userCd;
  String Rst;
  String AnsNum;

  ExamModel({
    this.Code,
    this.sessionNo,
    this.Date,
    this.Que,
    this.o1,
    this.o2,
    this.o3,
    this.o4,
    this.Ans,
    this.obtainMark,
    this.AnsFl,
    this.langCd,
    this.NotAttend,
    this.userCd,
    this.Rst,
    this.AnsNum
  });

  factory ExamModel.fromjson(Map<String, dynamic> json) {
    return ExamModel(
      Code: json['Code'] as String,
      sessionNo: json['sesNo'] as String,
      Date: json['Date'] as String,
      Que: json['Que'] as String,
      o1: json['o1'] as String,
      o2: json['o2'] as String,
      o3: json['o3'] as String,
      o4: json['o4'] as String,
      Ans: json['Ans'] as String,
      AnsNum: json['AnsNum'] as String,
      obtainMark: json['obtainMark'] as String,
      AnsFl: json['AnsFl'] as String,
      langCd: json['langCd'] as String,
      userCd: json['userCd'] as String,
      NotAttend: json['NotAttend'] as String,
      Rst: json['Rst'] as String,
    );
  }

  Map<String, dynamic> toJsonAdd() {
    return {
      "sesNo": sessionNo,
      "Date": Date,
      "obtainMark": obtainMark,
      "AnsFl": AnsFl,
      "userCd": userCd,
      "NotAttend": NotAttend,
    };
  }

  Map<String, dynamic> toJsonUpDate() {
    return {
      "Code": Code,
      "sesNo": sessionNo,
      "Date": Date,
      "Que": Que,
      "o1": o1,
      "o2": o2,
      "o3": o3,
      "o4": o4,
      "Ans": Ans,
    };
  }

  Map<String, dynamic> toGet() {
    return {
      "sesNo": sessionNo,
      "Date": Date,
      "langCd": langCd,
    };
  }

  Map<String, dynamic> toSet() {
    return {
      "sesNo": sessionNo,
      "Date": Date,
    };
  }

  Map<String, dynamic> toJsonFeth() {
    return {
      "userCd": userCd,
    };
  }

  Map<String, dynamic> togetParti() {
    return {
      "sesNo": sessionNo,
      "Date": Date,
    };
  }
}
