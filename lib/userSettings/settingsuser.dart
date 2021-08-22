import 'package:firebase_user_login/screensetprovider/screensetprovider.dart';
import 'package:firebase_user_login/themeprovider/themeprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettings extends StatefulWidget {
  // const UserSettings({Key? key}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {

  //build widget
  @override
  Widget build(BuildContext context) {
    //change theme to provider call
    ThemeModel themeModel = Provider.of<ThemeModel>(context);
    // screen to want the screenset provider call
    final screenexit = Provider.of<ScreenSetProvider>(context);
    return Scaffold(

        appBar: AppBar(
          iconTheme: IconThemeData(
            color: themeModel.getTheme() ==ThemeData.light() ? Colors.black:Colors.white, //change your color here
          ),        backgroundColor: themeModel.getTheme() ==ThemeData.light() ? Colors.white:Colors.black,
          centerTitle: true,
          title: Text("User Setting",
          style: TextStyle(

            color: themeModel.getTheme() ==ThemeData.light() ? Colors.black:Colors.white
          ),),
        ),
        body: ListView(
          children: [

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                Text("Change App Theme   "),
                SizedBox(height: 30,),

                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white)
                  ),
                    onPressed: () =>
                        themeModel.setTheme(ThemeData.light()),
                    child: Text('Light Mode',
                      style: TextStyle(color: Colors.black),
                    )),
                SizedBox(height: 20,),

                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black)
                    ),
                    onPressed: () => themeModel.setTheme(ThemeData.dark()),
                    child: Text('Dark Mode',
                      style: TextStyle(color: Colors.white),))
                ,
              ],
            )
          ],
        ),
      );
  }
}
