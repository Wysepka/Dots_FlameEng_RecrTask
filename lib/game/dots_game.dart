import 'package:dots_flameeng_recrtask/game/containers/GameCallbacksContainer.dart';
import 'package:dots_flameeng_recrtask/game/dots_world.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class DotsGame extends FlameGame{

  late final DotsWorld _dotsWorld;
  final GameCallbacksContainer _gameCallbacksContainer;

  DotsGame(this._gameCallbacksContainer);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _dotsWorld = DotsWorld(_gameCallbacksContainer);
    camera = CameraComponent(world: _dotsWorld);

    _dotsWorld.cameraBounds = camera.visibleWorldRect;

    addAll([
      _dotsWorld,
      camera,
    ]);
  }
}