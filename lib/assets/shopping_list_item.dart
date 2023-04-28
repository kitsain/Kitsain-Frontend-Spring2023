import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/controller/task_controller.dart';
import 'package:kitsain_frontend_spring2023/views/edit/edit_shopping_list_item.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';

class ShoppingListItem extends StatefulWidget {
  const ShoppingListItem(
      {super.key,
        required this.itemId,
        required this.itemName,
        this.itemDescription = '',
        required this.itemIndex,
        required this.listId});

  final String itemId;
  final String itemName;
  final String itemDescription;
  final int itemIndex;
  final String listId;

  @override
  State<ShoppingListItem> createState() => _ShoppingListItemState();
}

class _ShoppingListItemState extends State<ShoppingListItem> {
  final taskController = Get.put(TaskController());

  _checkBoxChanged(newValue) {
    setState(() {
      taskController.shoppingListItem.value?[widget.itemIndex].checkBox =
          newValue;
    });
    if (newValue) {
      taskController.tasksListRemove.value?.add(widget.itemIndex);
      taskController.tasksListRemove.value?.sort((a, b) => b.compareTo(a));
      taskController.tasksListRemove.refresh();
    } else {
      taskController.tasksListRemove.value?.remove(widget.itemIndex);
      taskController.tasksListRemove.value?.sort((a, b) => b.compareTo(a));
      taskController.tasksListRemove.refresh();
    }
  }

  _editItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: EditShoppingListItemForm(itemId: widget.itemId, listId: widget.listId, itemIndex: widget.itemIndex),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.greenAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.itemName,
                        style: AppTypography.smallTitle,
                      ),
                      Text(
                        widget.itemDescription, //'Additional description',
                        style: TextStyle(color: Colors.black45),
                        //style: AppTypography.paragraph, todo
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => _editItem(),
                    icon: Icon(Icons.edit),
                  ),
                  Checkbox(
                    value: taskController
                        .shoppingListItem.value?[widget.itemIndex].checkBox,
                    onChanged: (newValue) {
                      _checkBoxChanged(newValue);
                    },
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
