import 'package:dots_flameeng_recrtask/game/components/dot_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/components/enemy_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/config/game_constants.dart';
import 'package:dots_flameeng_recrtask/game/utility/position_utility.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';

class PlayerSpriteComponent extends DotSpriteComponent with DragCallbacks , CollisionCallbacks{

  PlayerSpriteComponent({super.position ,required super.cameraBounds})
      : super(dotDiameter: GameConstants.playerStartSize);

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    sprite = await Sprite.load('components/actors/yellow_player_sprite.png');

    add(CircleHitbox(
      radius: dotDiameter,
      collisionType: CollisionType.active
    ));
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    position = PositionUtility.getCameraBoundsClampedPosition(position += event.canvasDelta, size, anchor, game.camera.visibleWorldRect);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if(other is EnemySpriteComponent){
      
    }
  }

}