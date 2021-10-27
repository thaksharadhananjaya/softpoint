import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class About extends StatelessWidget {
  const About({Key key}) : super(key: key);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(
                    'assets/logo2.png',
                  ),
                  radius: 120,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 110),
                  child: Text('v 1.0.2'),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            AutoSizeText(
              '   We created this app especially for you who are looking for technical knowledge. Here we have created this app so that not only you who read books but also those who write books can easily sell your book. Here we have designed these book sets so that you can easily understand, with the emerging technologies for those who are looking for technical knowledge. This will allow you to improve not only your technical knowledge but also your creativity.',
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 4,),
            AutoSizeText(
              'Thank you !',
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
