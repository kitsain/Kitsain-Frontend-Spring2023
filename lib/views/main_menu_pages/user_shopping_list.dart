import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';

class UserShoppingList extends StatefulWidget {
  const UserShoppingList({super.key, required this.listIndex});
  final int listIndex;

  @override
  State<UserShoppingList> createState() => _UserShoppingListState();
}

class _UserShoppingListState extends State<UserShoppingList> {
  final _stateController = Get.put(ItemController());

  _receiveItem(String data) {
    _stateController.shoppingBagList.add(data);

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
      body: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text('SHOPPING LISTS'),
              ),
              Icon(Icons.arrow_forward_ios),
              Text('Shopping list ${widget.listIndex + 1}'), // todo: change the title to come from the model
            ],
          ),
          DragTarget<String>(
            onAccept: (data) => _receiveItem(data),
            builder: (context, candidateData, rejectedData) {
              return Obx(
                () {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _stateController.shoppingLists.length,
                    padding: EdgeInsets.all(5),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.all(10),
                            minVerticalPadding: 10,
                            tileColor: Colors.lightGreen,
                            title: Text(_stateController
                                .shoppingLists[widget.listIndex][index]),
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
        ],
      ),
    );
  }
}