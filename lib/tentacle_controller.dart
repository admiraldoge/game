import 'dart:math';
import 'dart:ui';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_dart/math/vec2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';

class TentacleController extends FlareController {

  ///so we can reference this any where once we declare it
  FlutterActorArtboard _artboard;
  // Store a reference to our face control node (the "ctrl_look" node in Flare)
  ActorNode _target;

  // Storage for our matrix to get global Flutter coordinates into Flare world coordinates.
  Mat2D _globalToFlareWorld = Mat2D();

  // Caret in Flutter global coordinates.
  Vec2D _caretGlobal = Vec2D();

  // Caret in Flare world coordinates.
  Vec2D _caretWorld = Vec2D();

  // Store the origin in both world and local transform spaces.
  Vec2D _faceOrigin = Vec2D();
  Vec2D _faceOriginLocal = Vec2D();

  bool _hasFocus = false;

  // Project gaze forward by this many pixels.
  static const double _projectGaze = 120.0;
  ///our fill animation, so we can animate this each time we add/reduce water intake
  FlareAnimationLayer _idle;
  ///our ice cube that moves on the Y Axis based on current water intake
  ActorAnimation _showPlay;
  ///used for mixing animations
  final List<FlareAnimationLayer> _baseAnimations = [];

  void initialize(FlutterActorArtboard artboard) {
    if (artboard.name.compareTo("Artboard") == 0) {
      _artboard = artboard;
      _target = artboard.getNode("target");
      if (_target != null) {
        _target.getWorldTranslation(_faceOrigin);
        Vec2D.copy(_faceOriginLocal, _target.translation);
      }
    }
    _idle = FlareAnimationLayer()
      ..animation = _artboard.getAnimation("idle")
      ..mix = 1.0;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
    Mat2D.invert(_globalToFlareWorld, viewTransform);
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    // Advance the current time by [elapsed].
    /*_idle.time =
        (_idle.time + elapsed) % _idle.duration;
    _idle.apply(artboard);
    */

    //moveTarget
    Vec2D targetTranslation;

      //print('FaceOrigin: '+_faceOrigin[0].toString()+" - "+_faceOrigin[1].toString());
      //print('FaceOriginLocal: '+_faceOriginLocal[0].toString()+" - "+_faceOriginLocal[1].toString());
      //print('Actual target position: '+_target.x.toString()+" - "+_target.y.toString());
      // Get caret in Flare world space.
      Vec2D.transformMat2D(_caretWorld, _caretGlobal, _globalToFlareWorld);
      /*print('Transforming '+_caretGlobal[0].toString()+" - "+_caretGlobal[1].toString()+""
          " to "+_caretWorld[0].toString()+" - "+_caretWorld[1].toString());

       */
      //_caretWordl = wordlTouch
      // To make it more interesting, we'll also add a sinusoidal vertical offset.
      /*_caretWorld[1] +=
          sin(new DateTime.now().millisecondsSinceEpoch / 300.0) * 70.0;

       */

      // Compute direction vector.

      Vec2D toCaret = Vec2D.subtract(Vec2D(), _caretWorld, _faceOrigin);
      //print('The direction vector is '+toCaret[0].toString()+" - "+toCaret[1].toString());
      //Vec2D.normalize(toCaret, toCaret);
      //Vec2D.scale(toCaret, toCaret, _projectGaze);

      // Compute the transform that gets us in face "ctrl_face" space.
      Mat2D toFaceTransform = Mat2D();
      if (Mat2D.invert(toFaceTransform, _target.parent.worldTransform)) {
        // Put toCaret in local space, note we're using a direction vector
        // not a translation so transform without translation
        Vec2D.transformMat2(toCaret, toCaret, toFaceTransform);
        // Our final "ctrl_face" position is the original face translation plus this direction vector
        targetTranslation = Vec2D.add(Vec2D(), toCaret, _faceOriginLocal);
      }

    // We could just set _target.translation to targetTranslation, but we want to animate it smoothly to this target
    // so we interpolate towards it by a factor of elapsed time in order to maintain speed regardless of frame rate.
    Vec2D diff =
    Vec2D.subtract(Vec2D(), targetTranslation, _target.translation);
    Vec2D frameTranslation = Vec2D.add(Vec2D(), _target.translation,
        Vec2D.scale(diff, diff, min(1.0, elapsed * 5.0)));
    _target.translation = frameTranslation;


    //_target.translation = targetTranslation;





    //animation
    int len = _baseAnimations.length - 1;
    //print('Updating with '+(len+1).toString()+' aniamtions');
    for (int i = len; i >= 0; i--) {
      FlareAnimationLayer layer = _baseAnimations[i];
      layer.time += elapsed;
      layer.mix = 0.5;
      //print('State of anumation: time'+layer.time.toString()+" -  mix:"+layer.mix.toString());
      layer.apply(_artboard);

      if (layer.isDone) {
        _baseAnimations.removeAt(i);
      }
    }

    return true;
  }

  void showPlayButton() {
    print('Button play pressed :,v2!');
    playAnimation("idle");
  }
  void playAnimation(String animName) {
    ActorAnimation animation = _artboard.getAnimation(animName);

    if (animation != null) {
      _baseAnimations.add(FlareAnimationLayer()
        ..name = animName
        ..animation = animation
        ..mix = 0.5
      );
    }
  }
  // Transform the [Offset] into a [Vec2D].
  // If no caret is provided, lower the [_hasFocus] flag.
  void lookAt(double x,double y) {
    _caretGlobal[0] = x;
    _caretGlobal[1] = y;
    _hasFocus = true;
  }
}