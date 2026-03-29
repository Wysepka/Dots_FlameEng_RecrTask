import 'package:dots_flameeng_recrtask/game/components/player_sprite_component.dart';
import 'package:dots_flameeng_recrtask/game/managers/actors_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class DotsWorld extends World with HasCollisionDetection{

  late final Rect cameraBounds;

  @override
  Future<void> onLoad() async{
    await super.onLoad();

    add(ActorsManager());
    add(ScreenHitbox());
  }
}