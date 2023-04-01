import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';

class ShoppingLists extends StatefulWidget {
  const ShoppingLists({super.key, required this.setActiveShoppingListIndex});
  final Function setActiveShoppingListIndex;

  @override
  State<ShoppingLists> createState() => _ShoppingListsState();
}

class _ShoppingListsState extends State<ShoppingLists> {
  final StateController = Get.put(ItemController());

  _openShoppingList(int index) {
    widget.setActiveShoppingListIndex(index);
  }

  _receiveItem(String data) {
    StateController.shoppingBagList.add(data);

    setState(
      () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$data")));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DragTarget<String>(
        onAccept: (data) => _receiveItem(data),
        builder: (context, candidateData, rejectedData) {
          return Obx(
            () {
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: StateController.shoppingLists.length,
                padding: EdgeInsets.all(5),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.all(10),
                        minVerticalPadding: 10,
                        tileColor: Colors.lightGreen,
                        title: Text(StateController.shoppingBagList[index]),
                        onTap: () => _openShoppingList(index),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
