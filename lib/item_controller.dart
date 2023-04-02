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

    expiredList.add('expired item 1');
    expiredList.add('expired item 2');
    expiredList.add('expired item 3');
    expiredList.add('expired item 4');
    expiredList.add('expired item 5');
    expiredList.add('expired item 6');
    expiredList.add('expired item 7');
    expiredList.add('expired item 8');
    expiredList.add('expired item 9');
    expiredList.add('expired item 10');

    usedList.add('used item 1');
    usedList.add('used item 2');
    usedList.add('used item 3');
    usedList.add('used item 4');
    usedList.add('used item 5');
    usedList.add('used item 6');
    usedList.add('used item 7');
    usedList.add('used item 8');
    usedList.add('used item 9');
    usedList.add('used item 10');
  }
}
