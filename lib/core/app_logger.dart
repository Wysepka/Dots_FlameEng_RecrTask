import 'package:logger/logger.dart';

class AppLogger{
  static String prefix = "DOTS GAME";

  static final Logger instance = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 100,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  //Shortcuts for faster access
  static void d(dynamic message) => instance.d('[$prefix] $message');
  static void i(dynamic message) => instance.i('[$prefix] $message');
  static void w(dynamic message) => instance.w('[$prefix] $message');
  static void e(dynamic message, [Object? error, StackTrace? stackTrace]) =>
      instance.e('[$prefix]' '$message', error: error, stackTrace: stackTrace);
}