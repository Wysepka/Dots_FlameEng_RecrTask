import 'package:dots_flameeng_recrtask/game/dots_game.dart';
import 'package:dots_flameeng_recrtask/game/utility/position_utility.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class DotSpriteComponent extends SpriteComponent with HasGameReference<DotsGame>{
  Rect? _previousVisibleRect;
  late Rect cameraBounds;
  final double dotDiameter;

  DotSpriteComponent({super.position ,required this.cameraBounds , required this.dotDiameter})
      : super(
      size: Vector2.all(dotDiameter),
      anchor: Anchor.center);

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    sprite = await Sprite.load('components/actors/yellow_player_sprite.png');
    _previousVisibleRect = game.camera.visibleWorldRect;
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

class DotTransform {
  final Vector2 position; // center
  final Vector2 size;     // sprite size

  const DotTransform({
    required this.position,
    required this.size,
  });

  double get radius => size.x * 0.5;
}