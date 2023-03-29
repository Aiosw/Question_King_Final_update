class DashboardModel {
   var category;

  DashboardModel({this.category});

  factory DashboardModel.fromjson(Map<String, dynamic> json) {
    return DashboardModel(
      category: json['category'] as List,
    );
  }


  Map<String, dynamic> toJsonFeth() {
    return {
      "category": category,
    };
  }


}