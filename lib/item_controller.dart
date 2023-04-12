import 'package:get/get.dart';

class ItemController extends GetxController {
  RxList<String> shoppingBagList = <String>[].obs;
  RxList<String> pantryList = <String>[].obs;

  RxList<List<String>> shoppingLists = <List<String>>[].obs;
  RxList<String> shoppingList1 = <String>[].obs;
  RxList<String> shoppingList2 = <String>[].obs;

  addData() {
    shoppingBagList.add('shopping list 1');
    shoppingBagList.add('shopping list 2');
    shoppingBagList.add('shopping list 3');

    pantryList.add('pantry 1');
    pantryList.add('pantry 2');
    pantryList.add('pantry 3');
    pantryList.add('pantry 4');
    pantryList.add('pantry 5');
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

    shoppingLists.add(shoppingList1);
    shoppingLists.add(shoppingList2);

    shoppingList1.add('Shopping list 1 - item 1');
    shoppingList1.add('Shopping list 1 - item 2');
    shoppingList1.add('Shopping list 1 - item 3');

    shoppingList2.add('Shopping list 2 - item 1');
    shoppingList2.add('Shopping list 2 - item 2');
    shoppingList2.add('Shopping list 2 - item 3');
  }
}
