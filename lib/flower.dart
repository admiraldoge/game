import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';


class Petal extends StatefulWidget  {
  final double x,y,tx,ty;
  final double xMove;
  final int id;
  final Function disposeFlower;
  const Petal ({ Key key, this.x,this.y,this.tx,this.ty, this.xMove, this.id, this.disposeFlower }): super(key: key);
  @override
  _PetalState createState() => _PetalState();
}

class _PetalState extends State<Petal> {

  //TODO: Configure to make the flower appear in centre with the click

  double dx = 0.0;
  double dy = 0.0;

  Timer timer;

  startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      /*if(condition) {
        timer.cancel();
      }

       */
      //print('Moving flower '+widget.xMove.toString()+' coordinates');
      setState(() {
        dx += widget.xMove;
      });
      //print('End Moving flower');
    });
  }

  cancelTimer() {
    timer.cancel();
  }

  @override
  initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Positioned(
      top: widget.y + dy -50, //Substractin 50 to construc the flower in th the centre of click
      left: widget.x + dx- -50,
      height: 100,
      width: 100,
      child: FlatButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: SizedBox(
          child: FlareActor(
              'assets/flower.flr',
            animation: 'rotateRight',
          ),
        ),
        onPressed: (){
          print('Flower tapped: '+widget.id.toString());
          widget.disposeFlower(widget.id);
        },
      ),
    );
  }

  setPosition(double _x,double _y) {
    setState(() {

    });
  }

  @override
  void dispose () {
    cancelTimer();
    super.dispose();
  }
}