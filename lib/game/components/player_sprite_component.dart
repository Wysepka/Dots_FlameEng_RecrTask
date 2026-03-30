import 'package:dots_flameeng_recrtask/core/app_logger.dart';
import 'package:dots_flameeng_recrtask/game/components/collectible_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/components/dot_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/components/enemy_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/config/game_constants.dart';
import 'package:dots_flameeng_recrtask/game/containers/PlayerCallbacksContainer.dart';
import 'package:dots_flameeng_recrtask/game/utility/position_utility.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class PlayerSpriteComponent extends DotSpriteComponent with DragCallbacks , CollisionCallbacks{

  PlayerCallbacksContainer _callbacksContainer;
  bool _collidedWithEnemyCooldown = false;
  late final CircleHitbox _hitbox;

  PlayerSpriteComponent({super.position ,required super.cameraBounds , required PlayerCallbacksContainer callbacksContainer})
      : _callbacksContainer = callbacksContainer, super(dotDiameter: GameConstants.playerStartSize);

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    sprite = await Sprite.load('components/actors/yellow_player_sprite.png');

    _hitbox = CircleHitbox(
        radius: dotDiameter / 2,
        collisionType: CollisionType.active
    );

    add(_hitbox);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    position = PositionUtility.getCameraBoundsClampedPosition(position += event.canvasDelta, size, anchor, game.camera.visibleWorldRect);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    AppLogger.i("Collided with ${other.runtimeType.toString()}");

    if(other is EnemySpriteComponent && !other.isDead && !_collidedWithEnemyCooldown){
      _callbacksContainer.onPlayerLivesDecrementCallback();
      other.onPlayerCollided();
      _collidedWithEnemyCooldown = true;

      opacity = 0.5;

      add(TimerComponent(
          period: GameConstants.enemyCollisionInterval,
          repeat: false,
          onTick: () => _removeFromCollidedCache(other)
      ));
    }
    if(other is CollectibleSpriteComponent && !other.isDead){
      _callbacksContainer.onPlayerScoreIncrement();
      other.onPlayerCollided();
      _collidedWithCollectible();
    }
  }

  void _removeFromCollidedCache(EnemySpriteComponent enemy){
    AppLogger.i("Collided with enemy, setting collision with enemies on cooldown");
    _collidedWithEnemyCooldown = false;
    opacity = 1;
  }

  void _collidedWithCollectible(){
    AppLogger.i("Collided with collectible, player increasing in size");
    size *= GameConstants.collectiblePlayerIncreaseSizeMutliplier;
    _hitbox.radius = size.x / 2;
  }

}