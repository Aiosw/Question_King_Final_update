import 'dart:io';
import 'package:competitive_exam_app/Model/LedgerModel.dart';
import 'package:competitive_exam_app/Model/ProfileMdl.dart';
import 'package:competitive_exam_app/Screens/Dashboard/components/backgroundHt.dart';
import 'package:competitive_exam_app/Screens/Profile/User_Model.dart';
import 'package:competitive_exam_app/Service/ProfileAddService.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:competitive_exam_app/components/Apiloader.dart';
import 'package:competitive_exam_app/components/loader.dart';
import 'package:competitive_exam_app/components/rounded_button.dart';
import 'package:competitive_exam_app/components/rounded_input_field.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Body extends StatefulWidget {
  _Body createState() => _Body();
  Body({Key key}) : super(key: key);
}

retnull() {
  return Container();
}

class _Body extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  String stateNm,
      rectype = "0",
      stateCd,
      FName,
      fileName,
      language,
      languageCd,
      setStatus,
      userCd,
      cities,
      request,
      imageNm,
      email,
      mobNo,
      profileCode;
  String bal;
  List<LedgerModel> LedgerLst;

  final ImagePicker _picker = ImagePicker();
  File _image;

  TextEditingController flNm = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController MobNo = TextEditingController();
  bool value = false;
  List<ProfileModel> profLst;
  bool isloading = true;

  Future<List<UserModel>> getStateData(filter) async {
    var response = await Dio().post(
      "https://3.6.153.237/Comp_Api/getState.php",
      queryParameters: {"filter": filter},
    );
    var data = response.data;
    if (data != null) {
      return UserModel.fromJsonList(data);
    }
    return [];
  }

  Future<List<ProfileModel>> getOldProfileData() async {
    userCd = Constants.prefs.getString('logId');
    print("USERCD  ------------ $userCd");
    ProfileModel prof = ProfileModel(userCd: userCd);
    print("prof   --------- " + prof.toString());
    if (userCd != null && userCd != '') {
      profLst = await Profileservice().proGet(prof);
      setState(() {
        isloading = false;
      });
      print("$profLst.length");
      if (profLst != null) {
        ProfileModel profMdl = profLst[0];

        setState(() {
          rectype = "1";
          flNm.text = profMdl.f_Name;
          languageCd = profMdl.langCd;
          stateCd = profMdl.stateCd;
          stateNm = profMdl.stateNm;
          Email.text = profMdl.Email;
          MobNo.text = profMdl.contactNo;
          city.text = profMdl.city;
          imageNm = profMdl.imgCd == "" ? 'default.png' : profMdl.imgCd;
          profileCode = profMdl.code;
          if (languageCd == "0") {
            language = "Hindi";
          } else if (languageCd == "1") {
            language = "English";
          } else if (languageCd == "2") {
            language = "Gujarati";
          }
        });
      }
    } else {
      isloading = false;
    }

    return [];
  }

  add(ProfileModel profileMdl, BuildContext context) async {
    isloading = true;
    startupload();

    await Profileservice().proAdd(profileMdl).then((sucess) {
      request = "Add Sucessfully";
    });
    Navigator.pushReplacementNamed(context, '/wallet');
  }

  startupload() async {
    fileName = basename(_image.path);
    print("File Name:$fileName");
    try {
      FormData formData = new FormData.fromMap({
        "name": fileName,
        "userCd": Constants.prefs.getString('logId'),
        "image": await MultipartFile.fromFile(_image.path, filename: fileName),
      });

      Response response = await Dio()
          .post("https://3.6.153.237/Comp_Api/uploadImg.php", data: formData);
      print("File upload Response:$response");
      if (response.statusCode == 200) {
        toastPass("Image Uploaded Successfully...");
        setStatus = "1";
      }
    } catch (e) {
      toastFaill("Image Not Upload..");
      print("Exception caught:$e");
    }
  }

  chooseImage(BuildContext context) async {
    Navigator.pop(context);
    if (rectype == "1") {
      deleteFile();
      imageNm = "";
    }
    var pickImage = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      pickImage != null
          ? _image = File(pickImage.path)
          : toastFaill("No Image Selected");
    });
  }

  Future<http.Response> deleteFile() async {
    ProfileModel prof = ProfileModel(userCd: userCd);
    var st = await Profileservice().proPicDelete(prof);
    if (st == "success") {
      final http.Response response = await http.delete(
        Uri.parse('https://3.6.153.237/Comp_Api/uploads/$imageNm'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }

  toastPass(String messge) {
    Fluttertoast.showToast(
        msg: messge,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  toastFaill(String messge) {
    Fluttertoast.showToast(
        msg: messge,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  update(ProfileModel profileMdl, BuildContext context) async {
    isloading = true;
    startupload();
    await Profileservice().proUpdate(profileMdl).then((sucess) {
      request = "update Sucessfully";
      //  setState(() {
      isloading = false;
      Navigator.pop(context);
      toastPass("Profile updated successfully");
    });
  }

  Widget showImage() {
    return Container(
        height: 100,
        width: 400,
        child: _image == null
            ? imageNm == null
                ? Center(
                    child: Text("No Image selected",
                        style: TextStyle(
                          color: Colors.white,
                        )))
                : CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://3.6.153.237/Comp_Api/uploads/$imageNm",
                    ),
                  )

            // Image.network("https://3.6.153.237/Comp_Api/uploads/$imageNm")
            : CircleAvatar(
                backgroundImage: FileImage(
                  _image,
                ),
                radius: 220,
              )
        // Image.file(_image),
        );
  }

  @override
  void initState() {
    super.initState();
    getOldProfileData();
    //isloading = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Form(
            key: _formKey,
            child: isloading
                ? loaders().apiLoader
                : SingleChildScrollView(
                    child: Background(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: size.height * 0.001),
                              showImage(),
                              RoundedButton(
                                press: () {
                                  showLoaderDialog(context);
                                  chooseImage(context);
                                },
                                text: 'Choose Image',
                              ),

                              RoundedInputField(
                                controllers: flNm,
                                maxleng: 30,
                                hintText: "Enter Full Name",
                                icon: Icons.person,
                                onChanged: (value) {
                                  FName = value;
                                },
                                validator: (String value) {
                                  return value.isEmpty
                                      ? 'Enter Your Full Name'
                                      : null;
                                },
                              ),
                              RoundedInputField(
                                controllers: Email,
                                maxleng: 35,
                                hintText: "Email",
                                icon: Icons.email,
                                onChanged: (value) {
                                  email = value;
                                },
                                validator: (String value) {
                                  return value.isEmpty
                                      ? 'Enter Your Email'
                                      : null;
                                },
                              ),
                              RoundedInputField(
                                controllers: MobNo,
                                maxleng: 10,
                                hintText: "ContactNo",
                                icon: Icons.mobile_screen_share,
                                onChanged: (value) {
                                  mobNo = value;
                                },
                                validator: (String value) {
                                  return value.isEmpty
                                      ? 'Enter Your Contact No'
                                      : null;
                                },
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: kPrimaryLightColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: DropdownSearch(
                                  items: ["Hindi", "English", "Gujarati"],
                                  selectedItem: language,
                                  popupProps: PopupProps.menu(),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      hintText: "Select Language",
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kPrimaryLightColor),
                                          borderRadius:
                                              BorderRadius.circular(29)),
                                    ),
                                  ),
                                  onChanged: (data) {
                                    print(data);
                                    setState(() {
                                      if (data == "Hindi") {
                                        languageCd = "0";
                                      } else if (data == "English") {
                                        languageCd = "1";
                                      } else if (data == "Gujarati") {
                                        languageCd = "2";
                                      }
                                    });
                                  },
                                  validator: (item) {
                                    if (languageCd == null)
                                      return "Required field";
                                    else
                                      return null;
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: kPrimaryLightColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: DropdownSearch<UserModel>(
                                  popupProps:
                                      PopupProps.menu(showSearchBox: true),
                                  selectedItem: (stateNm == null ||
                                          stateCd == null)
                                      ? null
                                      : UserModel(name: stateNm, code: stateCd),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      hintText: "Select State",
                                      counterStyle: TextStyle(
                                        height: double.minPositive,
                                      ),
                                      counter: Offstage(),
                                      filled: true,
                                      fillColor: kPrimaryLightColor,
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kPrimaryLightColor),
                                          borderRadius:
                                              BorderRadius.circular(29)),
                                    ),
                                  ),

                                  asyncItems: (String filter) =>
                                      getStateData(filter),
                                  itemAsString: (UserModel u) =>
                                      u.userAsString(),
                                  //selectedItem: stateCd,

                                  onChanged: (data) {
                                    print(data);
                                    setState(() {
                                      stateCd = data.code.toString();
                                      stateNm = data.name.toString();
                                    });
                                  },
                                  validator: (item) {
                                    if (stateCd == null)
                                      return "Required field";
                                    else
                                      return null;
                                  },

                                  // showClearButton: true,
                                ),
                              ),
                              RoundedInputField(
                                controllers: city,
                                hintText: "City",
                                maxleng: 20,
                                icon: Icons.location_city,
                                onChanged: (value) {
                                  cities = value;
                                },
                                validator: (String value) {
                                  return value.isEmpty ? 'Enter City' : null;
                                },
                              ),

                              Row(
                                children: [
                                  Checkbox(
                                    value: this.value,
                                    onChanged: (bool value) {
                                      setState(() {
                                        this.value = value;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      'By Ticking,you are confirming that you have read,understood and agree to Question king tearms and condition',
                                      style: TextStyle(
                                          fontSize: 10.0, color: Colors.white),
                                    ),
                                  ), //Text
                                ],
                              ),

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              //Che
                              // SizedBox(height: size.height * 0.001),
                              RoundedButton(
                                  text: "Submit",
                                  press: () {
                                    if (_formKey.currentState.validate()) {
                                      Constants.prefs
                                          .setString('FName', flNm.text);
                                      Constants.prefs
                                          .setString('ContactNo', MobNo.text);
                                      Constants.prefs
                                          .setString('Email', Email.text);
                                      Constants.prefs
                                          .setString("langCd", languageCd);
                                      Constants.prefs.setString(
                                          "profileImg",
                                          imageNm == null
                                              ? basename(_image.path)
                                              : imageNm == ""
                                                  ? basename(_image.path)
                                                  : imageNm);
                                      imageNm = imageNm == null
                                          ? basename(_image.path)
                                          : imageNm == ""
                                              ? basename(_image.path)
                                              : imageNm;
                                      if (imageNm != null) {
                                        ProfileModel pfm = new ProfileModel(
                                          userCd: Constants.prefs
                                              .getString('logId'),
                                          f_Name: flNm.text,
                                          //  genderCd: GendCd,
                                          //  age: age.text,
                                          langCd: languageCd,
                                          //  education: QualCd,
                                          Email: Email.text,
                                          contactNo: MobNo.text,
                                          city: city.text,
                                          stateCd: stateCd,
                                          imgCd: imageNm,
                                          code: profileCode,
                                        );
                                        if (profileCode == null) {
                                          showLoaderDialog(context);
                                          if (!value) {
                                            return toastFaill(
                                                'You need to accept terms');
                                          } else {
                                            add(pfm, context);
                                          }
                                        } else {
                                          if (!value) {
                                            return toastFaill(
                                                'You need to accept terms');
                                          } else {
                                            showLoaderDialog(context);
                                            update(pfm, context);
                                          }
                                        }
                                      } else {
                                        toastFaill("Please Upload Image");
                                      }
                                    }
                                  }),
                            ]),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
