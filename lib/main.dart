
import 'package:firebase_user_login/themeprovider/themeprovider.dart';
import 'package:firebase_user_login/user_screen/userdetailscreen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'loginSelection.dart';

void main()=> runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {


    //Provider to set the main.dart
    return ChangeNotifierProvider<ThemeModel>(


        create: (_) => ThemeModel(ThemeData.dark()),
      // builder: (_)=>ThemeModel(ThemeData.dark()),

    child: AppWithTheme()
    );
  }
}



class AppWithTheme extends StatelessWidget {
  // const AppWithTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    return MaterialApp(
      theme: theme.getTheme(),
      routes: {
        "/logout": (_) => new LoginSelection(),
      },
      debugShowCheckedModeBanner: false,
      home: LoginSelection(),


    );
  }
}
