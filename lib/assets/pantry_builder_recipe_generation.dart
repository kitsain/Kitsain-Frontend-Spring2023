import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/assets/item_card.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';

// In this file we build the list of item cards, either in the pantry
// or in the history tab

class PantryBuilder extends StatefulWidget {
  const PantryBuilder({
    super.key,
    required this.items,
    required this.sortMethod,
    required this.onSelectedItemsChanged,
  });
  final RealmResults<Item> items;
  final String sortMethod;
  final Function(String) onSelectedItemsChanged;

  @override
  State<PantryBuilder> createState() => _PantryBuilderState();
}

class _PantryBuilderState extends State<PantryBuilder> {
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = List.generate(widget.items.length, (index) => false);
  }

  String getSelectedItemsAsString() {
    List<String> selectedItems = [];
    for (int i = 0; i < widget.items.length; i++) {
      if (isSelected[i]) {
        selectedItems.add(widget.items[i].name);
      }
    }
    return selectedItems.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = true;
                    }
                    widget.onSelectedItemsChanged(getSelectedItemsAsString());
                  });
                },
                child: Text('Select all'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = false;
                    }
                  });
                },
                child: Text('Deselect all'),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(
                widget.items.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected[index] = !isSelected[index];
                      widget.onSelectedItemsChanged(getSelectedItemsAsString());
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isSelected[index]
                          ? Color.fromARGB(255, 78, 117, 88)
                          : null,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      widget.items[index].name,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
