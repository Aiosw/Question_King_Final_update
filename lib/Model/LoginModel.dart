class LoginModel {
  String userName;
  String password;
  String login; 
  String fName;
  String email;
  String logId;

  LoginModel({this.userName, this.password,this.login,this.fName,this.email,this.logId});

  factory LoginModel.fromjson(Map<String, dynamic> json) {
    return LoginModel(
      userName: json['userName'] as String,
      password: json['Password'] as String,
      login:json['login'] as String,
      fName: json['fName'] as String,
      email: json['Email'] as String,
      logId:json['loginId'] as String,
    );
  }

  Map<String, dynamic> toJsonAdd() {
    return {
      "userName": userName,
      "Password": password,
    };
  }

    Map<String, dynamic> toJsonUpdate() {
    return {
      "userName": userName,
      "Password": password,
      "loginId":logId
    };
  }

   Map<String, dynamic> toJsonget() {
    return {
      "userName": userName,
    };
  }

  Map<String, dynamic> toJsonFeth() {
    return {
      "loginId": logId,
    };
  }


}