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
  List<Petal> flowerList = [];
  bool createFlowers = true;
  int flowerId = 0;
  int points;

  Timer timer;

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 10), (timer){
      if(flowerId == 0) {
        print('Screen height: ' + MediaQuery.of(context).size.height.toString());
        print('Screen width: ' + MediaQuery.of(context).size.width.toString());
      }
      if (!createFlowers) {
        timer.cancel();
      }
      print('Creating flower!');
      double newFlowerYCoordinate = new Random().nextInt((MediaQuery.of(context).size.height).toInt() - 100) + (MediaQuery.of(context).size.height * 0.2);
      double newFlowerXCoordinate = new Random().nextInt(2).toDouble();
      double movement = 0.2;
      if(newFlowerXCoordinate > 0.5) {
        newFlowerXCoordinate = MediaQuery.of(context).size.width;
        print('Flower to appear on the right');
        movement *= -1;
      }else {
        print('Flower to appear on the left');
      }
      createFlower(newFlowerXCoordinate, newFlowerYCoordinate, movement);
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

  void createFlower(double x, double y, double xMove) {
    print('Setting new flower in '+x.toString()+" - "+y.toString()+" - "+xMove.toString());
    //tentaclePosX = x;
    //tentaclePosY = y;
    print('Number of petals: '+flowerList.length.toString());
    if(flowerList.length > 10)createFlowers = false;
    setState(() {
      flowerList.add(new Petal(
          x: x,
          y: y,
          tx: x,
          ty: y,
          xMove: xMove,
          id: flowerId,
          disposeFlower: this.deleteFlower
      ));
    });
    flowerId++;
  }

  void deleteFlower(int id) {
    print('Erasing flower ' + id.toString());
    setState(() {
      flowerList.removeWhere((flower) => flower.id == id);
      points++;
    });
  }

  @override
  initState() {
    _homePaintController = HomePaintController();
    _tentacleController = TentacleController();
    _tentacleController.lookAt(150,10);
    tentaclePosX = 100;
    tentaclePosY = 100;
    points = 0;
    flowerList = [

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
                  ...flowerList
                  ,
                  Positioned(
                      top: 20,
                      left: ((MediaQuery.of(context).size.width)-70),
                      child: Text(
                        points.toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontFamily: 'Museo'
                        ),
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
