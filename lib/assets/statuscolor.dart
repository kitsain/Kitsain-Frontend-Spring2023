import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color returnColor(DateTime bbdate) {
  DateTime currentDate = DateTime.now();
  if (currentDate.isAfter(bbdate.add(const Duration(days: 1)))) {
    return const Color(0xff1C1311);
  }
  if (bbdate.difference(currentDate).inDays < 1) {
    return const Color(0xFFA66051);
  }
  if (bbdate.difference(currentDate).inDays < 7) {
    return const Color(0xffE3AB4D);
  } else {
    return const Color(0xff5C785E);
  }
}

String getAbbreviation(DateTime bbdate) {
  List<String> list = [];
  DateTime currentDate = DateTime.now();
  if (bbdate.difference(currentDate).inDays < 7) {
    String abbreviation = DateFormat(DateFormat.ABBR_WEEKDAY).format(bbdate);
    for (var rune in abbreviation.runes) {
      list.add(String.fromCharCode(rune));
    }
    return abbreviation;
  } else {
    return "";
  }
}
