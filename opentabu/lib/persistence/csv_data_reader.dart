/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'dart:async';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:opentabu/model/word.dart';

class CSVDataReader {
  static Future<List<Word>> readData(String filePath) async {
    Map<String, Word> _words = {};

    String wordsCSV = await rootBundle.loadString(filePath);

    List<List> words = CsvToListConverter().convert(wordsCSV);

    for (List row in words) {
      var rowList = List<String>.from(row);
      String wordToGuess = rowList[0].toLowerCase().trim();
      if (wordToGuess.isEmpty) continue;
      if (_words.containsKey(wordToGuess)) {
        // if the word is already in the map, add the new tabu
        print(
            "WARNING: ${wordToGuess.toUpperCase()} already in the map, merging the tabus:");
        print("${_words[wordToGuess]!.taboos} + ${rowList.sublist(1)}");
        _words[wordToGuess]!.addTabus(rowList.sublist(1));
        //print("NEW: ${_words[wordToGuess]!.taboos}");
      } else {
        //new word
        _words[wordToGuess] = Word(rowList[0], rowList.sublist(1));
      }
    }

    print("Loaded ${_words.length} unique words from ${filePath}");
    return _words.values.toList();
  }
}
