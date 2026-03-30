import 'dart:math';

import 'package:dots_flameeng_recrtask/game/components/dot_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/config/game_constants.dart';
import 'package:dots_flameeng_recrtask/game/utility/collision_utility.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class DotActorSpriteComponent extends DotSpriteComponent with CollisionCallbacks{
  DotActorSpriteComponent(this._initialPosition, {required super.cameraBounds, required super.dotDiameter});

  final Vector2 _initialPosition;
  late Vector2 _velocity;
  late double movingSpeed;
  bool _isDead = false;

  bool get isDead => _isDead;

  @override
  Future<void> onLoad() async{
    await super.onLoad();

    add(CircleHitbox(radius: size.x / 2 , collisionType: CollisionType.active));

    Random random = Random();

    _velocity = Vector2(random.nextDouble() , random.nextDouble());
    position = _initialPosition;
  }

  @override
  void update(double dt){
    position += _velocity * dt * GameConstants.enemyMovingSpeed;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ScreenHitbox) {

      Rect screenBounds = game.camera.visibleWorldRect;

      _velocity = CollisionUtility.calculateBounceVelocityFromScreenHitbox(
          position: position,
          componentSize: size,
          velocity: _velocity,
          screenRect: screenBounds
      );

      position = CollisionUtility.clampPositionInsideScreen(
          position: position,
          componentSize: size,
          screenRect: screenBounds
      );
    }
    else if(other is DotActorSpriteComponent){
      _velocity = CollisionUtility.calculateBounceVelocityFromActor(
          selfPosition: position,
          selfSize: size,
          otherPosition: other.position,
          otherSize: other.size,
          velocity: _velocity
      );
    }
  }

  void onPlayerCollided(){
    if(_isDead){
      return;
    }
    _isDead = true;
    removeFromParent();
  }
}