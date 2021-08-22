import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_login/screensetprovider/screensetprovider.dart';
import 'package:firebase_user_login/themeprovider/themeprovider.dart';
import 'package:firebase_user_login/userSettings/settingsuser.dart';
import 'package:firebase_user_login/videoplayer/custom_controls_widget.dart';
import 'package:firebase_user_login/videoplayer/video_controls_widget.dart';
import 'package:firebase_user_login/videoplayer/video_progres_indicator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({Key? key}) : super(key: key);


  final dynamic user;
  final List<Duration> timestamps;


  HomeScreen({this.user, @required this.timestamps,});

  FirebaseAuth fire;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, TickerProviderStateMixin {

  //variable declarations....

  VideoPlayerController controller;


//get video durations
String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}

//init method state
@override
void initState() {
  super.initState();
  disableScreenShot();

  controller = VideoPlayerController.asset(
    'assets/video1.mp4',
  );

  //controller listener
  controller.addListener(() {
    setState(() {});
  });
  controller.setLooping(true);
  controller.initialize();
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


//dispose state
@override
void dispose() {
  controller.dispose();
  super.dispose();
}

//initialize to play
Future<void> _initializePlay(String videoPath) async {
  controller = VideoPlayerController.asset(videoPath);
  controller.addListener(() {
    setState(() {
    });
  });
  controller.initialize().then((_) {
    controller.play();
  });
}

//disbale screen shot and  screen record
      Future<void> disableScreenShot() async {
      controller.setVolume(0.0);

    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  }


// clear previous video
Future<bool> _clearPrevious() async {
  await controller?.pause();
  return true;
}


//add to play video
void _getValuesAndPlay(String videoPath) {
  // newCurrentPosition = controller.value.position;
  _startPlay(videoPath);
  // print(newCurrentPosition.toString());
}

//start to play video
Future<void> _startPlay(String videoPath) async {
  setState(() {
    // _initializeVideoPlayerFuture = null;
  });
  Future.delayed(const Duration(milliseconds: 200), () {
    _clearPrevious().then((_) {
      _initializePlay(videoPath);
    });
  });
}


//build widget
@override
Widget build(BuildContext context) {

  //Screen size to set mediaQuery
  var size = MediaQuery
      .of(context)
      .size;
  //global key declaration
  final GlobalKey<ScaffoldState> _scaffoldKey =
  new GlobalKey<ScaffoldState>();

  //provider call

  // screen to want the theme provider call
  ThemeModel themeModel = Provider.of<ThemeModel>(context);

  // screen to want the screenset provider call
  final screenexit = Provider.of<ScreenSetProvider>(context);
  return new WillPopScope(
    onWillPop: () async => screenexit.screenExit(context),
    child: Scaffold(
        key: _scaffoldKey,
        drawer: Container(
          width: MediaQuery
              .of(context)
              .size
              .width *
              0.95, // 75% of screen will be occupied
          color: Colors.black,

          child: AspectRatio(

            aspectRatio: 1 / 2.5,
            child: Drawer(
              child: ListView(
                children: <Widget>[
                  AspectRatio(

              aspectRatio: 1 / 0.6,
                    child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.green[800],
                          boxShadow: [
                            BoxShadow(
                                color: Colors.lightGreenAccent, spreadRadius: 0.5),
                          ],
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(25.0),
                              bottomLeft: Radius.circular(25.0)),
                          gradient: LinearGradient(
                            stops: [0.2, 18.0],
                            tileMode: TileMode.mirror,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Colors.black38,
                              Colors.black12,
                            ],
                          ),
                        ),
                        height: size.height / 3.5,
                        width: size.width / 0.9,

                        // color: Color(0xff2874F0),
                        child: Column(
                          // alignment: Alignment.centerRight,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Wrap(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: CircleAvatar(
                                      backgroundImage:
                                      FileImage(this.widget.user['image']),
                                      radius: 60.0,

                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              children: [
                                Visibility(
                                    visible: this.widget.user['mobile'] != null,
                                    child: Text(
                                      "Logged Mobile Number: ${this.widget
                                          .user['mobile']}",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ))
                                ,

                              ],
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          // color: Colors.red,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                        "User Name : ${this.widget
                                            .user['username']}",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.red),
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                        "Email : ${this.widget.user['email']}",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.red),
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                        "Date Of Birth: ${this.widget
                                            .user['dateofbirth']}",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.red),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserSettings()));
                          });
                        },
                        child: AspectRatio(

                            aspectRatio: 2 / 0.2,
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 20, child: Icon(Icons.settings)),
                              Expanded(flex: 70, child: Text("Settings"))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          Widget noButton = FlatButton(
                            child: Text("No"),
                            onPressed: () {
                              print("No...");
                              Navigator.pop(context);
                            },
                          );

                          Widget yesButton = FlatButton(
                            child: Text("Yes"),
                            onPressed: () {
                              Navigator.pop(context); //okk
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, "/logout");
                            },
                          );
                          showDialog(
                              context: context,
                              builder: (c) =>
                                  AlertDialog(
                                      content: Text(
                                          "Do you really want to logout?"),
                                      actions: [yesButton, noButton]));
                        },
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 20, child: Icon(Icons.logout)),
                            Expanded(flex: 70, child: Text("Logout"))
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: ListView(

            children: [
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: Icon(
                      Icons.menu_outlined,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 70,
                  ),

                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
        body:ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(controller),
                      VideoControlsWidget(controller: controller),
                      CustomVideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        timestamps: widget.timestamps,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                CustomControlsWidget(
                  controller: controller,
                  timestamps: widget.timestamps,
                ),
                SizedBox(height: 40,),

                Container(
                  child: FloatingActionButton(
                    onPressed: () {

                      setState(() {
                        // If the video is playing, pause it.
                        if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          // If the video is paused, play it.
                          controller.play();
                        }
                      });
                    },

                    // Display the correct icon depending on the state of the player.
                    child: Icon(
                      controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                ),
                SizedBox(height: 40,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton.icon(
                      onPressed: () {
                        _getValuesAndPlay("assets/video1.mp4");
                      },
                      icon: Icon(
                        Icons.skip_previous,
                        color:
                        themeModel.getTheme() == ThemeData.light()
                            ? Colors.white
                            : Colors.black,
                      ),
                      label: Text(
                        "Previous",
                        style: TextStyle(
                            color: themeModel.getTheme() ==
                                ThemeData.light()
                                ? Colors.white
                                : Colors.black),
                      ),
                      color: themeModel.getTheme() == ThemeData.light()
                          ? Colors.black
                          : Colors.white,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    FlatButton.icon(
                      onPressed: () {
                        _getValuesAndPlay("assets/video2.mp4");
                      },
                      icon: Icon(
                        Icons.skip_next,
                        color:
                        themeModel.getTheme() == ThemeData.light()
                            ? Colors.white
                            : Colors.black,
                      ),
                      label: Text("Next",
                          style: TextStyle(
                              color: themeModel.getTheme() ==
                                  ThemeData.light()
                                  ? Colors.white
                                  : Colors.black)),
                      color: themeModel.getTheme() == ThemeData.light()
                          ? Colors.black
                          : Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (controller.value.initialized)
                      Container(
                        height: 35,
                        // alignment: Alignment.bottomLeft,
                        // padding: EdgeInsets.all(8),
                        child: Text(
                          'Video Duration : ${_formatDuration(
                              controller.value.position)} / ${_formatDuration(
                              controller.value.duration)}',
                          style: TextStyle(color:themeModel.getTheme() == ThemeData.light()
                              ? Colors.black
                              : Colors.white, fontSize: 16),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ],
        )

    ),
  );


  ;
}






}

