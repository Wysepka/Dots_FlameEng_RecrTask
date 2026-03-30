import 'package:flutter/material.dart';

class PlayerCallbacksContainer{
  final VoidCallback onPlayerLivesDecrementCallback;
  final VoidCallback onPlayerScoreIncrement;

  const PlayerCallbacksContainer({required this.onPlayerLivesDecrementCallback ,required this.onPlayerScoreIncrement});
}