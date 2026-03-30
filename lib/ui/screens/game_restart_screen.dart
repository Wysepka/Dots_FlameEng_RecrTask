import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_bloc.dart';
import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_event.dart';
import 'package:dots_flameeng_recrtask/core/app_logger.dart';
import 'package:dots_flameeng_recrtask/ui/widgets/game_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameRestartScreen extends StatelessWidget{

  const GameRestartScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            Text("Restart Game" , style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10,),
            GameButtonWidget(
                onPressed: () => _onRestartButtonClicked(context),
                text: "Restart"
            ),
          ],
        ),
      ),
    );
  }

  void _onRestartButtonClicked(BuildContext context){
    AppLogger.i("Restart button clicked , restarting Lifecycle event started");
    context.read<GameLifecycleBloc>().add(RestartingGameEvent());
  }

}