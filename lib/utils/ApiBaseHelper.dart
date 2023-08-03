import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

import 'Session.dart';
import 'constant.dart';
String token="""eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2NDQzMjQ4NzQsImlzcyI6ImVLYXJ0IiwiZXhwIjoxNjQ0MzI2Njc0LCJzdWIiOiJlS2FydCBBdXRoZW50aWNhdGlvbiJ9.nTlLPjNNJIQJaoCw8CSJKbC51AM-Qgm2mnlZAy1Dozc""";
class ApiBaseHelper {
  Future<dynamic> postAPICall(Uri url, var param) async {
    var responseJson;
    try {
      print(
          "API : $url \n parameter : $param   \n ");
      final response = await post(url,
          body: param,headers: {
            'Accept': 'application/json',})
          .timeout(Duration(seconds: timeOut));
      print(
          "API : $url \n parameter : $param   \n response:  ${response.body.toString()}yuj ");
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('getTranslated(context, "NO_INTERNET")!');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
    return responseJson;
  }
  Future<dynamic> getAPICall(Uri url,) async {
    var responseJson;
    try {
      print(
          "API : $url \n    ");
      final response = await get(url,
        headers: {
            'Accept': 'application/json',})
          .timeout(Duration(seconds: timeOut));
      print(
          "API : $url    \n response:  ${response.body.toString()}yuj ");
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('getTranslated(context, "NO_INTERNET")!');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
    return responseJson;
  }
  dynamic _response(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 401:
      case 403:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 500:
      default:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
    }
  }
}

class CustomException implements Exception {
  final _message;
  final _prefix;
  CustomException([this._message, this._prefix]);
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}
