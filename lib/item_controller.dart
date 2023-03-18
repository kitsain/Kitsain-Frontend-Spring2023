import 'package:get/get.dart';

class ItemController extends GetxController {
  RxList<String> shoppingBagList = <String>[].obs;
  RxList<String> pantryList = <String>[].obs;

  addData() {
    shoppingBagList.add('shopping list 1');
    shoppingBagList.add('shopping list 2');
    shoppingBagList.add('shopping list 3');

    pantryList.add('pantry 1');
    pantryList.add('pantry 2');
    pantryList.add('pantry 3');
    pantryList.add('pantry 4');
    pantryList.add('pantry 5');
  }
}
