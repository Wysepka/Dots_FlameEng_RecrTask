import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_bloc.dart';
import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_event.dart';
import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_state.dart';
import 'package:dots_flameeng_recrtask/core/app_logger.dart';
import 'package:dots_flameeng_recrtask/game/dots_game.dart';
import 'package:dots_flameeng_recrtask/ui/game_over_screen.dart';
import 'package:dots_flameeng_recrtask/ui/game_restart_screen.dart';
import 'package:dots_flameeng_recrtask/ui/game_start_screen.dart';
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
              return _buildScreen(state);
            }
        ),
      ),
    );
  }

  Widget _buildScreen(GameLifecycleState state) {
    AppLogger.i("GameLifecycleBloc changed, current GameLifecycleType value: ${state.lifecycleType}");
    switch (state.lifecycleType) {
      case GameLifecycleType.menu:
        return const GameStartScreen();

      case GameLifecycleType.starting:
        return GameWidget(
          game: DotsGame(),
        );

      case GameLifecycleType.end:
        return const GameOverScreen();

      case GameLifecycleType.restart:
        return const GameRestartScreen();
      case GameLifecycleType.invalid:
        AppLogger.e("GameLifecycleType not initialized, its: ${state.lifecycleType} type");
        return Center(child: CircularProgressIndicator(),);
    }
  }

}