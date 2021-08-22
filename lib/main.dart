
import 'package:firebase_user_login/screensetprovider/screensetprovider.dart';
import 'package:firebase_user_login/themeprovider/themeprovider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:firebase_user_login/loginselection/loginSelection.dart';

void main()=> runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {


    //Provider to set the main.dart
    return MultiProvider( providers: [
      ChangeNotifierProvider<ScreenSetProvider>(
        create: (_) => ScreenSetProvider(),
      ),//using screen exit
      ChangeNotifierProvider<ThemeModel >(
        create: (_) => ThemeModel(ThemeData.dark()),),//using theme change
    ],
      child: AppWithTheme(),
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
