import 'package:flutter/material.dart';

class MyDialog {
  static dialogWithWiget(context, {required wiget}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(color: Colors.transparent, child: wiget ?? Container());
      },
    );
  }
}

getBottomSheet(context, {body}) {
  showModalBottomSheet(
      // backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      context: context,
      builder: (builder) {
        return body ??
            new Container(
              height: 350.0,
              color:
                  Colors.transparent, //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0))),
                  child: new Center(
                    child: new Text("This is a modal sheet"),
                  )),
            );
      });
}
