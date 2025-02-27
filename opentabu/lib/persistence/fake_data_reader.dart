/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */
import 'package:speakeasy/model/word.dart';
import 'package:speakeasy/persistence/data_reader.dart';

class FakeDataReader extends DataReader {
  get words {
    return [
      new Word("Train", ["Fast", "Rails", "Station"]),
      new Word("Boat", ["Slow", "Sea", "Harbor"])
    ];
  }
}
