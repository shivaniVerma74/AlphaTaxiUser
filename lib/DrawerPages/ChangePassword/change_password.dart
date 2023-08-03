import 'dart:convert';

import 'package:cabira/Components/custom_button.dart';
import 'package:cabira/Locale/locale.dart';
import 'package:cabira/Model/Change_Password_Model.dart';
import 'package:cabira/utils/colors.dart';
import 'package:cabira/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../BookRide/search_location_page.dart';
import '../../Components/entry_field.dart';
import '../../Locale/strings_enum.dart';
import '../../Theme/style.dart';
import '../../utils/Session.dart';
import '../../utils/common.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldPassC = TextEditingController();
  final newPassC = TextEditingController();
  final confirmPassC = TextEditingController();
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(getTranslated(context, "CHANG_PASSWORD")!),
      ),
      body: Container(
        color: theme.backgroundColor,
        child: Column(
          children: [
            SizedBox(height: 10),
            EntryField(
              label: getTranslated(context,'OLD_PASS')!,
              controller: oldPassC,
              obscureText: obscure,
              suffixIcon: IconButton(
                icon: Icon(obscure?Icons.visibility:Icons.visibility_off,color: MyColorName.primaryLite,),
                onPressed: (){
                  setState(() {
                    obscure=!obscure;
                  });
                },
              ),
              keyboardType: TextInputType.visiblePassword,
            ),
            EntryField(
              label: getTranslated(context,'NEW_PASS')!,
              controller: newPassC,
              obscureText: obscure,
              suffixIcon: IconButton(
                icon: Icon(obscure?Icons.visibility:Icons.visibility_off,color: MyColorName.primaryLite,),
                onPressed: (){
                  setState(() {
                    obscure=!obscure;
                  });
                },
              ),
              keyboardType: TextInputType.visiblePassword,
            ),
            EntryField(
              label: getTranslated(context,'CONFIRM_PASS')!,
              controller: confirmPassC,
              obscureText: obscure,
              suffixIcon: IconButton(
                icon: Icon(obscure?Icons.visibility:Icons.visibility_off,color: MyColorName.primaryLite,),
                onPressed: (){
                  setState(() {
                    obscure=!obscure;
                  });
                },
              ),
              keyboardType: TextInputType.visiblePassword,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomButton(
        text: getTranslated(context,'CHANGE_PASSWORD')!,
        onTap: (){
          if(oldPassC.text==""||oldPassC.text.length<8){
            setSnackbar("Enter Old Password", context);
            return ;
          }
          if(newPassC.text==""||newPassC.text.length<8){
            setSnackbar(getTranslated(context, "ENTER_PASSWORD")!, context);
            return ;
          }
          if(confirmPassC.text != newPassC.text){
            setSnackbar("Confirm Password Doesn't match", context);
            return ;
          }
          changePassword();
        },
      ),
    );
  }

  Future changePassword() async {
    Map<String, String> headers = {
      "token": App.localStorage.getString("token").toString(),
      "Content-type": "multipart/form-data"
    };
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl1 + 'Authentication/changePassword'));
    request.fields.addAll({
      'user_id': curUserId.toString(),
      'old_password': '${oldPassC.text}',
      'new_password': '${newPassC.text}'
    });
    print(request);
    print(request.fields);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      print(str);
      var data = ChangePasswordModel.fromJson(json.decode(str));
      if(data.status == true){
        setSnackbar(data.message.toString(), context,);
        Navigator.pop(context);
      } else {
        setSnackbar(data.message.toString(), context);
      }
    }
    else {
      return null;
    }
  }
}
