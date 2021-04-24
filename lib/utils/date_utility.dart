import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateUtility {
  final DateTime _dateTime;
  DateUtility(this._dateTime);

  String toDateFormatted() {
    initializeDateFormatting("ja_JP");
    var formatter = DateFormat('yyyy/MM/dd(E)', "ja_JP");
    var formatted = formatter.format(_dateTime); // DateからString
    return formatted;
  }
}
