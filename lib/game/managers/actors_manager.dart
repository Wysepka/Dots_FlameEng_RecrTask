import 'package:dots_flameeng_recrtask/core/app_logger.dart';
import 'package:dots_flameeng_recrtask/game/components/collectible_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/components/dot_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/components/enemy_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/components/player_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/config/game_constants.dart';
import 'package:dots_flameeng_recrtask/game/containers/PlayerCallbacksContainer.dart';
import 'package:dots_flameeng_recrtask/game/dots_game.dart';
import 'package:dots_flameeng_recrtask/game/utility/position_utility.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class ActorsManager extends Component with HasGameReference<DotsGame>{

  List<DotSpriteComponent> _actorsSpawned = [];
  late PlayerSpriteComponent _player;
  final PlayerCallbacksContainer _playerCallbacksContainer;

  ActorsManager(this._playerCallbacksContainer);

  @override
  Future<void> onLoad() async{
    Rect cameraBounds = game.camera.visibleWorldRect;

    AppLogger.i("Spawning Player");
    _player = PlayerSpriteComponent(cameraBounds: cameraBounds , callbacksContainer: _playerCallbacksContainer);
    _actorsSpawned.add(_player);
    add(_player);

    add(TimerComponent(
        period: GameConstants.enemySpawnInterval,
        repeat: true,
        onTick: _spawnEnemyDot
    ));

    add(TimerComponent(
        period: GameConstants.collectibleSpawnInterval,
        repeat: true,
        onTick: _spawnCollectibleDot
    ));
  }

  Vector2 _calculateCollectibleSafePosition(Rect bounds){
    List<DotTransform> dotTransforms = _actorsSpawned.map(
      (component) => DotTransform(
          position: component.position.clone(),
          size: component.size.clone())
    ).toList();


    Vector2 spawnAreaLeftTopCorner = Vector2(bounds.left , bounds.top);
    Vector2 spawnAreaSize = Vector2(bounds.width, bounds.height);
    return PositionUtility.calculateRandomSafePosition(
      spawnAreaPosition: spawnAreaLeftTopCorner,
      spawnAreaSize: spawnAreaSize,
      newDotSize: Vector2.all(GameConstants.enemyStartSize),
      existingDots: dotTransforms,
      safeCircularPosition: _player.position.clone(),
      safeCircularSize: _player.size.x,
    );
  }

  void _spawnEnemyDot(){
    AppLogger.i("Spawning EnemyDot, CurrentActorsCount: ${_actorsSpawned.length}");
    Rect cameraBounds = game.camera.visibleWorldRect;
    DotSpriteComponent enemy = EnemySpriteComponent(_calculateCollectibleSafePosition(cameraBounds) , cameraBounds: cameraBounds);
    _actorsSpawned.add(enemy);
    add(enemy);
  }

  void _spawnCollectibleDot(){
    AppLogger.i("Spawning CollectibleDot, CurrentActorsCount: ${_actorsSpawned.length}");
    Rect cameraBounds = game.camera.visibleWorldRect;
    DotSpriteComponent collectible = CollectibleSpriteComponent(_calculateCollectibleSafePosition(cameraBounds), cameraBounds: cameraBounds);
    _actorsSpawned.add(collectible);
    add(collectible);
  }

  void removeFromSpawnedActors(DotSpriteComponent dotSpriteComponent){
    _actorsSpawned.remove(dotSpriteComponent);
  }

}