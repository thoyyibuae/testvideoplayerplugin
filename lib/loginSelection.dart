import 'package:firebase_user_login/screen_phone/mobileLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class LoginSelection extends StatefulWidget {
  // const LoginSelection({Key? key}) : super(key: key);

  @override
  _LoginSelectionState createState() => _LoginSelectionState();
}

class _LoginSelectionState extends State<LoginSelection> {


 // exit from login selection to check
  Future<bool> _onWillPop() {
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


  //build method
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => _onWillPop(),
      child:  Scaffold(
        appBar: null,
        body: ListView(
          children: [

            SizedBox(height: 160,),
                  Image.network(
                        'https://img2.pngio.com/firebase-brand-guidelines-firebase-png-248_404.png',
                        height: 170.0,

                      ),
            SizedBox(height: 110,),

            GestureDetector(
              onTap: (){
                setState(() {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => LoginScreenPhone()
                  ));
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:13.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  // alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 25.0,
                        child: Icon(Icons.phone,
                        color: Colors.white,),
                      ),
                      Expanded(
                        child: Center(
                          child: Text("Phone Login",

                            style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w900,

                              fontSize: 18,
                            ),),
                        ),
                      )


                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
