import 'package:dots_flameeng_recrtask/blocs/game_stats/game_stats_event.dart';
import 'package:dots_flameeng_recrtask/blocs/game_stats/game_stats_state.dart';
import 'package:dots_flameeng_recrtask/game/config/game_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameStatsBloc extends Bloc<GameStatsEvent, GameStatsState>{
  GameStatsBloc()
    : super(const GameStatsState(GameConstants.playerStartLivesCount, 0)){
    on<PlayerHealthDown>((event, emit){
      emit(GameStatsState(1, 1));
    });
  }

}