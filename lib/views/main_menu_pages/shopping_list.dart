import 'package:flutter/material.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  String _placeholderDataModel = "Drop";

  _receiveItem(String data) {
    setState(() {
      _placeholderDataModel = data;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$data")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DragTarget<String>(
            onAccept: (data) => _receiveItem(data),
            builder: (context, candidateData, rejectedData) {
              return Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.height * 0.20,
                  color: Colors.lightGreen,
                  alignment: Alignment.center,
                  child: Text(_placeholderDataModel),
              );
            },
          ),
        ],
      );
    });
  }
}