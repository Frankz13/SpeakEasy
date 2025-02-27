import 'package:speakeasy/main.dart';

class AnalyticsController {
  static const String kStartedMatchesKey = "started_matches";

  static int getStartedMatches() => _getVal(kStartedMatchesKey);

  static Future addNewMatch() async => await _increaseSP(kStartedMatchesKey);

  //---------

  static const String kSkipUsedKey = "skip_used";

  static int getSkipUsed() => _getVal(kSkipUsedKey);

  static Future addNewSkip() async => await _increaseSP(kSkipUsedKey);

  //---------

  static const String kCorrectAnswersKey = "correct_answers";

  static int getCorrectAnswers() => _getVal(kCorrectAnswersKey);

  static Future addCorrectAnswer() async =>
      await _increaseSP(kCorrectAnswersKey);

  //---------

  static const String kWrongAnswersKey = "wrong_answers";

  static int getWrongAnswers() => _getVal(kWrongAnswersKey);

  static Future addWrongAnswer() async => await _increaseSP(kWrongAnswersKey);

  //---------

  static int _getVal(String key) {
    return prefs.getInt(key) ?? 0;
  }

  static Future _increaseSP(String key) async {
    await prefs.setInt(key, (prefs.getInt(key) ?? 0) + 1);
  }

  static Future _decreaseSP(String key) async {
    await prefs.setInt(key, (prefs.getInt(key) ?? 0) + 1);
  }
}
