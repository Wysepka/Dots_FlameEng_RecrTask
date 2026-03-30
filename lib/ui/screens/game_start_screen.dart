import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_bloc.dart';
import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_event.dart';
import 'package:dots_flameeng_recrtask/core/app_logger.dart';
import 'package:dots_flameeng_recrtask/ui/widgets/game_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameStartScreen extends StatelessWidget{

  const GameStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          width: 300,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Dots Game" ,
                style: Theme.of(context).textTheme.titleLarge,),
              SizedBox(height: 10,),
              GameButtonWidget(
                  onPressed: () => _onStartButtonPressed(context),
                  text: "Start Game !"
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onStartButtonPressed(BuildContext context){
    AppLogger.i("Start Button pressed, invoking StartGameEvent()");
    context.read<GameLifecycleBloc>().add(StartGameEvent());
  }
  
}