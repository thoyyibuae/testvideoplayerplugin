import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeModel with ChangeNotifier {
  //provider variable declarations
  ThemeData _themeData;
  ThemeModel(this._themeData);


  //get the mode from provider
   getTheme() => this._themeData;

  //provider to set the mode
  setTheme(ThemeData theme){
     notifyListeners();
     return _themeData = theme;
   }




}