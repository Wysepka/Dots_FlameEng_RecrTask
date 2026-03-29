import 'package:dots_flameeng_recrtask/game/components/player_sprite_component.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class DotsWorld extends World{

  late final Rect cameraBounds;

  @override
  Future<void> onLoad() async{
    await super.onLoad();

    add(PlayerSpriteComponent(position: Vector2.zero() , cameraBounds: cameraBounds));
  }
}