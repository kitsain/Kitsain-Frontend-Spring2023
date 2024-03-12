import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitsain_frontend_spring2023/assets/item_card.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';

class NewItem {
  String name;
  NewItem(this.name);
}

class PantryBuilder extends StatefulWidget {
  const PantryBuilder({
    Key? key,
    required this.items,
    required this.sortMethod,
    required this.onOptionalItemsChanged,
    required this.onMustHaveItemsChanged,
  }) : super(key: key);

  final RealmResults<Item> items;
  final String sortMethod;
  final Function(List<String>) onOptionalItemsChanged;
  final Function(List<String>) onMustHaveItemsChanged;

  @override
  State<PantryBuilder> createState() => _PantryBuilderState();
}

class _PantryBuilderState extends State<PantryBuilder> {
  late int expirationTimeInDays = 4;
  late List<Map<String, dynamic>> isSelectedAll;
  late List expiringItems = getExpiringItems();
  late List notExpiringItems = getNotExpiringItems();
  late DateFormat formatter = DateFormat('yyyy-dd-MM');
  late List mustHaveItems = [];
  late List optionalItems = [];
  late List<String> optionalItemsNames = [];
  late List<String> mustHaveItemsNames = [];

  @override
  void initState() {
    super.initState();
    isSelectedAll = List.generate(widget.items.length, (index) {
      return {
        'item': widget.items[index],
        'isSelected': false,
      };
    });
  }

  List<String> getOptionalItems() {
    for (var item in optionalItems) {
      optionalItemsNames.add(item.name);
    }

    return optionalItemsNames;
  }
  
  List<String> getMustHaveItems() {
    for (var item in mustHaveItems) {
      if (item.name != null) {
        mustHaveItemsNames.add(item.name);
      }
      else {
        mustHaveItems.add(item);
      }
      
    }

    return mustHaveItemsNames;
  }

  List getExpiringItems() {
    final DateTime currentDate = DateTime.now();
    final expiringItems = [];

    for (var item in widget.items) {
      if (item.expiryDate == null) {
        continue;
      }

      if (item.expiryDate!.difference(currentDate).inDays <= expirationTimeInDays){
        expiringItems.add(item);
      }
    }
    return expiringItems;
  }

  List getNotExpiringItems() {
    final DateTime currentDate = DateTime.now();
    final notExpiringItems = [];

    for (var item in widget.items) {
      if (item.expiryDate == null) {
        notExpiringItems.add(item);
        continue;
      }

      if (item.expiryDate!.difference(currentDate).inDays >= expirationTimeInDays){
        notExpiringItems.add(item);
      }
    }
    return notExpiringItems;
  }


  void toggleSelectAll(bool select) {
  setState(() {
    for (var item in isSelectedAll) {
      item['isSelected'] = select;
    }
    for (var item in isSelectedAll) {
      if (item['isSelected'] && !optionalItems.contains(item['item']) && !mustHaveItems.contains(item['item'])) {
        optionalItems.add(item['item']);
      }
      else if(!item['isSelected']) {
        if (optionalItems.contains(item['item'])) {
          optionalItems.remove(item['item']);
        }
        if (mustHaveItems.contains(item['item'])) {
          mustHaveItems.remove(item['item']);
        }
      }
    }
    widget.onOptionalItemsChanged(getOptionalItems());
    widget.onMustHaveItemsChanged(getMustHaveItems());
    
  });
  }

  void toggleItemSelection(item) {
    setState(() {
      int indexToUpdate = isSelectedAll.indexWhere((element) => element['item'] == item);
      // If the item is found in the pantry items
      if (indexToUpdate != -1) {
        isSelectedAll[indexToUpdate]['isSelected'] = !isSelectedAll[indexToUpdate]['isSelected'];
      }
      // Else remove it from the two lists
      else {
        removeFromList(item, optionalItems);
        removeFromList(item, mustHaveItems);
        return;
      }
      if (isSelectedAll[indexToUpdate]['isSelected']) {
        optionalItems.add(item);
      }
      else {
        // Find the index of the item to remove
        int indexToRemove = optionalItems.indexWhere((element) =>
            element == item);
        if (indexToRemove != -1) {
          optionalItems.removeAt(indexToRemove);
        }
        indexToRemove = mustHaveItems.indexWhere((element) =>
            element == item);
        if (indexToRemove != -1) {
          mustHaveItems.removeAt(indexToRemove);
        }
      }
      widget.onOptionalItemsChanged(getOptionalItems());
      widget.onMustHaveItemsChanged(getMustHaveItems());
    });

  }

