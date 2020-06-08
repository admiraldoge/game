import 'dart:math';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';

class HomePaintController extends FlareController {

  ///so we can reference this any where once we declare it
  FlutterActorArtboard _artboard;
  ///our fill animation, so we can animate this each time we add/reduce water intake
  ActorAnimation _splash;
  ///our ice cube that moves on the Y Axis based on current water intake
  ActorAnimation _showPlay;
  ///used for mixing animations
  final List<FlareAnimationLayer> _baseAnimations = [];
  void initialize(FlutterActorArtboard artboard) {
    if (artboard.name.compareTo("Artboard") == 0) {
      _artboard = artboard;
      _splash = artboard.getAnimation("splash");
      _showPlay = artboard.getAnimation("showPlay");
    }
  }

  void setViewTransform(Mat2D viewTransform) {}

  bool advance(FlutterActorArtboard artboard, double elapsed) {
    int len = _baseAnimations.length - 1;
    for (int i = len; i >= 0; i--) {
      FlareAnimationLayer layer = _baseAnimations[i];
      layer.time += elapsed;
      layer.mix = min(1.0, layer.time / 0.01);
      layer.apply(_artboard);

      if (layer.isDone) {
        _baseAnimations.removeAt(i);
      }
    }
    return true;
  }

  void showPlayButton() {
    print('Button play pressed :,v!');
    playAnimation("showPlay");
  }
  void playAnimation(String animName) {
    ActorAnimation animation = _artboard.getAnimation(animName);

    if (animation != null) {
      _baseAnimations.add(FlareAnimationLayer()
        ..name = animName
        ..animation = animation);
    }
  }
}