import 'package:dots_flameeng_recrtask/core/app_logger.dart';
import 'package:dots_flameeng_recrtask/game/containers/GameCallbacksContainer.dart';
import 'package:dots_flameeng_recrtask/game/managers/actors_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class DotsWorld extends World with HasCollisionDetection{

  late final Rect cameraBounds;
  final GameCallbacksContainer _gameCallbacksContainer;

  DotsWorld(this._gameCallbacksContainer);

  @override
  Future<void> onLoad() async{
    await super.onLoad();

    AppLogger.i("Initializing ActorsManager from DotsWorld");
    add(ActorsManager(_gameCallbacksContainer.playerCallbacksContainer));
    add(ScreenHitbox());
  }
}