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
            .showSnackBar(SnackBar(content: Text("$data")));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _stateController.shoppingLists.length,
              padding: EdgeInsets.all(15),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    DragTarget<String>(
                      onAccept: (data) => _receiveItem(index, data),
                      builder: (context, candidateData, rejectedData) {
                        return Obx(
                          () {
                            return ListTile(
                              contentPadding: EdgeInsets.all(10),
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
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
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
