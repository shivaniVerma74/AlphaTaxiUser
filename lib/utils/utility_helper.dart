import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class UtilityHelper {
  // get Flutter toast MSG
  static getToast(msg) {
    Fluttertoast.showToast(
      msg: msg.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }

// get Date Picker
  static getDatePicker(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(3101));
    return picked.toString();
  }

  // get Time Picker
  static getTimePicker(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dial,
        confirmText: "CONFIRM",
        cancelText: "NOT NOW",
        helpText: "BOOKING TIME");

    var data = timeOfDay!.format(context);
    print(data);

    // Conversion logic starts here
    DateTime tempDate = DateFormat("hh:mm")
        .parse(timeOfDay.hour.toString() + ":" + timeOfDay.minute.toString());
    var dateFormat = DateFormat("h:mm a"); // you can change the format here
    print("dsfasdfasa");
    print(dateFormat);
    print(tempDate);
    print("============");
    print(UtilityHelper.convertData(tempDate));
    return UtilityHelper.convertData(tempDate).split(",")[1];
  }

  // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
  static String convertData(getFormat) {
    try {
      var dateTime = DateTime.parse(getFormat.toString());
      // var now = DateTime.now();
      // var dateTime = DateTime.parse(getFormat.toString());
      var mydatetime =
          "${DateFormat.d().format(dateTime)} ${DateFormat.LLL().format(dateTime)} ${DateFormat.y().format(dateTime)}, ${DateFormat.jm().format(dateTime)}";
      return mydatetime;
    } catch (e) {
      return "N/A";
    }
  }
}
