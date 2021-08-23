import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:world/Screens/HomeScreen.dart';
import 'package:world/Screens/MoreOption.dart';


class DetailScreen extends StatefulWidget {
  final String img;
  final String name;

  DetailScreen(this.img, this.name,);
  @override
  _DetailScreen createState()=> _DetailScreen(img, name);

}

class _DetailScreen extends State<DetailScreen> with SingleTickerProviderStateMixin {
  String img;
  String name;

  _DetailScreen(this.img, this.name,);

  int _value = 1;

  double scale;

  AudioPlayer audio = new AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();

  bool playing = false;

  AnimationController controller;

  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> MoreList;
  final CollectionReference collectionReference =
  FirebaseFirestore.instance.collection("Data");

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(
            milliseconds: 10
        ),
        lowerBound: 0.0,
        upperBound: 0.1
    )
      ..addListener(() {
        setState(() {});
      });
    subscription = collectionReference.snapshots().listen((dataSnapshot) {
      setState(() {
        MoreList = dataSnapshot.docs;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scale = 1 - controller.value;
    return Scaffold(
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Stack(
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(img),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8), BlendMode.dstATop),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 1.7,
                    margin: EdgeInsets.only(
                        left: MediaQuery
                            .of(context)
                            .size
                            .width / 12,
                        right: MediaQuery
                            .of(context)
                            .size
                            .width / 12,
                        top: MediaQuery
                            .of(context)
                            .size
                            .height / 12,
                        bottom: MediaQuery
                            .of(context)
                            .size
                            .height / 20
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(img),
                            fit: BoxFit.fill
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: const Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Colors.white,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //
                        ]
                    ),
                  ),
                  Text("$name",
                    style: TextStyle(
                      fontSize:
                      MediaQuery
                          .of(context)
                          .size
                          .height / 28,
                      fontFamily: 'Caveat',
                      decorationThickness: 5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery
                        .of(context)
                        .size
                        .height / 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 90,
                          width: 90,
                          child: PlayButton(
                            onPressed: () {},
                            playIcon: Icon(
                              Icons.play_arrow, size: 50, color: Colors.grey,),
                            pauseIcon: Icon(
                              Icons.pause, size: 50, color: Colors.grey,),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery
                          .of(context)
                          .size
                          .height / 65,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RaisedButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                            color: Colors.white38,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                )
                            ),
                            child: Center(
                              child: Text("Back",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white70,
                                    fontFamily: 'Caveat',
                                    fontWeight: FontWeight.w900
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Slide Up Panel
            SlidingUpPanel(
              minHeight: MediaQuery
                  .of(context)
                  .size
                  .height / 17,
              maxHeight: MediaQuery
                  .of(context)
                  .size
                  .height / 1.6,
              backdropEnabled: true,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              //SlideUp panel backEnd
              panel: Container(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      margin: EdgeInsets.only(top: 15,),
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15)
                          )
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 28,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 3,
                          decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "More",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontFamily: 'Caveat',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 500,
                      margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                      padding: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10)
                          )
                      ),
                      child: MoreList != null ?
                      ListView.builder(
                        itemCount: MoreList.length,
                        itemBuilder: (BuildContext context, i) {
                          String img = MoreList[i]['img'];
                          String name = MoreList[i]['name'];
                          return Container(
                            height: 80,
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 70,
                                  width: 100,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(img),
                                          fit: BoxFit.fill
                                      )
                                  ),
                                ),
                                Text(name),
                                IconButton(icon: Icon(Icons.play_arrow),
                                  onPressed: () {
                                    Get.to(DetailScreen(img, name));
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ) : Center(
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.lightGreen,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              color: Colors.transparent,
              //front show banner
              collapsed: Container(
                child: Container(
                  child: Stack(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height / 28,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3,
                              decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                                  borderRadius: BorderRadius.circular(30)
                              ),
                            )
                          ],
                        ),
                        Container(
                          //second container
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height / 28,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 3,
                                      decoration: BoxDecoration(
                                          color: Colors.lightGreen,
                                          borderRadius: BorderRadius.circular(
                                              30)
                                      ),
                                      child: Center(
                                        child: Text("More",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                              fontFamily: 'Caveat'
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 19),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30)
                                      )
                                  ),
                                ),
                              ],
                            )
                        )
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}