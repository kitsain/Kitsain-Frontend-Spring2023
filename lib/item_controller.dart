import 'dart:math';

import 'package:get/get.dart';

class ItemController extends GetxController {
  RxList<String> shoppingBagList = <String>[].obs;
  RxList<String> pantryList = <String>[].obs;
  RxList<String> expiredList = <String>[].obs;
  RxList<String> usedList = <String>[].obs;

  addData() {
    shoppingBagList.add('shopping list 1');
    shoppingBagList.add('shopping list 2');
    shoppingBagList.add('shopping list 3');

    pantryList.add('pantry 1');
    pantryList.add('pantry 2');
    pantryList.add('pantry 3');
    pantryList.add('pantry 4');
    pantryList.add('pantry 5');

    expiredList.add('ITEM NAME 1');
    expiredList.add('ITEM NAME 2');
    expiredList.add('ITEM NAME 3');
    expiredList.add('ITEM NAME 4');
    expiredList.add('ITEM NAME 5');
    expiredList.add('ITEM NAME 6');
    expiredList.add('ITEM NAME 7');
    expiredList.add('ITEM NAME 8');
    expiredList.add('ITEM NAME 9');
    expiredList.add('ITEM NAME 10');

    usedList.add('ITEM NAME 1');
    usedList.add('ITEM NAME 2');
    usedList.add('ITEM NAME 3');
    usedList.add('ITEM NAME 4');
    usedList.add('ITEM NAME 5');
    usedList.add('ITEM NAME 6');
    usedList.add('ITEM NAME 7');
    usedList.add('ITEM NAME 8');
    usedList.add('ITEM NAME 9');
    usedList.add('ITEM NAME 10');
  }
}
