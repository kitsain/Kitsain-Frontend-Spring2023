import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/controller/task_controller.dart';

class ShoppingListItem extends StatefulWidget {
  const ShoppingListItem(
      {super.key,
      required this.itemName,
      this.itemDescription = '',
      required this.indexToRemove});

  final String itemName;
  final String itemDescription;
  final int indexToRemove;

  @override
  State<ShoppingListItem> createState() => _ShoppingListItemState();
}

class _ShoppingListItemState extends State<ShoppingListItem> {
  bool? _selected = false;
  final taskController = Get.put(TaskController());

  _checkBoxChanged(newValue) {
    // print('ppp');
    setState(() {
      _selected = newValue;
    });
    if (newValue) {
      print(newValue);
      taskController.tasksListRemove.value?.add(widget.indexToRemove);
      taskController.tasksListRemove.refresh();
    } else {
      print(newValue);
      taskController.tasksListRemove.value?.remove(widget.indexToRemove);
      taskController.tasksListRemove.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.itemName),
                  Text(
                    widget.itemDescription, //'Additional description',
                    style: TextStyle(color: Colors.black45),
                  ),
                ],
              ),
              Spacer(),
              Checkbox(
                  value: _selected,
                  onChanged: (newValue) {
                    // print('ok');
                    _checkBoxChanged(newValue);

                    taskController.tasksListRemove.value?.forEach((element) {
                      print('pp  $element');
                    });
                    print('ok');
                  }),
            ],
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}
