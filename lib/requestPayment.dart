import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softpoint/properties.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mysql.dart';

class ReqPayment extends StatelessWidget {
  Mysql db = new Mysql();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color(0xFFB40284A),
          centerTitle: true,
          title: Text(
            "Buy Now",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      body: Container(
        padding: const EdgeInsets.only(left: 24, top: 18, right: 24),
        child: FutureBuilder(
            future: getBank(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 30),
                        child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(children: [
                              new TextSpan(
                                  text: 'Credit  ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                              new TextSpan(
                                  text: "Rs. ${snapshot.data[0]['price']} ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                              new TextSpan(
                                  text:
                                      'to following bank account & send the slip via ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                              new TextSpan(
                                  text: 'Whatsapp ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              new TextSpan(
                                text: 'or ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              new TextSpan(
                                  text: 'Facebook Messenger ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              new TextSpan(
                                  text:
                                      'We will then set your user account for you.',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                            ])),
                      ),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red[400],
                              blurRadius: 1,
                              // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(
                                'Price',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Rs. ${snapshot.data[0]['price']}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Account Number',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                snapshot.data[0]['acNum'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Visibility(
                              visible: snapshot.data[0]['name']!=null && snapshot.data[0]['name']!='',
                              child: ListTile(
                                title: Text(
                                  'Name',
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  snapshot.data[0]['name'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Bank',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                snapshot.data[0]['bank'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Branch',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                snapshot.data[0]['branch'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.green,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await launch(
                                    'whatsapp://send?phone=+94${snapshot.data[0]['number']}',
                                    forceSafariVC: false,
                                    forceWebView: false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  '0${snapshot.data[0]['number']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.facebookMessenger,
                              color: Colors.purple,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await launch('https://m.me/softpointbook',
                                    forceSafariVC: false, forceWebView: false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'm.me/softpointbook',
                                  style: TextStyle(fontSize: 18,decoration: TextDecoration.underline),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.facebook,
                              color: Colors.blue,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await launch(
                                    'https://www.facebook.com/softpointbook',
                                    forceSafariVC: false,
                                    forceWebView: false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'facebook.com/softpointbook',
                                  style: TextStyle(fontSize: 18, decoration: TextDecoration.underline),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
              return Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(primeryColor)));
            }),
      ),
    );
  }

  Future getBank() async {
    try {
      var conn = await db.getConnection();
      var result;
      result = await conn.query(
          "SELECT `acNum`, `name`, `bank`, `branch`, FORMAT(`price`, 2) AS 'price', `number` FROM `bank`");
      result = result.toList();
      conn.close();
      return result;
    } catch (e) {}
  }
}
