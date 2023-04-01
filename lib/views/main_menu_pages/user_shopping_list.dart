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
    _stateController.shoppingLists[widget.listIndex].add(data);

    setState(
      () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$data")));
      },
    );
  }

  _moveSelectedItemsToPantry() {
    // todo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      return Text('SHOPPING LISTS');
                    },
                    onMove: (details) {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Icon(Icons.arrow_forward_ios),
                Text('Shopping list ${widget.listIndex + 1}'),
                // todo: change the title to come from the model
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
            OutlinedButton(
              onPressed: _moveSelectedItemsToPantry,
              child: Text('ADD ITEMS TO PANTRY'),
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
