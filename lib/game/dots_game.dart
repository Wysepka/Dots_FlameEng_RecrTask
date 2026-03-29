import 'package:dots_flameeng_recrtask/game/dots_world.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class DotsGame extends FlameGame{

  late final DotsWorld dotsWorld;

  DotsGame();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    dotsWorld = DotsWorld();
    camera = CameraComponent(world: dotsWorld);

    dotsWorld.cameraBounds = camera.visibleWorldRect;

    addAll([
      dotsWorld,
      camera,
    ]);
  }
}