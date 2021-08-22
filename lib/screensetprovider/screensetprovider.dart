
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenSetProvider extends ChangeNotifier{






// exit from login selection to check
  Future<bool> screenExit(BuildContext context) {
    notifyListeners();
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Confirm Exit?',
            style: new TextStyle(color: Colors.black, fontSize: 20.0)),
        content: new Text(
            'Are you sure you want to exit the app? Tap \'Yes\' to exit \'No\' to cancel.'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              // this line exits the app.
              SystemChannels.platform
                  .invokeMethod('SystemNavigator.pop');
            },
            child:
            new Text('Yes', style: new TextStyle(fontSize: 18.0)),
          ),
          new FlatButton(
            onPressed: () => Navigator.pop(context), // this line dismisses the dialog
            child: new Text('No', style: new TextStyle(fontSize: 18.0)),
          )
        ],
      ),
    ) ??
        false;

  }





}