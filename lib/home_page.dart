import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:game/home_page_paint_controller.dart';
import 'package:game/tentacle_controller.dart';
import 'package:game/playButton.dart';
import 'package:nima/nima_actor.dart';

import 'drag.dart';

class HomePage extends StatefulWidget {
  @override
  _PaintState createState() => _PaintState();
}

class _PaintState extends State<HomePage> {

  HomePaintController _homePaintController;
  TentacleController _tentacleController;
  //double screenHeight, screenWidth;

  @override
  initState() {
    _homePaintController = HomePaintController();
    _tentacleController = TentacleController();
    print('Controller'+_homePaintController.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Height'+(MediaQuery.of(context).size.height).toString());
    print('Wifht'+(MediaQuery.of(context).size.width).toString());
    print('Building the widget');
    return Scaffold(
        backgroundColor: Color.fromRGBO(93, 142, 155, 1.0),
        body: Center(
          child: Container(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    "assets/homeBackground.png",
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                      top: ((MediaQuery.of(context).size.height)/2)-30,
                      left: ((MediaQuery.of(context).size.width)/2)-75,
                      child: PlayButton(
                          child: Text("Play",
                              style: TextStyle(
                                  fontFamily: "RobotoMedium",
                                  fontSize: 50,
                                  color: Colors.white)
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/game');
                          }
                      )
                  )
                ],
              )),
        )
    );
  }

}
