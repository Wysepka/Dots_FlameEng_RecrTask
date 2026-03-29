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

    DotSpriteComponent enemy = EnemySpriteComponent(cameraBounds: game.camera.visibleWorldRect, initialPosition:  calculateEnemySafePosition(cameraBounds));
    actorsSpawned.add(enemy);
    
    add(enemy);
  }

  Vector2 calculateEnemySafePosition(Rect bounds){
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

}