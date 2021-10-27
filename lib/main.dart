
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:softpoint/Home.dart';
import 'package:softpoint/admob.dart';

import 'splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdmobHelper.initialize();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SoftPoint',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return HomePage();
          }
            return Splash();
      
        }),
    );
  }


}

