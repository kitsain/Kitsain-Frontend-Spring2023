import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';

class MyPantry extends StatefulWidget {
  const MyPantry({super.key});

  @override
  State<MyPantry> createState() => _MyPantryState();
}

class _MyPantryState extends State<MyPantry> {
  final StateController = Get.put(ItemController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: StateController.pantryList.length,
          itemBuilder: (context, index) {
            return Draggable<String>(
              data: StateController.pantryList[index],
              onDragCompleted: () {
                print('drag complete');
                StateController.pantryList.removeAt(index);
              },
              feedback: Material(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: ListTile(
                    tileColor: Colors.lightGreen,
                    title: Text(
                        '${StateController.pantryList[index]}currently being dragged'),
                  ),
                ),
              ),
              child: ListTile(
                title: Text('${StateController.pantryList[index]}'),
              ),
            );
          }),
    );
  }
}
