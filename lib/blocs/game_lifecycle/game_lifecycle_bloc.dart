import 'package:dots_flameeng_recrtask/core/enums_container.dart';
import 'game_lifecycle_event.dart';
import 'game_lifecycle_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameLifecycleBloc extends Bloc<GameLifecycleEvent, GameLifecycleState>{
  GameLifecycleBloc() :
        super(const GameLifecycleState(
          lifecycleType:  GameLifecycleType.menu
        )){
    on<MenuGameEvent>((event,emit){
      emit(GameLifecycleState(lifecycleType: GameLifecycleType.menu));
    });
    on<StartGameEvent>((event, emit){
      emit(GameLifecycleState(lifecycleType: GameLifecycleType.starting));
    });
    on<EndGameEvent>((event,emit){
      emit(GameLifecycleState(lifecycleType: GameLifecycleType.end));
    });
    on<RestartGameEvent>((event, emit){
      emit(GameLifecycleState(lifecycleType: GameLifecycleType.restart));
    });
    on<RestartingGameEvent>((event, emit){
      emit(GameLifecycleState(lifecycleType: GameLifecycleType.restarting));
    });
  }

}