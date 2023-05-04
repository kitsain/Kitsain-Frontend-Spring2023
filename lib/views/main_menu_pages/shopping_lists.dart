import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/assets/top_bar.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';
import 'package:kitsain_frontend_spring2023/views/help_pages/shopping_lists_help_page.dart';
import 'package:kitsain_frontend_spring2023/views/add_forms/add_new_shopping_list_form.dart';

class ShoppingLists extends StatefulWidget {
  const ShoppingLists({super.key, required this.setActiveShoppingListIndex});

  final Function setActiveShoppingListIndex;

  @override
  State<ShoppingLists> createState() => _ShoppingListsState();
}

class _ShoppingListsState extends State<ShoppingLists> {
  final _stateController = Get.put(ItemController());

  _openShoppingList(int index) {
    widget.setActiveShoppingListIndex(index);
  }

  _receiveItem(int index, String data) {
    _stateController.shoppingLists[index].add(data);
    widget.setActiveShoppingListIndex(index);

    setState(
      () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data)));
      },
    );
  }

  void _addNewItem() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return const FractionallySizedBox(
            heightFactor: 0.7,
            child: NewShoppingListForm(),
          );
        },
      );
  }

  void _help() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          //heightFactor: 0.7,
          child: ShoppingListsHelp(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
          // title: AppLocalizations.of(context)!.shoppingListsScreenTopBarTitle,
          title: 'Shopping lists',
          addFunction: _addNewItem,
          addIcon: Image.asset('assets/images/post_add.png',
            fit: BoxFit.cover,
            color: Colors.white,
          ),
          helpFunction: _help,
          backgroundImageName: 'assets/images/aisle-3105629_1280_B1.jpg',
          titleBackgroundColor: AppColors.titleBackgroundBrown,
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _stateController.shoppingLists.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    DragTarget<String>(
                      onAccept: (data) => _receiveItem(index, data),
                      builder: (context, candidateData, rejectedData) {
                        return Obx(
                          () {
                            return ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              minVerticalPadding: 10,
                              tileColor: Colors.lightGreen,
                              title:
                                  Text(_stateController.shoppingBagList[index]),
                              onTap: () => _openShoppingList(index),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
