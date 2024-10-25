import 'dart:async';

Future waitWhile(bool Function() test, [Duration interval = Duration.zero]) {
  var completer = Completer();
  check() {
    if (!test()) {
      completer.complete();
    } else {
      Timer(interval, check);
    }
  }

  check();
  return completer.future;
}
