import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  const Privacy({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: buildBackButton(context)),
              SizedBox(
                height: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(
                      'assets/logo2.png',
                    ),
                    radius: 120,
                  ),
                  AutoSizeText(
                    'Copying of all pdf kits contained herein is strictly prohibited. If someone else has your username and password, that account will be deactivated. It is strictly forbidden to sell these pdf kits without our permission.',
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.justify,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: AutoSizeText(
                      '© Copyright 2021 SoftPoint - All Rights Reserved',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 90),
                    child: AutoSizeText(
                      'Powered By Widdevd (Pvt) Ltd',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildBackButton(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)));
  }
}
