    class UserModel {
  final String code;
  final String name;

  UserModel({this.code, this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return UserModel(
      code: json["Code"],
      name: json["Name"],
    );
  }

  static List<UserModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel model) {
    return this?.code == model?.code;
  }

  @override
  String toString() => name;

}
