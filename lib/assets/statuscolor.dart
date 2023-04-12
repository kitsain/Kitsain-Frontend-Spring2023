import 'package:flutter/material.dart';

Color returnColor(DateTime bbdate) {
  DateTime currentDate = DateTime.now();
  if (currentDate.isAfter(bbdate.add(const Duration(days: 1)))) {
    return Colors.black;
  }
  if (bbdate.difference(currentDate).inDays < 1) {
    return const Color(0xFFA66051);
  }
  if (bbdate.difference(currentDate).inDays < 3) {
    return const Color(0xffE3AB4D);
  } else {
    return const Color(0xff779979);
  }
}
