import 'package:dots_flameeng_recrtask/blocs/game_stats/game_stats_event.dart';
import 'package:dots_flameeng_recrtask/blocs/game_stats/game_stats_state.dart';
import 'package:dots_flameeng_recrtask/game/config/game_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameStatsBloc extends Bloc<GameStatsEvent, GameStatsState>{
  GameStatsBloc()
    : super(const GameStatsState(GameConstants.playerStartLivesCount, 0)){
    on<PlayerHealthDecrementEvent>((event, emit){
      emit(GameStatsState(state.currentPlayerLives - 1, state.currentPlayerScore));
    });
    on<PlayerScoreUpEvent>((event, emit){
      emit(GameStatsState(state.currentPlayerLives, state.currentPlayerScore + GameConstants.collectibleScoreValue));
    });
    on<ResetGameStatsEvent>((event, emit){
      emit(GameStatsState(GameConstants.playerStartLivesCount, 0));
    });
  }

}