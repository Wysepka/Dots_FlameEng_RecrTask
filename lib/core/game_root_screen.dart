import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_bloc.dart';
import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_event.dart';
import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_state.dart';
import 'package:dots_flameeng_recrtask/blocs/game_stats/game_stats_bloc.dart';
import 'package:dots_flameeng_recrtask/blocs/game_stats/game_stats_event.dart';
import 'package:dots_flameeng_recrtask/blocs/game_stats/game_stats_state.dart';
import 'package:dots_flameeng_recrtask/core/app_logger.dart';
import 'package:dots_flameeng_recrtask/game/containers/GameCallbacksContainer.dart';
import 'package:dots_flameeng_recrtask/game/containers/PlayerCallbacksContainer.dart';
import 'package:dots_flameeng_recrtask/game/dots_game.dart';
import 'package:dots_flameeng_recrtask/ui/screens/game_over_screen.dart';
import 'package:dots_flameeng_recrtask/ui/screens/game_restart_screen.dart';
import 'package:dots_flameeng_recrtask/ui/screens/game_start_screen.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'enums_container.dart';

class GameRootScreen extends StatelessWidget{

  const GameRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GameLifecycleBloc , GameLifecycleState>(
            builder: (context, state) {
              return _buildScreen(state , context);
            }
        ),
      ),
    );
  }

  Widget _buildScreen(GameLifecycleState state, BuildContext context) {
    AppLogger.i("GameLifecycleBloc changed, current GameLifecycleType value: ${state.lifecycleType}");
    switch (state.lifecycleType) {
      case GameLifecycleType.menu:
        return const GameStartScreen();

      case GameLifecycleType.starting:
        return BlocListener<GameStatsBloc , GameStatsState>(
          listener: (context, state) {
            if (state.currentPlayerLives <= 0) {
              context.read<GameLifecycleBloc>().add(EndGameEvent());
            }
          },
          child: GameWidget(
            game: DotsGame(_initializeGameCallbacksContainer(context)),
          ),
        );

      case GameLifecycleType.end:
        return const GameOverScreen();

      case GameLifecycleType.restart:
        return const GameRestartScreen();
      case GameLifecycleType.restarting:
        context.read<GameStatsBloc>().add(ResetGameStatsEvent());
        context.read<GameLifecycleBloc>().add(MenuGameEvent());
        return Center(child: CircularProgressIndicator(),);
      case GameLifecycleType.invalid:
        AppLogger.e("GameLifecycleType not initialized, its: ${state.lifecycleType} type");
        return Center(child: CircularProgressIndicator(),);
    }
  }

  GameCallbacksContainer _initializeGameCallbacksContainer(BuildContext buildContext){
    GameStatsBloc gameStatsBloc = buildContext.read<GameStatsBloc>();
    GameLifecycleBloc gameLifecycleBloc = buildContext.read<GameLifecycleBloc>();
    final playerCallbacks = PlayerCallbacksContainer(
      onPlayerLivesDecrementCallback: () { gameStatsBloc.add(PlayerHealthDecrementEvent(livesCount: gameStatsBloc.state.currentPlayerLives)); },
      onPlayerScoreIncrement: () { gameStatsBloc.add(PlayerScoreUpEvent(scoreCount: gameStatsBloc.state.currentPlayerScore)); }
    );

    return GameCallbacksContainer(playerCallbacks);
  }

}