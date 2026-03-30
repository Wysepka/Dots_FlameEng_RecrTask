import 'package:dots_flameeng_recrtask/game/components/dot_actor_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/config/game_constants.dart';
import 'package:flame/components.dart';

class EnemySpriteComponent extends DotActorSpriteComponent{

  EnemySpriteComponent(super.initialPosition, {required super.cameraBounds, })
      : super(dotDiameter: GameConstants.enemyStartSize);

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    sprite = await Sprite.load('components/actors/red_ball_sprite.png');
    movingSpeed = GameConstants.enemyMovingSpeed;
  }
}