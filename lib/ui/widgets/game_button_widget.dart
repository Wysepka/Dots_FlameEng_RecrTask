import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameButtonWidget extends StatelessWidget{

  final VoidCallback _onPressed;
  final String _text;

  const GameButtonWidget({required void Function() onPressed,required String text, super.key}) : _text = text, _onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontSize: 22),
      ),
      child: Text(_text)
    );
  }

}