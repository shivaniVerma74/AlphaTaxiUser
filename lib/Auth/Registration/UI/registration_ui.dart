import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cabira/Auth/Login/UI/login_page.dart';
import 'package:cabira/Auth/Verification/UI/verification_page.dart';
import 'package:cabira/utils/ApiBaseHelper.dart';
import 'package:cabira/utils/Session.dart';
import 'package:cabira/utils/colors.dart';
import 'package:cabira/utils/referCodeService.dart';
import 'package:cabira/utils/widget.dart';
import 'package:flutter/material.dart';
import 'package:cabira/Components/custom_button.dart';
import 'package:cabira/Components/entry_field.dart';
import 'package:cabira/Locale/strings_enum.dart';
import 'package:cabira/Locale/locale.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/common.dart';
import '../../../utils/constant.dart';
import 'registration_interactor.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class RegistrationUI extends StatefulWidget {
  final String? phoneNumber;
  String name, email;
  RegistrationUI(this.phoneNumber, this.name, this.email);

  @override
  _RegistrationUIState createState() => _RegistrationUIState();
}

class _RegistrationUIState extends State<RegistrationUI> {
  TextEditingController mobileCon = new TextEditingController();
  TextEditingController referCon = new TextEditingController();
  TextEditingController emailCon = new TextEditingController();
  TextEditingController nameCon = new TextEditingController();
  TextEditingController dobCon = new TextEditingController();
  TextEditingController passCon = new TextEditingController();
  TextEditingController cPassCon = new TextEditingController();
  TextEditingController genderCon = new TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];
  bool obscure = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenDeepLinkData(context);
    mobileCon.text = widget.phoneNumber.toString();
    nameCon.text = widget.name.toString();
    emailCon.text = widget.email.toString();
  }

  void listenDeepLinkData(BuildContext context) async {
    FlutterBranchSdk.initSession().listen((data) {
      //print("data"+data.toString());
      if (data['refer_code'] != null) {
        tempRefer = data['refer_code'];
        setState(() {
          referCon.text = tempRefer.toString();
        });
      }
      //  print("temp = $tempRefer");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      body: FadedSlideAnimation(
        SingleChildScrollView(
          child: Container(
            //   height: MediaQuery.of(context).size.height + MediaQuery.of(context).size.height*0.5,
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
                        getTranslated(context, 'SIGN_UP_NOW')!,
                        style: theme.textTheme.headline4!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text(
                        getTranslated(context, 'ENTER_REQ_INFO')!,
                        style: theme.textTheme.bodyText2!
                            .copyWith(color: theme.hintColor, fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    Container(
                      color: theme.backgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          EntryField(
                            controller: nameCon,
                            keyboardType: TextInputType.name,
                            label: getTranslated(context, 'FULL_NAME'),
                          ),
                          EntryField(
                            controller: mobileCon,
                            maxLength: 10,
                            prefixIcon1: Text(
                              "+91",
                              style: theme.textTheme.titleLarge!
                                  .copyWith(fontSize: 24, color: Colors.black),
                            ),
                            keyboardType: TextInputType.phone,
                            label: getTranslated(context, 'ENTER_PHONE'),
                          ),
                          EntryField(
                            controller: emailCon,
                            keyboardType: TextInputType.emailAddress,
                            label:
                                "${getTranslated(context, 'EMAIL_ADD')} (optional)",
                          ),
                          gender.length > 0
                              ? EntryField(
                                  maxLength: 10,
                                  readOnly: true,
                                  controller: genderCon,
                                  onTap: () {
                                    showBottom1();
                                  },
                                  label: getTranslated(context, "GENDER")!,
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
                          /* EntryField(
                            //  initialValue: name.toString(),
                            controller: passCon,
                            keyboardType: TextInputType.visiblePassword,
                            label: getTranslated(context, "PASSWORD")!,
                            obscureText: obscure,
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: MyColorName.primaryLite,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                            ),
                          ),
                          EntryField(
                            //  initialValue: name.toString(),
                            controller: cPassCon,
                            obscureText: obscure,
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: MyColorName.primaryLite,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            label: "Confirm Password",
                          ),*/
                          // EntryField(
                          //   controller: referCon,
                          //   label: getTranslated(context, "REFER_CODE")!,
                          // ),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                PositionedDirectional(
                  top: 190,
                  start: 24,
                  child: InkWell(
                    onTap: () {
                      requestPermission(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: _image != null
                            ? Image.file(
                                _image!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.fill,
                              )
                            : Icon(Icons.camera_alt, color: Colors.black),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
      bottomNavigationBar: !loading
          ? CustomButton(
              text: getTranslated(context, 'SIGN_UP'),
              onTap: () {
                if (mobileCon.text == "" || mobileCon.text.length != 10) {
                  setSnackbar("Please Enter Valid Mobile Number", context);
                  return;
                }
                if (validateField(nameCon.text, "Please Enter Full Name") !=
                    null) {
                  setSnackbar("Please Enter Full Name", context);
                  return;
                }
                // if(validateEmail(emailCon.text, getTranslated(context, "VALID_EMAIL")!,getTranslated(context, "VALID_EMAIL")!)!=null){
                //   setSnackbar(validateEmail(emailCon.text, getTranslated(context, "VALID_EMAIL")!,getTranslated(context, "VALID_EMAIL")!).toString(), context);
                //   return;
                // }
                if (validateField(genderCon.text, "Please Enter Gender") !=
                    null) {
                  setSnackbar("Please Enter Gender", context);
                  return;
                }
                if (validateField(dobCon.text, "Please Enter Date Of Birth") !=
                    null) {
                  setSnackbar("Please Enter Date Of Birth", context);
                  return;
                }
                /*if (passCon.text == "" || passCon.text.length < 8) {
                  setSnackbar(
                      getTranslated(context, "ENTER_PASSWORD")!, context);
                  return;
                }
                if (passCon.text != cPassCon.text) {
                  setSnackbar("Both Password Doesn't Match", context);
                  return;
                }*/
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
              child: Center(child: CircularProgressIndicator())),
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

  DateTime startDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
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
          Uri.parse(baseUrl + "registration"),
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
        }

        request.headers.addAll(headers);
        request.fields.addAll({
          "gender": genderCon.text,
          "dob": dobCon.text,
          "password": passCon.text != "" ? passCon.text : "12345678",
          "user_fullname": nameCon.text,
          "user_phone": mobileCon.text,
          "user_email": emailCon.text.trim().toString(),
          "firebaseToken": "no data",
        });
        if (referCon.text != "") {
          request.fields.addAll({
            "friends_code": referCon.text,
          });
        }
        print("request: " + request.toString());
        print("PARAMETER: " + request.fields.toString());
        print("IMAGE PARAMETER: " + request.files.toString());
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
            Map info = data['data'];
            //setSnackbar(data['message'].toString(), context);
            navigateScreen(
                context, VerificationPage(info['mobile'], info['otp']));
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

  loginUser() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "mobile_no": mobileCon.text.trim().toString(),
          "fcm_id": fcmToken.toString(),
        };
        Map response =
            await apiBase.postAPICall(Uri.parse(baseUrl + "send_otp"), data);
        print(response);
        bool status = true;
        String msg = response['message'];
        setState(() {
          loading = false;
        });
        setSnackbar(msg, context);
        if (response['status']) {
          // navigateScreen(context, VerificationPage(_numberController.text.trim()));
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, "WRONG")!, context);
        setState(() {
          loading = false;
        });
      }
    } else {
      setSnackbar(getTranslated(context, "NO_INTERNET")!, context);
      setState(() {
        loading = false;
      });
    }
  }
}
