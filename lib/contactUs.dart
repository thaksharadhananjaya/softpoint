import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [buildBackButton(context), buildBody(context)],
          ),
        ),
      ),
    );
  }

  Container buildBackButton(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)));
  }

  Container buildBody(context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: 700,
      padding: height > 1184
          ? EdgeInsets.symmetric(vertical: 20, horizontal: 40)
          : EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(
                'assets/widdev_logo.png',
              ),
              radius: 100,
            ),
            SizedBox(
              height: 8,
            ),
            AutoSizeText(
              'Widdev (PVT) LTD',
              style: TextStyle(
                  color: Color(0xff6e6262),
                  fontWeight: FontWeight.w700,
                  fontSize: 28),
            ),
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, bottom: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.phone,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                      onTap: () async {
                        await launch('+94715316516',
                            forceSafariVC: false, forceWebView: false);
                      },
                      child: AutoSizeText(
                        '+94715316516',
                        style: TextStyle(fontSize: 17),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, bottom: 10),
              child: Row(
                children: [
                  Icon(Icons.mail),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                      onTap: () async {
                        await launch('widdevmail@gmail.com',
                            forceSafariVC: false, forceWebView: false);
                      },
                      child: AutoSizeText(
                        'info@widdev.com',
                        style: TextStyle(fontSize: 17),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, bottom: 10),
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.globe),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                      onTap: () async {
                        await launch('https://www.widdev.com',
                            forceSafariVC: false, forceWebView: false);
                      },
                      child: AutoSizeText(
                        'www.widdev.com',
                        style: TextStyle(
                            fontSize: 17, decoration: TextDecoration.underline),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, bottom: 10),
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.facebook),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                      onTap: () async {
                        await launch('https://www.facebook.com/widdev',
                            forceSafariVC: false, forceWebView: false);
                      },
                      child: AutoSizeText(
                        'www.facebook.com/widdev',
                        style: TextStyle(
                            fontSize: 17, decoration: TextDecoration.underline),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
