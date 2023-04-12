import 'package:flutter/material.dart';

Color returnColor(DateTime bbdate) {
  DateTime currentDate = DateTime.now();
  if (currentDate.isAfter(bbdate.add(const Duration(days: 1)))) {
    return Colors.red;
  }
  if (bbdate.difference(currentDate).inDays < 1) {
    return Colors.orange;
  }
  if (bbdate.difference(currentDate).inDays < 3) {
    return Colors.yellow;
  } else {
    return Colors.green;
  }
}
