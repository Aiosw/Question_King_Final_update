class ProductMdl {
  String code;
  String userCd;
  String productNm;
  String Rate;
  String size;
  String colour;
  String ProdNo;

  ProductMdl(
      {this.code,
      this.userCd,
      this.ProdNo,
      this.productNm,
      this.Rate,
      this.size,
      this.colour});

  factory ProductMdl.fromjson(Map<String, dynamic> json) {
    return ProductMdl(
      ProdNo: json['prdNo'] as String,
      productNm: json['productNm'] as String,
      Rate: json['Rate'] as String,
      size: json['size'] as String,
      colour: json['colour'] as String,
      userCd: json['userCd'] as String,
      code: json['Code'] as String,
    );
  }

  Map<String, dynamic> toJsonAdd() {
    return {
      "ProdId": ProdNo,
      "productNm": productNm,
      "Rate": Rate,
      "size": size,
      "colour": colour,
      "userCd": userCd,
    };
  }

  Map<String, dynamic> toJsonGetMaxFeth() {
    return {
      "userCd": userCd,
    };
  }
}
