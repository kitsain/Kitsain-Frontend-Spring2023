import 'dart:math';

import 'package:get/get.dart';

class ItemController extends GetxController {
  RxList<String> shoppingBagList = <String>[].obs;
  RxList<String> pantryList = <String>[].obs;
  RxList<String> expiredList = <String>[].obs;
  RxList<String> usedList = <String>[].obs;

  RxList<List<String>> shoppingLists = <List<String>>[].obs;
  RxList<String> shoppingList1 = <String>[].obs;
  RxList<String> shoppingList2 = <String>[].obs;

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

    expiredList.add('EXPIRED 1');
    expiredList.add('EXPIRED 2');
    expiredList.add('EXPIRED 3');
    expiredList.add('EXPIRED 4');
    expiredList.add('EXPIRED 5');
    expiredList.add('EXPIRED 6');
    expiredList.add('EXPIRED 7');
    expiredList.add('EXPIRED 8');
    expiredList.add('EXPIRED 9');
    expiredList.add('EXPIRED 10');

    usedList.add('USED 1');
    usedList.add('USED 2');
    usedList.add('USED 3');
    usedList.add('USED 4');
    usedList.add('USED 5');
    usedList.add('USED 6');
    usedList.add('USED 7');
    usedList.add('USED 8');
    usedList.add('USED 9');
    usedList.add('USED 10');

    pantryList.add('pantry 6');
    pantryList.add('pantry 7');
    pantryList.add('pantry 8');
    pantryList.add('pantry 9');
    pantryList.add('pantry 10');
    pantryList.add('pantry 11');
    pantryList.add('pantry 12');
    pantryList.add('pantry 13');
    pantryList.add('pantry 14');
    pantryList.add('pantry 15');
    pantryList.add('pantry 16');
    pantryList.add('pantry 17');
    pantryList.add('pantry 18');

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

    shoppingLists.add(shoppingList1);
    shoppingLists.add(shoppingList2);
    shoppingLists.add(shoppingList2);
    shoppingLists.add(shoppingList2);
    shoppingLists.add(shoppingList2);
    shoppingLists.add(shoppingList2);
    shoppingLists.add(shoppingList2);
    shoppingLists.add(shoppingList2);

    shoppingList1.add('Shopping list 1 - item 1');
    shoppingList1.add('Shopping list 1 - item 2');
    shoppingList1.add('Shopping list 1 - item 3');

    shoppingList2.add('Shopping list 2 - item 1');
    shoppingList2.add('Shopping list 2 - item 2');
    shoppingList2.add('Shopping list 2 - item 3');
  }
}
