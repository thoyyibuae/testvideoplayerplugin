import 'dart:io';

import 'package:firebase_user_login/app_home/home.dart';
import 'package:firebase_user_login/themeprovider/themeprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class UserDetails extends StatefulWidget {
  // const UserDetails({Key? key}) : super(key: key);
   dynamic mobile;
   UserDetails({this.mobile});
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  //variable declarations
  final _formKey = GlobalKey<FormState>();
  PickedFile pic;

  final picker = ImagePicker();
  File _image;

  TextEditingController dateCtl = TextEditingController();

  final _username = TextEditingController();
  final _email = TextEditingController();

  /// Get from gallery
  _getFromGallery() async {
    pic = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pic != null) {
      setState(() {
        print("Hello: " + pic.path.toString());

        _image = File(pic.path);
      });
    }
    Navigator.pop(context);
  }

  /// Get from Camera
  _getFromCamera() async {
    pic = null;
    pic = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pic != null) {
      setState(() {
        print("Hello: " + pic.path);

        _image = File(pic.path);
      });
    }
    Navigator.pop(context);
  }

  //add image
  addImage() async {
    pic = null;

    setState(() {
      // validationRcvAmt();
    });

    Widget cameraButton = FloatingActionButton(
      backgroundColor: Colors.lightBlueAccent,
      child: Container(
        color: Colors.red,
        child: Row(
          children: [
            Expanded(child: Icon(Icons.camera_alt)),
            Expanded(
              child: Text("Camera"),
            ),
          ],
        ),
      ),
      onPressed: () {
        setState(() {
          print("camera...");
          _getFromCamera();
          Navigator.pop(context);
        });

//        alert.hide();
      },
    );
    Widget galleryButton = FloatingActionButton(
      backgroundColor: Colors.lightBlueAccent,
      child: Row(
        children: [
          Expanded(child: Text("Gallery")),
          Expanded(
            child: Icon(
              Icons.camera,
            ),
          )
        ],
      ),
      onPressed: () {
        setState(() {
          print("No image...");
          _getFromGallery();
          Navigator.pop(context);
        });

//        alert.hide();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Center(
          child: Column(

        children: [
          Text("Select Image"),
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Container(
                  // margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                  child: RaisedButton(
                onPressed: () => _getFromCamera(),
                child: Text(' From Camera'),
                textColor: Colors.white,
                color: Colors.green,
                padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              )),
              SizedBox(
                width: 30,
              ),
              Container(
                  // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: RaisedButton(
                onPressed: () => _getFromGallery(),
                child: Text('From Gallery'),
                textColor: Colors.white,
                color: Colors.green,
                padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              ))

            ],
          )
        ],
      )),

    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return;
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

//validate email
  String validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid email address';
    else
      return null;
  }


  //build widget
  @override
  Widget build(BuildContext context) {
    ThemeModel themeModel = Provider.of<ThemeModel>(context);

    return WillPopScope(
      onWillPop: () async => _onWillPop(),
      child: Scaffold(
        appBar: null,
        body: ListView(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _image != null
                          ? GestureDetector(
                        onTap: () {
                          setState(() {
                            addImage();
                          });
                        },
                            child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: FileImage(_image),
                                    radius: 60.0,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            // color:Colors.white,
                                              child: Icon(Icons.camera_alt,
                                          color: Colors.black,
                                              size: 25,)),
                                        )
                                      ],
                                    ),
                                  ),


                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Change User Image",
                                    style: TextStyle(color:themeModel.getTheme() == ThemeData.light()
                                        ? Colors.black
                                        : Colors.white),
                                  ),
                                ],
                              ),
                          )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  addImage();
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Text(
                                    "Add User Image",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 26,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.black),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter UserName';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey[200])),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey[300])),
                            filled: true,
                            fillColor: Colors.grey[100],
                            labelStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                            hintText: "UserName"),
                        controller: _username,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) => validateEmail(value),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey[200])),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Colors.grey[300])),
                            filled: true,
                            labelStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),

                            fillColor: Colors.grey[100],
                            hintText: "Email"),
                        controller: _email,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: 15),
                        showCursor: true,
                        controller: dateCtl,
                        enabled: true,
                        validator: (v) => (v.isEmpty || dateCtl.text == '')
                            ? 'Please enter valid date'
                            : null,

                        cursorColor: Colors.black,

                        scrollPadding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                        keyboardType: TextInputType.datetime,
                        readOnly: true,

                        onTap: () async {
                          final DateTime now = DateTime.now();
                          DateTime date = await showDatePicker(
                              context: context,
                              initialDatePickerMode: DatePickerMode.day,
                              initialDate: DateTime(1900),
                              firstDate: DateTime(1900),
                              lastDate: now,
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.light(),
                                  child: child,
                                );
                              });

                          if (date != null) {
                            print(date);
                            // if (date.day < DateTime.now().day ) {
                            //   // print("invalid date select");
                            //   //
                            dateCtl.text = "";
                            //   // return;
                            // } else {

                            var d = DateFormat("d-MM-yyyy").format(date);
                            dateCtl.text = d;
                            print(dateCtl.text);
                            // }
                          }
                        },
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.red),
                          errorText:
                              dateCtl.text == null ? "invalid date " : null,
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                            size: 24,
                          ),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0)),
                          // curve brackets object
                          hintText: "Date of Birth:dd/mm/yy",
                          hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                          labelText: "Date Birth",
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        child: FlatButton(
                          child: Text("Submit"),
                          textColor: Colors.white,
                          padding: EdgeInsets.all(16),
                          onPressed: () {
                            final isValid = _formKey.currentState.validate();
                            if (!isValid || pic==null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Data is Invalid ')),
                              );
                              return;
                            }

                            final username = _username.text.trim();
                            final email =_email.text.trim();
                            final date= dateCtl.text.trim();
                            var user={
                              "username": username,
                              "email": email,
                              "dateofbirth": date.toString(),
                              "image": _image,
                              "mobile":this.widget.mobile

                            };


                            print(user);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                HomeScreen(user:user ,
                                  timestamps: <Duration>[
                                    Duration(minutes: 0, seconds: 14),
                                    Duration(minutes: 0, seconds: 48),
                                    Duration(minutes: 1, seconds: 18),
                                    Duration(minutes: 1, seconds: 47),
                                  ],)));
                          },
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
