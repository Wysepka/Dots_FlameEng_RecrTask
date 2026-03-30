import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_bloc.dart';
import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_event.dart';
import 'package:dots_flameeng_recrtask/blocs/game_stats/game_stats_bloc.dart';
import 'package:dots_flameeng_recrtask/core/app_logger.dart';
import 'package:dots_flameeng_recrtask/ui/widgets/game_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameOverScreen extends StatelessWidget{
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GameStatsBloc gameStatsBloc = context.read<GameStatsBloc>();

    return Center(
      child: Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Game Over" , style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10,),
            Text("Points: ${gameStatsBloc.state.currentPlayerScore}" ),
            SizedBox(height: 10,),
            GameButtonWidget(
                onPressed: () => _onContinueButtonClicked(context),
                text: "Continue"
            ),
          ],
        ),
      ),
    );
  }

  void _onContinueButtonClicked(BuildContext context){
    AppLogger.i("Continue button clicked , restart game event started");
    GameLifecycleBloc gameLifecycleBloc = context.read<GameLifecycleBloc>();
    gameLifecycleBloc.add(RestartGameEvent());
  }

}