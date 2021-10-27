import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child:Stack(
      children: [
        Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/logo2.png"),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            )
          ],
        )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () async {
                await launch('https://www.widdev.com',
                    forceSafariVC: false, forceWebView: false);
              },
              child: Text(
                'Powered By Widdev',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.green,
                    fontWeight: FontWeight.w700),
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