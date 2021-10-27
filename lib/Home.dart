import 'dart:async';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:softpoint/contactUs.dart';
import 'package:softpoint/login.dart';
import 'package:softpoint/privacy.dart';
import 'package:softpoint/properties.dart';
import 'package:softpoint/topic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:move_to_background/move_to_background.dart';
import 'about.dart';
import 'admob.dart';
import 'mysql.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Mysql mysql = new Mysql();
  AdmobHelper admobHelper = new AdmobHelper();
  TextEditingController textEditingControllerSearch =
      new TextEditingController();
  bool isSearch = false;
  Timer timer;
  String search = "";
  AdWidget adWidget;
  int count = 0;
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    adWidget = AdWidget(
      ad: admobHelper.getBannerAd()..load(),
      key: UniqueKey(),
    );

    showReward();
  }

  @override
  void dispose() {
    admobHelper.rewardedAd.dispose();
    admobHelper.getBannerAd().dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          MoveToBackground.moveTaskToBack();
          return false;
        },
        child: buildBody());
  }

  Scaffold buildBody() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: primeryColor,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(
                  isSearch ? Icons.close : Icons.search,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  if (isSearch) {
                    // visible search
                    setState(() {
                      isSearch = false;
                      setState(() {
                        textEditingControllerSearch.clear();
                        search = "";
                      });
                    });
                  } else {
                    // visible title
                    setState(() {
                      isSearch = true;
                    });
                  }
                })
          ],
          title: isSearch
              ? TextField(
                  style: TextStyle(color: Colors.white),
                  controller: textEditingControllerSearch,
                  autofocus: true,
                  inputFormatters: [
                    // ignore: deprecated_member_use
                    new WhitelistingTextInputFormatter(
                        RegExp("[a-zA-Z-0-9- ]")),
                  ],
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  onSubmitted: (text) {
                    if (text.isEmpty) {
                      isSearch = false;
                    }
                    setState(() {
                      search = text;
                    });
                  },
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: 16),
                      child: Image.asset(
                        "assets/logo2.png",
                        fit: BoxFit.scaleDown,
                        height: 50,
                        width: 50,
                      ),
                    ),
                    Text(
                      "Soft Point",
                    ),
                  ],
                )),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: documentPage(),
        ),
      ),
      drawer: buildDrawer(),
      bottomNavigationBar: Container(
        child: adWidget,
        height: 50,
      ),
    );
  }

  Widget documentPage() {
    return FutureBuilder(
        future: getBook(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return Container(
                  padding: EdgeInsets.only(
                    top: paddingTop,
                  ),
                  child: GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data[index];
                      return buildCard(data["name"], data["imageLink"],
                          data["bookID"], index);
                    },
                  ));
            } else {
              if (isSearch) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/search.png'),
                      Text(
                        "Search result not found !",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                );
              }
            }
          }
          return Center(
              child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(primeryColor),
          ));
        });
  }

  Widget buildCard(String name, String link, int bookID, int index) {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: () {
        if (count == 5) {
          admobHelper.createRewardAd();
          count = 0;
        } else {
          count++;
        }

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Topic(bookID: bookID, title: name)));
        FocusScope.of(context).unfocus();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(link), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 8,
              // changes position of shadow
            ),
          ],
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 200,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primeryColor.withOpacity(0.9),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          child: AutoSizeText(name,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Drawer buildDrawer() {
    return Drawer(
        child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  CircleAvatar(
                    radius: 73,
                    backgroundColor: primeryColor,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/logo2.png'),
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 120,
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        color: primeryColor,
                        borderRadius: BorderRadius.circular(12)),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () async {
                        timer.cancel();

                        await storage.deleteAll();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.security),
                            SizedBox(
                              width: 4,
                            ),
                            Text('Terms & Condision',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.arrow_forward_ios)),
                      ],
                    ),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Privacy())),
                  ),

                  // ignore: deprecated_member_use
                  FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info),
                            SizedBox(
                              width: 4,
                            ),
                            Text('About',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.arrow_forward_ios)),
                      ],
                    ),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => About())),
                  ),

                  // ignore: deprecated_member_use
                  FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.mail),
                            SizedBox(
                              width: 4,
                            ),
                            Text('Contact Us',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.arrow_forward_ios)),
                      ],
                    ),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ContactUs())),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  await launch('https://www.widdev.com',
                      forceSafariVC: false, forceWebView: false);
                },
                child: Text(
                  'Powered By Widdev',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.w700),
                ),
              )
            ]),
      ),
    ));
  }

  Widget buildSplash() {
    return Scaffold(
      body: Stack(
        children: [
          Center(child: Image.asset("assets/logo2.png")),
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
                      color: Colors.black54,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showReward() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      admobHelper.createRewardAd();
      timer.cancel();
    });

    timer = Timer.periodic(Duration(minutes: 8), (timer) {
      admobHelper.createRewardAd();
    });
  }

  Future getBook() async {
    try {
      await InternetAddress.lookup('google.com');
      var conn = await mysql.getConnection();
      var result;
      String sql = "SELECT * FROM `book` WHERE `name` Like '$search%'";
      result = await conn.query(sql);
      result = result.toList();
      print(sql);

      conn.close();
      return result;
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(
          'No internet connection !',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
