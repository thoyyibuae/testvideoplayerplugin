import 'package:firebase_user_login/screen_phone/mobileLogin.dart';
import 'package:firebase_user_login/screensetprovider/screensetprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class LoginSelection extends StatefulWidget {
  // const LoginSelection({Key? key}) : super(key: key);

  @override
  _LoginSelectionState createState() => _LoginSelectionState();
}

class _LoginSelectionState extends State<LoginSelection> {





  //build method
  @override
  Widget build(BuildContext context) {

    // screen to want the screenset provider call
    final screenexit = Provider.of<ScreenSetProvider>(context);
    return new WillPopScope(
      onWillPop: () async => screenexit.screenExit(context),
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
