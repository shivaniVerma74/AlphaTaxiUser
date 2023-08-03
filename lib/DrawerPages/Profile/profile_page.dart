import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cabira/BookRide/search_location_page.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/colors.dart';
import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:cabira/utils/widget.dart';
import 'package:flutter/material.dart';
import 'package:cabira/Assets/assets.dart';
import 'package:cabira/Components/custom_button.dart';
import 'package:cabira/Components/entry_field.dart';
import 'package:cabira/Locale/locale.dart';
import 'package:cabira/Locale/strings_enum.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController mobileCon = new TextEditingController();
  TextEditingController genderCon = new TextEditingController();
  TextEditingController emailCon = new TextEditingController();
  TextEditingController nameCon = new TextEditingController();
  TextEditingController dobCon = new TextEditingController();
  TextEditingController passCon = new TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobileCon.text = mobile;
    emailCon.text = email;
    nameCon.text = name;
    dobCon.text = dob;
    passCon.text = password;
    genderCon.text = gender1;
  }

  DateTime startDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2023));
    if (picked != null) {
      setState(() {
        startDate = picked;
        dobCon.text = DateFormat("yyyy-MM-dd").format(startDate);
      });
    }
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? persistentBottomSheetController1;
  showBottom1() async {
    persistentBottomSheetController1 =
        await scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
        decoration:
            boxDecoration(radius: 0, showShadow: true, color: Colors.white),
        padding: EdgeInsets.all(getWidth(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            boxHeight(20),
            text(getTranslated(context, "SELECT_GENDER")!,
                textColor: MyColorName.colorTextPrimary,
                fontSize: 12.sp,
                fontFamily: fontBold),
            boxHeight(20),
            Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: gender.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        persistentBottomSheetController1!.setState!(() {
                          genderCon.text = gender[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: genderCon.text == gender[index]
                            ? MyColorName.primaryLite.withOpacity(0.2)
                            : Colors.white,
                        padding: EdgeInsets.all(getWidth(10)),
                        child: text(gender[index].toString(),
                            textColor: MyColorName.colorTextPrimary,
                            fontSize: 10.sp,
                            fontFamily: fontMedium),
                      ),
                    );
                  }),
            ),
            boxHeight(40),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      body: FadedSlideAnimation(
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height + 210,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppBar(),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            getTranslated(context, 'MY_PROFILE')!,
                            style: theme.textTheme.headline4!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: Text(
                            getTranslated(context, 'YOUR_ACCOUNT_DETAILS')!,
                            style: theme.textTheme.bodyText2!
                                .copyWith(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Expanded(
                          child: Container(
                            height: 500,
                            color: theme.backgroundColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Spacer(),
                                EntryField(
                                  label: getTranslated(context, 'ENTER_PHONE'),
                                  // initialValue: mobile.toString(),
                                  controller: mobileCon,
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                ),
                                EntryField(
                                  //  initialValue: name.toString(),
                                  controller: nameCon,
                                  keyboardType: TextInputType.name,
                                  label: getTranslated(context, 'FULL_NAME'),
                                ),
                                EntryField(
                                  //initialValue: email.toString(),
                                  controller: emailCon,
                                  label: getTranslated(context, 'EMAIL_ADD'),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                gender.length > 0
                                    ? EntryField(
                                        maxLength: 10,
                                        readOnly: true,
                                        controller: genderCon,
                                        onTap: () {
                                          showBottom1();
                                        },
                                        label:
                                            getTranslated(context, "GENDER")!,
                                      )
                                    : SizedBox(),
                                EntryField(
                                  label: getTranslated(context, "DOB")!,
                                  controller: dobCon,
                                  readOnly: true,
                                  onTap: () {
                                    selectDate(context);
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                /*  EntryField(
                                  //  initialValue: name.toString(),
                                  controller: passCon,
                                  keyboardType: TextInputType.visiblePassword,
                                  label: "Password",
                                  obscureText: true,
                                ),*/
                                Spacer(flex: 3),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    PositionedDirectional(
                      top: 200,
                      start: 24,
                      child: InkWell(
                        onTap: () {
                          requestPermission(context);
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: theme.hintColor,
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _image == null
                                ? Image.network(
                                    image,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.fill,
                                  )
                                : Image.file(
                                    _image!,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              start: 0,
              end: 0,
              child: !loading
                  ? CustomButton(
                      text: getTranslated(context, 'UPDATE'),
                      onTap: () {
                        if (mobileCon.text == "" ||
                            mobileCon.text.length != 10) {
                          setSnackbar(
                              "Please Enter Valid Mobile Number", context);
                          return;
                        }
                        if (validateField(
                                nameCon.text, "Please Enter Full Name") !=
                            null) {
                          setSnackbar("Please Enter Full Name", context);
                          return;
                        }
                        if (validateEmail(
                                emailCon.text,
                                getTranslated(context, "VALID_EMAIL")!,
                                getTranslated(context, "VALID_EMAIL")!) !=
                            null) {
                          setSnackbar(
                              validateEmail(
                                      emailCon.text,
                                      getTranslated(context, "VALID_EMAIL")!,
                                      getTranslated(context, "VALID_EMAIL")!)
                                  .toString(),
                              context);
                          return;
                        }
                        if (validateField(
                                genderCon.text, "Please Enter Gender") !=
                            null) {
                          setSnackbar("Please Enter Gender", context);
                          return;
                        }
                        if (validateField(
                                dobCon.text, "Please Enter Date Of Birth") !=
                            null) {
                          setSnackbar("Please Enter Date Of Birth", context);
                          return;
                        }
                        if (passCon.text == "" || passCon.text.length < 8) {
                          setSnackbar(getTranslated(context, "ENTER_PASSWORD")!,
                              context);
                          return;
                        }
                        /*if (_image == null) {
                          setSnackbar("Please Upload Photo", context);
                          return;
                        }*/
                        setState(() {
                          loading = true;
                        });
                        submitSubscription();
                      },
                    )
                  : Container(
                      width: 50,
                      height: 50,
                      child: Center(child: CircularProgressIndicator()),
                    ),
            ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  void requestPermission(BuildContext context) async {
    if (await Permission.camera.isPermanentlyDenied ||
        await Permission.storage.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      openAppSettings();
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.storage,
      ].request();
// You can request multiple permissions at once.

      if (statuses[Permission.camera] == PermissionStatus.granted &&
          statuses[Permission.storage] == PermissionStatus.granted) {
        getImage(ImgSource.Gallery, context);
      } else {
        if (await Permission.camera.isDenied ||
            await Permission.storage.isDenied) {
          // The user opted to never again see the permission request dialog for this
          // app. The only way to change the permission's status now is to let the
          // user manually enable it in the system settings.
          openAppSettings();
        } else {
          setSnackbar("Oops you just denied the permission", context);
        }
      }
    }
  }

  File? _image;
  Future getImage(ImgSource source, BuildContext context) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    setState(() {
      _image = File(image.path);
      getCropImage(context);
    });
  }

  void getCropImage(BuildContext context) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.lightBlueAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      _image = croppedFile;
    });
  }

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool loading = false;
  Future<void> submitSubscription() async {
    await App.init();

    ///MultiPart request
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(baseUrl1 + "Authentication/update_userprofile"),
        );
        Map<String, String> headers = {
          "token": App.localStorage.getString("token").toString(),
          "Content-type": "multipart/form-data"
        };
        if (_image != null) {
          request.files.add(
            http.MultipartFile(
              'user_image',
              _image!.readAsBytes().asStream(),
              _image!.lengthSync(),
              filename: path.basename(_image!.path),
              contentType: MediaType('image', 'jpeg,png'),
            ),
          );
          print("ok");
        }
        request.headers.addAll(headers);
        request.fields.addAll({
          "gender": genderCon.text,
          "dob": dobCon.text,
          "password": passCon.text,
          "user_id": curUserId.toString(),
          "user_fullname": nameCon.text,
          "user_phone": mobileCon.text,
          "user_email": emailCon.text.trim().toString(),
        });
        print("request: " + request.toString());
        var res = await request.send();
        print("This is response:" + res.toString());
        setState(() {
          loading = false;
        });
        print(res.statusCode);
        if (res.statusCode == 200) {
          final respStr = await res.stream.bytesToString();
          print(respStr.toString());
          Map data = jsonDecode(respStr.toString());
          if (data['status']) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SearchLocationPage()),
                (route) => false);
            setSnackbar(data['message'].toString(), context);
          } else {
            setSnackbar(data['message'].toString(), context);
          }
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, "WRONG")!, context);
        setState(() {
          loading = true;
        });
      }
    } else {
      setSnackbar(getTranslated(context, "NO_INTERNET")!, context);
      setState(() {
        loading = true;
      });
    }
  }

  getProfile() async {
    try {
      Map params = {
        "user_id": curUserId.toString(),
      };
      Map response =
          await apiBase.postAPICall(Uri.parse(baseUrl + "get_profile"), params);

      if (response['status']) {
        var data = response["data"];
        print(data);
        setState(() {
          name = data['username'];
          mobile = data['mobile'];
          email = data['email'];
          gender1 = data['gender'];
          image =
              response['image_path'].toString() + data['user_image'].toString();
          imagePath = response['image_path'].toString();
          //isFirstUser = response['first_order'];
        });
      } else {
        setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, "WRONG")!, context);
    }
  }
}
