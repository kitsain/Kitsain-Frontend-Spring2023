import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';
import 'package:kitsain_frontend_spring2023/assets/shopping_list_item.dart';
import 'package:kitsain_frontend_spring2023/assets/top_bar.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';
import 'package:kitsain_frontend_spring2023/views/help_pages/user_shopping_list_help_page.dart';
import 'package:kitsain_frontend_spring2023/views/add_forms/add_new_shopping_list_item_form.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';

class UserShoppingList extends StatefulWidget {
  const UserShoppingList({super.key, required this.listIndex});

  final int listIndex;

  @override
  State<UserShoppingList> createState() => _UserShoppingListState();
}

class _UserShoppingListState extends State<UserShoppingList> {
  final _stateController = Get.put(ItemController());

  _receiveItem(String data) {
    _stateController.shoppingLists[widget.listIndex].add(data);

    setState(
      () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$data")));
      },
    );
  }

  _moveSelectedItemsToPantry() {
    // todo (Currently moves all items, not just selected. Needs to be fixed when real model is available.)
    _stateController.pantryList
        .addAll(_stateController.shoppingLists[widget.listIndex]);
    _stateController.shoppingLists[widget.listIndex].clear();
  }

  _deselectAll() {
    // todo
  }

  void _addNewItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: NewShoppingListItemForm(),
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
          child: UserShoppingListHelp(),
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
          addIcon: Image.asset('assets/images/post_add.png'),
          helpFunction: _help,
          backgroundImageName: 'assets/images/shopping_flipped_B1.jpeg',
          titleBackgroundColor: AppColors.titleBackgroundBrown,
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: DragTarget(
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return Text('SHOPPING LISTS', style: AppTypography.category.copyWith(color: Colors.black),);
                    },
                    onMove: (details) {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Icon(Icons.arrow_forward_ios),
                Text('Shopping list ${widget.listIndex + 1}', style: AppTypography.paragraph,),
                // todo: change the title to come from the model
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _deselectAll(),
                  child: Text('DESELECT ALL', style: AppTypography.smallTitle.copyWith(color: Colors.black),),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
            DragTarget<String>(
              onAccept: (data) => _receiveItem(data),
              builder: (context, candidateData, rejectedData) {
                return Obx(
                  () {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _stateController
                          .shoppingLists[widget.listIndex].length,
                      padding: EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ShoppingListItem(
                              itemName: _stateController
                                  .shoppingLists[widget.listIndex][index],
                              itemDescription: 'Additional description',
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            OutlinedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main2),
                backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main1),
              ),
              onPressed: _moveSelectedItemsToPantry,
              child: const Text('ADD ITEMS\nTO PANTRY',
                style: AppTypography.category,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
