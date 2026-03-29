import 'package:dots_flameeng_recrtask/blocs/game_lifecycle/game_lifecycle_bloc.dart';
import 'package:dots_flameeng_recrtask/core/app_logger.dart';
import 'package:dots_flameeng_recrtask/core/game_root_screen.dart';
import 'package:dots_flameeng_recrtask/ui/game_start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const DotsApp());
}

class DotsApp extends StatelessWidget {
  const DotsApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    AppLogger.prefix = "DOTS GAME";

    return MultiBlocProvider(
      providers: [
        BlocProvider<GameLifecycleBloc>(
            create: (_) => GameLifecycleBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter/FlameEngine Dots Game',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const GameRootScreen(),
      ),
    );
  }
}
