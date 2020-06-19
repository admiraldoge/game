import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:game/home_page_paint_controller.dart';
import 'package:game/tentacle_controller.dart';
import 'package:game/playButton.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import 'drag.dart';

class HomePage extends StatefulWidget {
  @override
  _PaintState createState() => _PaintState();
}

class _PaintState extends State<HomePage> {

  TentacleController _tentacleController;
  final AudioCache audioCache = new AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);


  IconData musicIcon = Icons.headset;
  bool musicIsPlaying = true;
  int playerScore = 0;
  //double screenHeight, screenWidth;


  void playMusic() async{
    advancedPlayer = await audioCache.play('Echos.mp3'); // assign player here
  }

  void stopMusic() {
    advancedPlayer?.stop(); // stop the file like this
  }

  playLocal() async {
    print('Playing music!');
    audioCache.loop('Echos.mp3');
  }

  clearCache() async {
    print('Stopping music!');
    audioCache.clear('Echos.mp3');
  }

  @override
  initState() {
    _tentacleController = TentacleController();
    playMusic();
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
                      top: ((MediaQuery.of(context).size.height)/2)-50,
                      left: ((MediaQuery.of(context).size.width)/2)-75,
                      child: PlayButton(
                          child: Text("Play",
                              style: TextStyle(
                                  fontFamily: "Museo",
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              )
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/game');
                          }
                      )
                  ),
                  Positioned(
                    top: ((MediaQuery.of(context).size.height)/2)+60,
                    left: ((MediaQuery.of(context).size.width)/2)-75,
                    child: Text(
                          "Score: "+playerScore.toString(),
                          style: TextStyle(
                              fontFamily: "Museo",
                              fontWeight: FontWeight.w300,
                              fontSize: 40,
                              color: Colors.black
                          )
                      ),
                  ),
                  Positioned(
                      top: (MediaQuery.of(context).size.height)-65,
                      left: 10,
                      child: IconButton(
                        icon: Icon(musicIcon),
                        color: Colors.black,
                        iconSize: 45,
                        onPressed: () {
                          if (musicIsPlaying) {
                            setState(() {
                              musicIcon = Icons.headset_off;
                              musicIsPlaying = false;
                            });
                            stopMusic();
                          } else {
                            setState(() {
                              musicIcon = Icons.headset;
                              musicIsPlaying = true;
                            });
                            playMusic();
                          }
                        },
                      )
                  )
                ],
              )),
        )
    );
  }

}
