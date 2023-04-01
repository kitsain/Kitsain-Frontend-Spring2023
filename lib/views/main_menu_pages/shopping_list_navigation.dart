import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/user_shopping_list.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/shopping_lists.dart';


class ShoppingListNavigation extends StatefulWidget {
  const ShoppingListNavigation({super.key});

  @override
  State<ShoppingListNavigation> createState() => _ShoppingListNavigationState();
}

class _ShoppingListNavigationState extends State<ShoppingListNavigation> {
  final StateController = Get.put(ItemController());

  String activeList = '';
  int activeShoppingListIndex = 0;
  
  setActiveShoppingListIndex(index) {
    setState(() {
      activeShoppingListIndex = index;
      activeList = index.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        pages: [
          MaterialPage(child: ShoppingLists(setActiveShoppingListIndex: setActiveShoppingListIndex)),
          if (activeList != '') MaterialPage(child: UserShoppingList(listIndex: activeShoppingListIndex,)),
        ],
      ),
    );
  }
}