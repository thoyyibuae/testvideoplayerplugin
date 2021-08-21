import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_login/app_home/home.dart';
import 'package:firebase_user_login/themeprovider/themeprovider.dart';
import 'package:firebase_user_login/user_screen/userdetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';


class LoginScreenPhone extends StatefulWidget {
  // const LoginScreenPhone({Key? key}) : super(key: key);

  @override
  _LoginScreenPhoneState createState() => _LoginScreenPhoneState();
}

class _LoginScreenPhoneState extends State<LoginScreenPhone> {
  //controller variable declarations
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final SmsAutoFill _autoFill = SmsAutoFill();
  bool verifactionFailed = false;

  bool isInit = true;
  String otp;
  bool resendOtp = false;

  //auto fill
  void _listenOTP() async {
    await SmsAutoFill().listenForCode;
  }

 //exit app
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


  //customized widget
  Widget container(){

    return Container(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: PinFieldAutoFill(
        autofocus: true,
        keyboardType: TextInputType.number,
        codeLength: 6,
        onCodeChanged: (value) {
          if (value.length == 6) {
            print(' onCodeChanged');
            otp = value;
          }
        },

      ),
    ),
  );
}

  //login with phone otp
  Future<bool> loginUser(String phone, BuildContext context) async{
    FirebaseAuth _auth = FirebaseAuth.instance;

    //typing to pass mobile number
    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async{
        Navigator.of(context).pop();

        AuthResult result = await _auth.signInWithCredential(credential);

        FirebaseUser user = result.user;

        if(user != null){

          Navigator.push(context, MaterialPageRoute(
              builder: (context) => HomeScreen(user: user,)
          ));
        }else{
          print("Error");
        }

        //This callback would gets called when verification is done auto matically
      },

      verificationFailed:
          (AuthException exception){
        print('new......${exception.message}');
        print(exception.code);
        return showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text("Error occured"),
              content: new Text("Error : ${exception.message} !"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));

      },
      codeSent: (String verificationId, [int forceResendingToken]){
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Give The Sms Otp Code?"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _codeController,
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Confirm"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () async{
                      final code = _codeController.text.trim();
                      //login with verification code from sms
                      try{
                        AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);
                        AuthResult result = await _auth.signInWithCredential(credential);


                        FirebaseUser user = result.user;
                        if(user != null){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => UserDetails(mobile: user.phoneNumber,)
                          ));
                        }else{
                          print("Error..................................sms code .....");
                        }
                      }
                      catch(e){
                        print("Error..................................sms code ..... ${e.toString()}");

                      }








                    },
                  ),

                ],
              );
            }
        );
      },
      codeAutoRetrievalTimeout: null,


    );
  }

  //dispose state
@override
  void dispose() {
    // TODO: implement dispose
  SmsAutoFill().unregisterListener();

  super.dispose();
  }

  //init state

  @override
  void initState() {
    // TODO: implement initState
  setState(() {
    _listenOTP();
  });
    super.initState();
  }

  //build method called
  @override
  Widget build(BuildContext context) {
    ThemeModel themeModel = Provider.of<ThemeModel>(context);

    return WillPopScope(

          onWillPop: () async => _onWillPop(),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            // primary: false,
            centerTitle: true,
            title: Text('Phone Login',
              style: TextStyle(
                  color: Colors.black
              ),),),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(32),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    SizedBox(height: 26,),

                    TextFormField(
                      style: TextStyle(color: Colors.black),

                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey[200])
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey[300])
                          ),
                          filled: true,
                          labelStyle: TextStyle(color: Colors.black),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.grey[100],
                          hintText: "Mobile Number eg:+91XXXXXXXXXX"

                      ),
                      controller: _phoneController,
                    ),

                    SizedBox(height: 16,),


                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        child: Text("Send Code"),
                        textColor: Colors.white,
                        padding: EdgeInsets.all(16),
                        onPressed: () {
                          final phone = _phoneController.text.trim();
                          print(phone);
                          loginUser(phone, context);

                        },
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}




