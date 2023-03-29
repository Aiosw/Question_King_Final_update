class LedgerModel {
  String vchDate;
  String Desc;
  String vchType;
  String userCd;
  String Amt;
  String val;

  LedgerModel({this.vchDate, this.vchType,this.Desc, this.userCd, this.Amt,this.val});

  factory LedgerModel.fromjson(Map<String, dynamic> json) {
    return LedgerModel(
      vchDate: json['vchDate'] as String,
      Desc: json['Cm1']as String,
      vchType: json['vchType'] as String,
      Amt: json['d1'] as String,
      userCd: json['userCd'] as String,
      val: json['value']as String,
    );
  }

  Map<String, dynamic> toJsonAdd() {
    return {
      "vchDate": vchDate,
      "Cm1":Desc,
      "vchType": vchType,
      "userCd":userCd,
      "d1": Amt,
      "value":val,
    };
  }

    Map<String, dynamic> togetUserCd() {
    return {
      "userCd":userCd,
    };
  }
}
