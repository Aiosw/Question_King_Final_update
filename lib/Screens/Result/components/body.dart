import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:competitive_exam_app/Model/ExamMdl.dart';
import 'package:competitive_exam_app/Screens/Dashboard/components/backgroundHt.dart';
import 'package:competitive_exam_app/Service/ExamService.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class Body extends StatefulWidget {
  _Body createState() => _Body();
  Body({Key key}) : super(key: key);
}

// List qAData;

retnull() {
  return Container();
}

class _Body extends State<Body> {
  String addmoney, name, contactNo, Email;
  ScreenshotController _screenshotController;

  @override
  void initState() {
    super.initState();
    _screenshotController = ScreenshotController();
  }

  Future<List<ExamModel>> getLedgerData() async {
    String loginCd = Constants.prefs.getString('logId');
    ExamModel ledMdl = ExamModel(userCd: loginCd);
    print(ledMdl.userCd);
    final data = await Examservice().getResult(ledMdl);
    if (data != '"No Record Found"') {
      var decodedPrd = json.decode(data).cast<Map<String, dynamic>>();
      List<ExamModel> ledList = await decodedPrd
          .map<ExamModel>((json) => ExamModel.fromjson(json))
          .toList();
      return ledList;
    } else {
      return null;
    }
  }

  Future<LedgerDataSource> getLedgerDataSource() async {
    var ledgerList = await getLedgerData();
    if (ledgerList != null) {
      return LedgerDataSource(ledgerList);
    }
  }

  List<GridColumn> getcoloumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'Date',
        width: 120,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Center(
            child: Text(
              'Date',
              overflow: TextOverflow.clip,
              softWrap: true,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Session No',
        width: 120,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Center(
            child: Text(
              'Session No',
              overflow: TextOverflow.clip,
              softWrap: true,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Obtain',
        // width: 50,
        label: Container(
          // padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            'Obtain',
            overflow: TextOverflow.clip,
            softWrap: true,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Win(₹)',
        // width: 100,
        label: Container(
          // padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            'Win(₹)',
            overflow: TextOverflow.clip,
            softWrap: true,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: <Widget>[
        SingleChildScrollView(
          child: Background(
            child: Container(
              child: FutureBuilder(
                future: getLedgerDataSource(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  Widget resultWidget =
                      SfDataGrid(source: snapshot.data, columns: getcoloumns());

                  Widget screenShotWidget = Screenshot(
                      child: resultWidget, controller: _screenshotController);

                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.hasData
                        ? resultWidget
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "No Data Found",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 28),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "After giving exam you can view your \nresult here",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 1,
                                      color: Colors.black54),
                                ),
                              ],
                            ),
                          );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 38.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class LedgerDataSource extends DataGridSource {
  LedgerDataSource(this.LedgerLst) {
    buildDataGridRow();
  }
  List<DataGridRow> dataGridRows;
  List<ExamModel> LedgerLst;
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Center(
          child: Text(
            row.getCells()[1].value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Center(
          child: Text(
            row.getCells()[2].value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
      ),
    ]);
  }

  @override
  // TODO: implement rows
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = LedgerLst.map<DataGridRow>((datagridRows) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Date', value: datagridRows.Date),
        DataGridCell<String>(
            columnName: 'Session_No', value: datagridRows.sessionNo),
        DataGridCell<String>(
            columnName: 'ObtainMark', value: datagridRows.obtainMark),
        DataGridCell<String>(columnName: 'win(₹)', value: datagridRows.Rst),
        //  DataGridCell<int>(columnName: 'salary', value: e.salary),
      ]);
    }).toList(growable: false);
  }
}
