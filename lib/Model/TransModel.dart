class TransModel {
  String paymentId;
  // String orderId;
  String signature; 
  String userCd;

  TransModel({this.paymentId,this.signature,this.userCd});

  factory TransModel.fromjson(Map<String, dynamic> json) {
    return TransModel(
      paymentId: json['pId'] as String,
      // orderId: json['orderId'] as String,
       signature:json['signature'] as String,
      userCd: json['userCd']as String,
    );
  }

  Map<String, dynamic> toJsonAdd() {
    return {
     "pId":paymentId,
    //  "orderId":orderId,
      "signature":signature,
     "userCd":userCd,
    };
  }

}