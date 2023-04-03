import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/assets/consts.dart' as constants;

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
  }

  // if (bbdate.isAfter(currentDate.add(const Duration(days: 1)))) {
  //   return Colors.orange;
  // }
  // if (bbdate.isAfter(currentDate.add(const Duration(days: 3)))) {
  //   return Colors.yellow;
  // }
  else {
    return Colors.green;
  }
}
