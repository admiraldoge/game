import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:game/home_page_paint_controller.dart';
import 'package:game/tentacle_controller.dart';
import 'package:game/playButton.dart';
import 'package:nima/nima_actor.dart';
import 'package:game/flower.dart';

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
  List<Petal> petals = [];
  bool createFlowers = true;

  Timer timer;

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer){
      if (!createFlowers) {
        timer.cancel();
      }
      print('Creating flower!');
      print('Controller'+_homePaintController.toString());
      double newFlowerYCoordinate = new Random().nextInt((MediaQuery.of(context).size.height).toInt() - 100) + (MediaQuery.of(context).size.height * 0.2);
      double newFlowerXCoordinate = new Random().nextInt(2).toDouble();
      double movement = 1;
      if(newFlowerXCoordinate == 1) {
        newFlowerXCoordinate = MediaQuery.of(context).size.width;
        movement *= -1;
      }
      setPetalPos(newFlowerXCoordinate, newFlowerYCoordinate, movement);
    });
  }

  cancelTimer() {
    timer.cancel();
  }

  void setTentaclePos(double x, double y) {
    print('Updating tentacle pos to '+x.toString()+" - "+y.toString());
    //tentaclePosX = x;
    //tentaclePosY = y;
    setState(() {
      tentaclePosX = x-100;
      tentaclePosY = y-100;
    });
  }

  void setPetalPos(double x, double y, double xMove) {
    print('Setting new flower in '+x.toString()+" - "+y.toString()+" - "+xMove.toString());
    //tentaclePosX = x;
    //tentaclePosY = y;
    print('Number of petals: '+petals.length.toString());
    if(petals.length > 10)createFlowers = false;
    setState(() {
      petals.add(new Petal(
          x: x,
          y: y,
          tx: x,
          ty: y,
          xMove: xMove
      ));
    });
  }

  @override
  initState() {
    _homePaintController = HomePaintController();
    _tentacleController = TentacleController();
    _tentacleController.lookAt(150,10);
    tentaclePosX = 100;
    tentaclePosY = 100;
    petals = [
      new Petal(
          x: 600,
          y: 100,
          tx: 100,
          ty: 100,
          xMove: -4
      )
    ];
    startTimer();

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
                  Image.asset(
                    "assets/homeBackground.png",
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
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
                        color: Colors.red,
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
                  ...petals
                  ,
                  MyWidget(
                    moveTarget: _tentacleController.lookAt,
                    moveTentacle: setPetalPos,
                  ),
                  Positioned(
                      top: 20,
                      left: ((MediaQuery.of(context).size.width)-100),
                      child: Text(
                        '123',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                  ),
                ],
              )),
        )
    );
  }

  @override
  void dispose () {
    cancelTimer();
    super.dispose();
  }

}
