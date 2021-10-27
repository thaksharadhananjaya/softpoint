import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:softpoint/properties.dart';
import 'package:softpoint/requestPayment.dart';
import 'Home.dart';
import 'admob.dart';
import 'mysql.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Mysql mysql = new Mysql();
  final storage = new FlutterSecureStorage();
  TextEditingController textEditingControllerUser = new TextEditingController();
  TextEditingController textEditingControllerPass = new TextEditingController();
  AdmobHelper admobHelper = new AdmobHelper();
  Timer timer;
  int n = 0;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(minutes: 2), (timer) {
      if (n != 1 && n != 3 && n != 8) admobHelper.createRewardAd();
      n++;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    admobHelper.getBannerAd().dispose();
    super.dispose();
  }

  Widget picture() {
    return Center(
      child: CircleAvatar(
        radius: 140.0,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/logo2.png"),
      ),
    );
  }

  Widget username() {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: textEditingControllerUser,
            decoration: InputDecoration(
              hintText: "Enter User Name",
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB40284A), width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB40284A), width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            maxLength: 10,
            validator: (text) {
              if (text.isEmpty) return 'Enter your user name';
              return null;
            },
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: textEditingControllerPass,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter Password",
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB40284A), width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB40284A), width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            maxLength: 10,
            validator: (text) {
              if (text.isEmpty) return 'Enter your password';
              return null;
            },
          ),
        )
      ],
    );
  }

  Widget login() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: SizedBox(
          width: 270,
          // ignore: deprecated_member_use
          child: RaisedButton(
            onPressed: () {
              RegExp regex = new RegExp("[']");
              FocusScope.of(context).unfocus();

              if (textEditingControllerUser.text.isEmpty &&
                  textEditingControllerPass.text.isEmpty) {
                final snackBar = SnackBar(
                  content: Text(
                    'Enter your user name & password !',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (textEditingControllerUser.text.isEmpty) {
                final snackBar = SnackBar(
                  content: Text(
                    'Enter your user name !',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (textEditingControllerPass.text.isEmpty) {
                final snackBar = SnackBar(
                  content: Text(
                    'Enter your password !',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (regex.hasMatch(textEditingControllerUser.text)) {
                final snackBar = SnackBar(
                  content: Text(
                    'Invalid user name or password !',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (regex.hasMatch(textEditingControllerPass.text)) {
                final snackBar = SnackBar(
                  content: Text(
                    'Invalid user name or password !',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                logging(textEditingControllerUser.text,
                    textEditingControllerPass.text);
              }
            },
            color: Color(0xFFB40284A),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                "Sign In",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => exitNow(), child: buildBody(context));
  }

  Widget buildBody(context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                picture(),
                username(),
                SizedBox(
                  height: 40,
                ),
                login(),
                SizedBox(
                  height: 10,
                ),
                buildBuynow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildBuynow(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AutoSizeText("Don't have an account"),
        SizedBox(width: 10),
        GestureDetector(
          child: Text(
            'Buy Now',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ReqPayment()));
          },
        ),
      ],
    );
  }

  Future<void> logging(String user, String password) async {
    try {
      await InternetAddress.lookup('google.com');
      buildVerifivation();
      mysql.getConnection().then((conn) async {
        String sql =
            "SELECT * FROM `user` WHERE `number` = '$user' AND `password` = '$password'";

        var result = await conn.query(sql);

        var results = result.toList();

        if (result.isNotEmpty) {
          if (results[0]['accept'] == 1) {
            saveLoging(results[0]['number'].toString(),
                results[0]['password'].toString());
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          } else {
            final snackBar = SnackBar(
              content: Text(
                'Your account is disabled !',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            );
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          final snackBar = SnackBar(
            content: Text(
              'Invalid user name or password !',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          );
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }

        conn.close();
      });
    } catch (e) {}
  }

  Future buildVerifivation() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          new TextEditingController();
          return WillPopScope(
            onWillPop: () async => null,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                "Sign In...",
              ),
              titlePadding: EdgeInsets.only(left: 16, top: 4, bottom: 6),
              content: Container(
                  alignment: Alignment.center,
                  height: 80,
                  width: double.maxFinite,
                  child: CircularProgressIndicator(valueColor:
                          new AlwaysStoppedAnimation<Color>(primeryColor))),
            ),
          );
        });
  }

  exitNow() {
    SystemChannels.platform.invokeListMethod('SystemNavigator.pop');
  }

  void saveLoging(String user, String password) async {
    await storage.write(key: 'user', value: user);
    await storage.write(key: 'pass', value: password);
  }
}
