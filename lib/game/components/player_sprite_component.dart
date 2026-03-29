import 'package:dots_flameeng_recrtask/game/components/dot_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/config/game_constants.dart';
import 'package:dots_flameeng_recrtask/game/utility/position_utility.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';

class PlayerSpriteComponent extends DotSpriteComponent with DragCallbacks {

  PlayerSpriteComponent({super.position ,required super.cameraBounds})
      : super(
        dotDiameter: GameConstants.playerStartSize
      );

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    sprite = await Sprite.load('components/actors/yellow_player_sprite.png');

    add(CircleHitbox(
      radius: dotDiameter,
      collisionType: CollisionType.passive
    ));
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    position = PositionUtility.getCameraBoundsClampedPosition(position += event.canvasDelta, size, anchor, game.camera.visibleWorldRect);
  }
}