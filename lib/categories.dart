import 'package:flutter/material.dart';

class Categories {
  static List<Image> categoryImages = [
    'assets/images/meals.png', // new
    'assets/images/proteins.png',
    'assets/images/proteins.png', // seafood
    'assets/images/fruits.png',
    'assets/images/vegetables.png',
    'assets/images/frozen.png',
    'assets/images/drinks.png',
    'assets/images/drinks.png', // bread
    'assets/images/treats.png',
    'assets/images/dairy.png',
    'assets/images/meals.png',
    'assets/images/meals.png', // dry n canned goods
    'assets/images/meals.png', // other
  ].map((assetString) => Image.asset(assetString)).toList();

  static Map<int, String> categoriesByIndex = {
    1: 'New',
    2: 'Meat',
    3: 'Seafood',
    4: 'Fruit',
    5: 'Vegetables',
    6: 'Frozen',
    7: 'Drinks',
    8: 'Bread',
    9: 'Treats',
    10: 'Dairy',
    11: 'Ready meals',
    12: 'Dry & canned goods',
    13: 'Other'
  };
}