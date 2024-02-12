import 'package:flutter/material.dart';

class Categoriesr {
  static List<Image> categoryImages = [
    'assets/images/meals.png', // new
    'assets/images/proteins.png',
    'assets/images/proteins.png', // seafood
    'assets/images/fruits.png'
  ].map((assetString) => Image.asset(assetString)).toList();

  static Map<int, String> categoriesByIndex = {
    1: 'Weekend',
    2: 'Weekdays',
    3: 'Holidays',
    4: 'Quick recipes'
  };
}