  getColor(item) {
    int index = isSelectedAll.indexWhere((element) => element['item'] == item);
    var color = isSelectedAll[index]['isSelected'] 
      ? const Color.fromARGB(255, 78, 117, 88)
      : null;
    return color;
  }

  void switchList(item, List fromList, List toList) {
    setState(() {
      fromList.remove(item);
      toList.add(item);
      widget.onOptionalItemsChanged(getOptionalItems());
      widget.onMustHaveItemsChanged(getMustHaveItems());
    });
  }

  void removeFromList(item, List list) {
    setState(() {
      list.remove(item);
      widget.onOptionalItemsChanged(getOptionalItems());
      widget.onMustHaveItemsChanged(getMustHaveItems());
    });
  }

  void addItemToList(item, List list) {
    setState(() {
      list.add(item);
      widget.onOptionalItemsChanged(getOptionalItems());
      widget.onMustHaveItemsChanged(getMustHaveItems());
    });
  }


  Widget buildSelectButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => toggleSelectAll(true),
          child: const Text('Select all'),
        ),
        ElevatedButton(
          onPressed: () => toggleSelectAll(false),
          child: const Text('Deselect all'),
        ),
      ],
    );
  }

  Widget buildExpiringIngredients() {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Text("Expiring ingredients"),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: 16.0,
            bottom: 16.0,
            ),
          child: Align(
            alignment: Alignment.center,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 1.0,
              runSpacing: 8.0,
              children: List.generate(
                expiringItems.length,
                (index) => GestureDetector(
                  onTap: () => toggleItemSelection(expiringItems[index]),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: getColor(expiringItems[index]),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      (expiringItems[index].name +
                          " " +
                          formatter.format(expiringItems[index].expiryDate!.toLocal())),
                      style: AppTypography.category,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRestOfIngredients() {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Text("Rest of ingredients"),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: 16.0,
            bottom: 30.0,
            ),
          child: Align(
            alignment: Alignment.center,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 1.0,
              runSpacing: 8.0,
              children: List.generate(
                notExpiringItems.length,
                (index) => GestureDetector(
                  onTap: () => toggleItemSelection(notExpiringItems[index]),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: getColor(notExpiringItems[index]),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      notExpiringItems[index].name,
                      style: AppTypography.category,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget buildSelectedItemLists() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center the text
            children: [
              const Text(
                'Must Have Items', // Title for the first list
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 200, // Adjust this value as needed
                child: ListView.builder(
                  itemCount: mustHaveItems.length + 1, // Add 1 for the extra card
                  itemBuilder: (context, index) {
                    if (index == mustHaveItems.length) {
                      // Render the extra card for adding new items
                      return Card(
                        child: ListTile(
                          title: TextField(
                            onSubmitted: (value) {
                              addItemToList(NewItem(value), mustHaveItems);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter item',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      );
                    } else {
                      // Render the existing items
                      return Card(
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(mustHaveItems[index].name),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  toggleItemSelection(mustHaveItems[index]);
                                },
                                child: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          onTap: () {
                            switchList(mustHaveItems[index], mustHaveItems, optionalItems);
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Optional Items', // Title for the second list
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 200, // Adjust this value as needed
                child: ListView.builder(
                  itemCount: optionalItems.length + 1, // Add 1 for the extra card
                  itemBuilder: (context, index) {
                    if (index == optionalItems.length) {
                      // Render the extra card for adding new items
                      return Card(
                        child: ListTile(
                          title: TextField(
                            onSubmitted: (value) {
                              addItemToList(NewItem(value), optionalItems);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter item',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Card(
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(optionalItems[index].name),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  toggleItemSelection(optionalItems[index]);
                                },
                                child: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          onTap: () {
                            switchList(optionalItems[index], optionalItems, mustHaveItems);
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildSelectButtons(),
          buildExpiringIngredients(),
          buildRestOfIngredients(),
          buildSelectedItemLists(),
        ],
      ),
    );
  }
}
