/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */

import 'dart:math';

import 'package:speakeasy/model/word.dart';

class Game {
  final List<Word> _words;
  int _wordIndex = 0;
  final nSkips;

  List<int> _scores = [];
  List<int> _skips = [];

  Game(this._words, {int nTeams = 2, this.nSkips}) {
    _words.shuffle();

    for (int i = 0; i < nTeams; i++) {
      //set every team score to 0
      _scores.add(0);

      //set every skip to nSkips
      _skips.add(nSkips);
    }
  }

  get newWord {
    _wordIndex++;

    //TODO actually if it's the end, starts again from 0
    if (_wordIndex == _words.length) {
      _wordIndex = 0;
      _words.shuffle();
    }

    return _words[_wordIndex];
  }

  void rightAnswer(int teamNumber) {
    _scores[teamNumber]++;
  }

  void wrongAnswer(int teamNumber) {
    if(_scores[teamNumber] > 0) _scores[teamNumber]--;
  }

  bool useSkip(int teamNumber) {
    if (_skips[teamNumber] == 0) return false;

    _skips[teamNumber]--;
    return true;
  }

  int getSkipLeft(int teamNumber) => _skips[teamNumber];

  void resetSkip() {
    //reset the skips of everyone
    for (int i = 0; i < _skips.length; i++) {
      //set every skip to nSkips
      _skips[i] = nSkips;
    }
  }

  List<int> get winners {
    int highestScore = _scores.reduce(max);

    List<int> winners = [];
    for (int i = 0; i < _scores.length; i++) {
      //Note: team number is index+1
      if (_scores[i] == highestScore) winners.add(i + 1);
    }

    assert(winners.isNotEmpty);
    return winners;
  }

  List<int> get scores => _scores;

  int get numberOfPlayers => _scores.length;
}
