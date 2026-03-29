import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_bloc.dart';
import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_event.dart';
import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_state.dart';
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
          color: Colors.grey,
          width: 300,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Dots Game" ,
                style: Theme.of(context).textTheme.titleLarge,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                child: TextButton(
                  onPressed:() {
                    context.read<GameLifecycleBloc>().add(
                        StartGameEvent()
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    textStyle: const TextStyle(fontSize: 22),
                  ),
                  child: Text("Start Game !"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}