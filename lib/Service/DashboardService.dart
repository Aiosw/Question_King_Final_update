import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:competitive_exam_app/Model/DashboardModel.dart';

class DashBoardservice {
  var url = Uri.parse("https://3.6.153.237/getCategory.php");

  List<DashboardModel> logFromComJson(String jsonstring) {
    final data = json.decode(jsonstring);
    return List<DashboardModel>.from(
        data.map((item) => DashboardModel.fromjson(item)));
  }

  Future getCategory() async {
    var response =
        await http.get(url, headers: {"Accept": "Application/json"});

    print("res" + response.body);
    var jsonbody = response.body;
    var jsondata = json.decode(jsonbody);
    // List<DashboardModel> list=logFromComJson(response.body);
    //   LoginModel().res=list;
    // loginModel.result=response.body;
    return jsondata;
  }
}
