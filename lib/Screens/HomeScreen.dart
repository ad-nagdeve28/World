import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:world/Screens/DetailScreen.dart';
import 'package:world/Screens/MoreOption.dart';

class HomeScreen extends StatefulWidget{
  @override
  HomeScreenState createState()=> HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>{

  // ignore: cancel_subscriptions
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> selectlist;
  final CollectionReference collectionReference =
  FirebaseFirestore.instance.collection("Data");
  @override
  void initState(){
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot){
      setState(() {
        selectlist = datasnapshot.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body:  Column(
        children: [
          SafeArea(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 5,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.elliptical(110, 130)
                          )
                      ),
                      child: Stack(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 20,
                                  top: MediaQuery.of(context).size.height / 40
                              ),
                              child: Text(
                                  "Feel the Soul",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Caveat',
                                    fontWeight: FontWeight.w900,
                                    fontSize: MediaQuery.of(context).size.height / 25
                                  ),
                              ),
                          ),
                        ],
                      )
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 1.29,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 20,
                      top: MediaQuery.of(context).size.height / 25
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50)
                      )
                    ),
                    child: selectlist != null ? ListView.builder(
                        itemCount: selectlist.length,
                        itemBuilder: (context, i){
                          String img = selectlist[i]['img'];
                          String name = selectlist[i]['name'];
                          return InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => DetailScreen(img, name)
                                  )
                              );
                            },
                            child: Container(
                                height: MediaQuery.of(context).size.height / 4.3,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: NetworkImage(img),
                                      fit: BoxFit.fill,
                                    ),
                                  border: Border.all(color: Colors.lightGreenAccent , width:  2)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: MediaQuery.of(context).size.width / 25,
                                              bottom: MediaQuery.of(context).size.height / 50,
                                          ),
                                          child: Text(name,
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontFamily: 'Caveat',
                                                fontWeight: FontWeight.w800
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          );
                        }
                    ): Center(
                      child: CircularProgressIndicator(backgroundColor: Colors.lightGreen,),
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}


class SimpleDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                )
            ),
          ),
          ListTile(
            title: Text('Item 1', style: TextStyle(fontSize: 20),),
          ),
          ListTile(
            title: Text('Item 2', style: TextStyle(fontSize: 25),),
          )
        ],
      ),
    );
  }
}

class CustomContainerShapeBorder extends CustomPainter {
  final double height;
  final double width;
  final Color fillColor;
  final double radius;

  CustomContainerShapeBorder({
    this.height: 600.0,
    this.width: 300.0,
    this.fillColor: Colors.lightGreen,
    this.radius: 10.0,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Path path = new Path();
    path.moveTo(0.0, -radius);
    path.lineTo(0.0, -(height - radius));
    path.conicTo(0.0, -height, radius, -height, 1);
    path.lineTo(width - radius, -height);
    path.conicTo(width, -height, width, -(height + radius), 1);
    path.lineTo(width, -(height - radius));
    path.lineTo(width, -radius);

    path.conicTo(width, 0.0, width - radius, 0.0, 1);
    path.lineTo(radius, 0.0);
    path.conicTo(0.0, 0.0, 0.0, -radius, 1);
    path.close();
    canvas.drawPath(path, Paint()..color = fillColor);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CustomApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        color: Colors.lightGreen,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}



class CustomShapeBorder extends CustomPainter {
  final double height;
  final double width;
  final Color fillColor;
  final double radius;

  CustomShapeBorder({
    this.height: 600.0,
    this.width: 300.0,
    this.fillColor: Colors.lightGreen,
    this.radius: 10.0,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Path path = new Path();
    path.moveTo(10.0, -radius);
    path.lineTo(0.0, -(height - radius));
    path.conicTo(0.0, -height, radius, -height, 1);
    path.lineTo(width - radius, -height, );
    path.conicTo(width, -height, width, -(height + radius), 0.9);
    path.lineTo(width, -(height - radius));
    path.lineTo(width, -radius);

    path.conicTo(width, 0.0, width - radius, 0.0, 1);
    path.lineTo(radius, 0.0);
    path.conicTo(0.0, 0.0, 0.0, -radius, 1);
    path.close();
    canvas.drawPath(path, Paint()..color = fillColor);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}