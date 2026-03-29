import 'package:dots_flameeng_recrtask/game/components/collectible_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/components/dot_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/components/enemy_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/components/player_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/config/game_constants.dart';
import 'package:dots_flameeng_recrtask/game/dots_game.dart';
import 'package:dots_flameeng_recrtask/game/utility/position_utility.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class ActorsManager extends Component with HasGameReference<DotsGame>{

  List<DotSpriteComponent> actorsSpawned = [];
  late PlayerSpriteComponent player;

  @override
  Future<void> onLoad() async{
    Rect cameraBounds = game.camera.visibleWorldRect;

    player = PlayerSpriteComponent(cameraBounds: cameraBounds);
    actorsSpawned.add(player);
    add(player);

    add(TimerComponent(
        period: GameConstants.enemySpawnInterval,
        repeat: true,
        onTick: spawnEnemyDot
    ));

    add(TimerComponent(
        period: GameConstants.collectibleSpawnInterval,
        repeat: true,
        onTick: spawnCollectibleDot
    ));
  }

  Vector2 calculateCollectibleSafePosition(Rect bounds){
    List<DotTransform> dotTransforms = actorsSpawned.map(
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
      safeCircularPosition: player.position.clone(),
      safeCircularSize: player.size.x,
    );
  }

  void spawnEnemyDot(){
    Rect cameraBounds = game.camera.visibleWorldRect;
    DotSpriteComponent enemy = EnemySpriteComponent(calculateCollectibleSafePosition(cameraBounds) , cameraBounds: cameraBounds);
    actorsSpawned.add(enemy);
    add(enemy);
  }

  void spawnCollectibleDot(){
    Rect cameraBounds = game.camera.visibleWorldRect;
    DotSpriteComponent collectible = CollectibleSpriteComponent(calculateCollectibleSafePosition(cameraBounds), cameraBounds: cameraBounds);
    actorsSpawned.add(collectible);
    add(collectible);
  }

}