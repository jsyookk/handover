class TimeUtils{


  static String fromDateStr(strTime) {
    /// if time is greater than a week {first checks > writtn on memo}
    final diffDays =
        DateTime.parse(strTime).difference(DateTime.now().toUtc()).inDays;

    if (diffDays <= -7) {
      final week = (diffDays ~/ -7).toInt();

      /// calcs Week

      return week.toString().replaceAll('-', '') + 'w';
    } else if (diffDays <= -1 && diffDays > -7) {
      /// return days > still same increment on memo
      return diffDays.toString().replaceAll('-', '') + 'd';
    } else {
      final diffHours =
          DateTime.parse(strTime).difference(DateTime.now().toUtc()).inHours;

      /// if not {third checks > 2° writtn on memo}
      if (diffHours <= -1) {
        return diffHours.toString().replaceAll('-', '') + 'h';
      } else {
        /// if not {last checks > last writtn on memo}
        final diffMin = DateTime.parse(strTime)
            .difference(DateTime.now().toUtc())
            .inMinutes;
        if (diffMin <= -1) {
          return diffMin.toString().replaceAll('-', '') + 'm';
        } else {
          return 'Now';
        }
      }
    }
  }

  static String fromDateTime(DateTime time) {
    /// if time is greater than a week {first checks > writtn on memo}
    final diffDays = time.difference(DateTime.now().toUtc()).inDays;

    if (diffDays <= -7) {
      final week = (diffDays ~/ -7).toInt();

      /// calcs Week

      return week.toString().replaceAll('-', '') + 'w';
    } else if (diffDays <= -1 && diffDays > -7) {
      /// return days > still same increment on memo
      return diffDays.toString().replaceAll('-', '') + 'd';
    } else {
      final diffHours = time.difference(DateTime.now().toUtc()).inHours;

      /// if not {third checks > 2° writtn on memo}
      if (diffHours <= -1) {
        return diffHours.toString().replaceAll('-', '') + 'h';
      } else {
        /// if not {last checks > last writtn on memo}
        final diffMin = time.difference(DateTime.now().toUtc()).inMinutes;
        if (diffMin <= -1) {
          return diffMin.toString().replaceAll('-', '') + 'm';
        } else {
          return 'Now';
        }
      }
    }
  }

  /// Method to parse data even if it is String or DateTime
  /// TimeElapsed().elapsedTimeDynamic(yourDate);
  static String elapsedTimeDynamic(date) {
    if (date.runtimeType == DateTime) {
      return fromDateTime(date);
    } else {
      return fromDateStr(date);
    }
  }

  static String elapsedTimeDDHHMMSS(int ms){
    int seconds = (ms / 1000).toInt();
    int minutes = (seconds / 60).toInt();
    int hours = (minutes / 60).toInt();
    int days = (hours / 24).toInt();

    String timeStr = '${days}d ${hours % 24}h ${minutes % 60}m ${seconds % 60}s';
    return timeStr;
  }

  static Map<String , int> mapElapsedTimeDDHHMMSS(int ms){

    Map<String , int> elapsedTimeMap = Map<String , int>();
    int seconds = (ms / 1000).toInt();
    int minutes = (seconds / 60).toInt();
    int hours = (minutes / 60).toInt();
    int days = (hours / 24).toInt();

    elapsedTimeMap['day'] = days;
    elapsedTimeMap['hours'] = hours % 24;
    elapsedTimeMap['min'] = minutes % 60;
    elapsedTimeMap['sec'] = seconds % 60;

    return elapsedTimeMap;
  }

  static Map<String , int> mapElapsedTimeHHMMSS(int ms){

    Map<String , int> elapsedTimeMap = Map<String , int>();
    int seconds = (ms / 1000).toInt();
    int minutes = (seconds / 60).toInt();
    int hours = (minutes / 60).toInt();
    int days = (hours / 24).toInt();

    hours = hours + (days * 24);

    elapsedTimeMap['hours'] = hours;
    elapsedTimeMap['min'] = minutes;
    elapsedTimeMap['sec'] = seconds;

    return elapsedTimeMap;
  }

}