import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:softpoint/properties.dart';
import 'admob.dart';
import 'mysql.dart';
import 'pdfViewer.dart';

class Topic extends StatefulWidget {
  final int bookID;
  final String title;
  const Topic({Key key, this.bookID, this.title}) : super(key: key);

  @override
  _TopicState createState() => _TopicState();
}

class _TopicState extends State<Topic> {
  Mysql mysql = new Mysql();
  AdmobHelper admobHelper = new AdmobHelper();
  TextEditingController textEditingControllerSearch =
      new TextEditingController();
  bool isSearch = false;
  String search = "";
  AdWidget adWidget;
  int count = 0;
  @override
  void initState() {
    super.initState();
    adWidget = AdWidget(
      ad: admobHelper.getBannerAd()..load(),
      key: UniqueKey(),
    );
  }

  @override
  void dispose() {
    FocusScope.of(context).unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody();
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
              : Text(widget.title)),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: documentPage(),
        ),
      ),
      bottomNavigationBar: Container(
        child: adWidget,
        height: 50,
      ),
    );
  }

  Widget documentPage() {
    return FutureBuilder(
        future: getPdf(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return Container(
                  padding: EdgeInsets.only(
                    top: paddingTop,
                  ),
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data[index];
                        return buildCard(
                            data["title"], data["text"], data["link"], index);
                      }));
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
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget buildCard(String title, String text, String link, int index) {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PdfViewer(
                      url: link,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Card(
          color: index % 2 == 0 ? primeryColor : Colors.purple,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoSizeText(title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                    AutoSizeText(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getPdf() async {
    try {
      await InternetAddress.lookup('google.com');
      var conn = await mysql.getConnection();
      var result;
      String sql =
          "SELECT * FROM `pdf` INNER JOIN `book_topic` ON  `pdf`.`topicID`= `book_topic`.`topicID` WHERE `book_topic`.`bookID`='${widget.bookID}' AND `pdf`.`title` LIKE '$search%'";
      print(sql);
      result = await conn.query(sql);
      result = result.toList();

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
