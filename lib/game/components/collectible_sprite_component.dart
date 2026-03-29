import 'package:dots_flameeng_recrtask/game/components/dot_actor_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/components/dot_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/config/game_constants.dart';
import 'package:flame/components.dart';

class CollectibleSpriteComponent extends DotActorSpriteComponent{

  CollectibleSpriteComponent(super.initialPosition, {required super.cameraBounds})
      : super(dotDiameter: GameConstants.collectibleStartSize);


  @override
  Future<void> onLoad() async{
    await super.onLoad();
    sprite = await Sprite.load('components/actors/green_ball_sprite.png');
    movingSpeed = GameConstants.collectibleMovingSpeed;
  }
}