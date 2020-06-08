
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {

  double x,y,dx,dy;


  final Function moveTarget;
  final Function moveTentacle;

  MyWidget({
    this.moveTarget,
    this.moveTentacle
  });

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => print('tapped!'),
      onTapDown: (TapDownDetails details) => _onTapDown(details),
      onTapUp: (TapUpDetails details) => _onTapUp(details),
      onPanStart: (DragStartDetails details) => _onPanStart(details),
      onPanUpdate: (DragUpdateDetails details) => _onPanUpdate(details),
      onPanEnd: (DragEndDetails details) => _onPanEnd(details),
    );
  }

  _onTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    print("tap down " + x.toString() + ", " + y.toString());
  }

  _onTapUp(TapUpDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    print("tap up " + x.toString() + ", " + y.toString());
    //moveTarget(x,y);
    moveTentacle(x,y);
  }
  _onPanStart(DragStartDetails details){
    x = details.globalPosition.dx;
    y = details.globalPosition.dy;
    print('Pan started in '+x.toString()+"-"+y.toString());
  }
  _onPanUpdate(DragUpdateDetails details){
    dx = details.globalPosition.dx - x;
    dy = details.globalPosition.dy - y;
    double xc = x + dx;
    double yc = y + dy;
    //moveTarget(xc,yc);
    //moveTentacle(xc,yc);
  }
  _onPanEnd(DragEndDetails details){
    x = x + dx;
    y = y + dy;
    print('Final position: '+x.toString()+"-"+y.toString());
    //moveTarget(x,y);
    x = 0;
    y = 0;
  }
}