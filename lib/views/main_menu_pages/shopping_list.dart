import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final StateController = Get.put(ItemController());

  _receiveItem(String data) {
    StateController.shoppingBagList.add(data);

    setState(
      () {
        // print(shoppingBagList.length);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$data")));
      },
    );
  }

  // List<String> shoppingBigList = ['item 1', 'item 2'];
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
                itemCount: StateController.shoppingBagList.length,
                padding: EdgeInsets.all(5),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.all(10),
                        minVerticalPadding: 10,
                        tileColor: Colors.lightGreen,
                        title: Text('${AppLocalizations.of(context)!.shoppingListItem} ${index + 1}'),
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
