/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:opentabu/controller/gameController.dart';
import 'package:opentabu/model/settings.dart';
import 'package:opentabu/model/word.dart';

class GamePage extends StatefulWidget {
  VoidCallback _backToTheHome;

  final Settings _settings;
  final List<Word> _words;

  GamePage(this._settings, this._words, this._backToTheHome);

  @override
  State<StatefulWidget> createState() {
    return new GamePageState(_settings, _words, _backToTheHome);
  }
}

class GamePageState extends State<GamePage> {
  VoidCallback _backToTheHome;

  GameController _gameController;
  Timer turnTimer;
  int secondsTimer;

  //info to show:
  Map<String, int> matchInfo; //team name, score

  GamePageState(Settings settings, List<Word> words, this._backToTheHome) {
    _gameController = new GameController(settings, words);
    secondsTimer = settings.turnDurationInSeconds;
    initTimer();
  }

  void initTimer() {
    turnTimer = new Timer(new Duration(seconds: secondsTimer), timeOut);
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Column(
        children: <Widget>[_gameInfo, new Divider(), _turns, _word, new Divider(height: 10.0), _buttons],
      ),
    );
  }

  get _turns {
    return new Center(
      child: new Text(
        "Turn " + (_gameController.currentTurn).toString(),
        style: new TextStyle(fontSize: 18.0, color: Colors.black54),
      ),
    );
  }

  get _gameInfo {
    List<Widget> teams = new List<Widget>();

    for (int i = 0; i < _gameController.numberOfPlayers; i++) {
      teams.add(new Expanded(
          child: new Column(
        children: <Widget>[
          new Text(
            "Team " + (i + 1).toString(),
            style: new TextStyle(fontSize: 15.0, color: _gameController.currentTeam == i ? Colors.red : Colors.black),
          ),
          new Text(
            _gameController.scores[i].toString(),
            style: new TextStyle(fontSize: 28.0),
          )
        ],
      )));
    }

    return new Padding(
      padding: new EdgeInsets.all(8.0),
      child: new Column(
        children: <Widget>[
          new Row(
            children: teams,
          )
        ],
      ),
    );
  }

  get _word {
    List<Widget> taboos = new List<Widget>();

    for (String taboo in _gameController.currentWord.taboos) {
      taboos.add(new Text(
        taboo,
        style: new TextStyle(fontSize: 30.0),
      ));
    }

    return new Expanded(
        child: new Container(
      padding: new EdgeInsets.all(15.0),
      child: new Column(
        children: <Widget>[
          new Padding(
              padding: new EdgeInsets.symmetric(vertical: 20.0),
              child: new Text(
                _gameController.currentWord.wordToGuess,
                style: new TextStyle(fontSize: 60.0),
              )),
          new Column(children: taboos)
        ],
      ),
    ));
  }

  get _buttons {
    return new Padding(
      padding: new EdgeInsets.all(15.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new IconButton(
                  icon: new Icon(Icons.done, color: Colors.lightGreen),
                  iconSize: 70.0,
                  onPressed: () => _buttonHandler(true))),
          new FlatButton(
              child: new Text(
                _gameController.skipLeftCurrentTeam.toString() + " SKIP",
                style: new TextStyle(fontSize: 20.0),
              ),
              onPressed: _gameController.skipLeftCurrentTeam == 0 ? null : () => _buttonHandler(null)),
          new Expanded(
              child: new IconButton(
                  icon: new Icon(Icons.close, color: Colors.red),
                  iconSize: 70.0,
                  onPressed: () => _buttonHandler(false)))
        ],
      ),
    );
  }

  void _buttonHandler(bool isRight) {
    setState(() {
      if (isRight == null)
        _gameController.skipAnswer();
      else
        isRight ? _gameController.rightAnswer() : _gameController.wrongAnswer();
    });
  }

  void timeOut() {
    Text title;
    Text button;

    bool end = _gameController.changeTurn();

    //Check if it's the end
    if (end) {
      title = new Text("Team " + _gameController.winner.toString() + " win!");
      button = new Text('Main menu');
    } else {
      title = new Text("Ready for the next turn?");
      button = new Text('Start!');
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      child: new AlertDialog(title: title, actions: <Widget>[
        new FlatButton(
          child: button,
          onPressed: () {
            //Close the dialog
            Navigator.of(context).pop();

            //Check if it's the end
            if (end)
              _backToTheHome();
            else
              initTimer();
            setState(null);
          },
        ),
      ]),
    );
  }
}
