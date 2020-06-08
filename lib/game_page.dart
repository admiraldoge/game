import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:game/home_page_paint_controller.dart';
import 'package:game/tentacle_controller.dart';
import 'package:game/playButton.dart';
import 'package:nima/nima_actor.dart';

import 'drag.dart';

class GamePage extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<GamePage> {

  HomePaintController _homePaintController;
  TentacleController _tentacleController;
  double tentaclePosX;
  double tentaclePosY;

  void setTentaclePos(double x, double y) {
    print('Updating tentacle pos to '+x.toString()+" - "+y.toString());
    //tentaclePosX = x;
    //tentaclePosY = y;
    setState(() {
      tentaclePosX = x-100;
      tentaclePosY = y-100;
    });
  }

  @override
  initState() {
    _homePaintController = HomePaintController();
    _tentacleController = TentacleController();
    _tentacleController.lookAt(150,10);
    tentaclePosX = 100;
    tentaclePosY = 100;
    print('Controller'+_homePaintController.toString());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Color.fromRGBO(93, 142, 155, 1.0),
        body: Center(
          child: Container(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Positioned.fill(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Expanded(
                                child: FlareActor(
                                    "assets/paint.flr",
                                    shouldClip: false,
                                    fit: BoxFit.cover,
                                    controller: _homePaintController,
                                    artboard: "Artboard"
                                )
                            )
                          ]
                      )
                  ),
                  Positioned(
                      height: 400,
                      top: ((MediaQuery.of(context).size.height)*0.1),
                      left: ((MediaQuery.of(context).size.width)*0.35),
                      width: 250,
                      child: FlareActor(
                        "assets/eto.flr",
                        shouldClip: false,
                        fit: BoxFit.contain,
                        artboard: "Artboard",
                        animation: "idle",
                      )
                  ),
                  Positioned(
                      height: 400,
                      top: 150,
                      left: 10,
                      width: 400,
                      child: FlareActor(
                          "assets/flower.flr",
                          shouldClip: false,
                          fit: BoxFit.contain,
                          artboard: "Artboard",
                          animation: "rotate",
                          color: Colors.green,
                      )
                  ),
                  Positioned(
                      height: 200,
                      top: tentaclePosY,
                      left: tentaclePosX,
                      width: 200,
                      child: FlareActor(
                          "assets/tentacle3.flr",
                          shouldClip: false,
                          fit: BoxFit.contain,
                          artboard: "Artboard",
                          controller: _tentacleController,
                          color: Colors.green,
                      )
                  ),
                  MyWidget(
                    moveTarget: _tentacleController.lookAt,
                    moveTentacle: setTentaclePos,
                  )
                ],
              )),
        )
    );
  }

}
