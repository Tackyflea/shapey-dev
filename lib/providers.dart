// notifier that the text typed changed
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_model.dart';

final scoreChangeProvider = NotifierProvider<ScoreChange, int>(ScoreChange.new);

class ScoreChange extends Notifier<int> {
  @override
  int build() => 0; // initial score

  void increase() => state++;
  void decrease() => state--;
  void reset() => state = 0;
}

class ScoreChangeNotifier extends ChangeNotifier {
  int _score = 0;

  int get score => (_score);

  void set(int score) {
    _score = score;
    debugPrint("SCORE NOW: $_score");
    Future(() {
      notifyListeners();
    });
  }
}
