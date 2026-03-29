import 'package:dots_flameeng_recrtask/game/config/game_constants.dart';
import 'package:dots_flameeng_recrtask/game/dots_game.dart';
import 'package:dots_flameeng_recrtask/game/utility/position_utility.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';

class PlayerSpriteComponent extends SpriteComponent with DragCallbacks , HasGameReference<DotsGame> {

  Rect? _previousVisibleRect;
  late Rect cameraBounds;

  PlayerSpriteComponent({super.position ,required this.cameraBounds})
      : super(
      size: Vector2.all(GameConstants.playerStartSize) ,
      anchor: Anchor.center);

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    sprite = await Sprite.load('components/actors/yellow_player_sprite.png');
    _previousVisibleRect = game.camera.visibleWorldRect;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    position = PositionUtility.getCameraBoundsClampedPosition(position += event.canvasDelta, size, anchor, game.camera.visibleWorldRect);
  }

  @override
  void onGameResize(Vector2 size){
    super.onGameResize(size);

    Rect newRect = game.camera.visibleWorldRect;
    Rect oldRect = _previousVisibleRect ?? newRect;

    position = PositionUtility.mapPositionBetweenRects(currentPosition: position, fromRect: oldRect, toRect: newRect);
    position = PositionUtility.clampToVisibleRect(position , newRect , this.size);

    _previousVisibleRect = newRect;
  }
}