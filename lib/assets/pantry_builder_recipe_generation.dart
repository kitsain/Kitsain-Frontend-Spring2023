import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitsain_frontend_spring2023/assets/item_card.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';

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
  late List<bool> isSelectedAll;
  late List<bool> isSelectedNotExpiring;
  late List<bool> isSelectedExpiring;
  late List expiringItems = getExpiringItems();
  late List notExpiringItems = getNotExpiringItems();
  late DateFormat formatter = DateFormat('yyyy-dd-MM');
  late List<List> mustHaveItems = [];
  late List<List> optionalItems = [];
  late List<String> optionalItemsNames = [];
  late List<String> mustHaveItemsNames = [];

  @override
  void initState() {
    super.initState();
    isSelectedAll = List.generate(widget.items.length, (index) => false);
    isSelectedNotExpiring =
        List.generate(notExpiringItems.length, (index) => false);
    isSelectedExpiring = List.generate(expiringItems.length, (index) => false);
  }

  List<String> getOptionalItems() {
    for (var item in optionalItems) {
      optionalItemsNames.add(item[0]);
    }

    return optionalItemsNames;
  }
  
  List<String> getMustHaveItems() {
    for (var item in mustHaveItems) {
      mustHaveItemsNames.add(item[0]);
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

  void toggleSelectNotExpiring(bool select) {
    setState(() {
      isSelectedNotExpiring =
          List<bool>.filled(notExpiringItems.length, select);
      widget.onOptionalItemsChanged(getOptionalItems());
      widget.onMustHaveItemsChanged(getMustHaveItems());

    });
  }

  void toggleItemSelectionNotExpiring(int index, String item) {
    setState(() {
      isSelectedNotExpiring[index] = !isSelectedNotExpiring[index];
      if (isSelectedNotExpiring[index]) {
        optionalItems.add([item, "notExpiring"]);
      }
      else {
        int indexOfItem = optionalItems.indexWhere((element) =>
          element[0] == item && element[1] == "notExpiring");
        if (indexOfItem != -1) {
          optionalItems.removeAt(indexOfItem);
        }
        indexOfItem = mustHaveItems.indexWhere((element) =>
          element[0] == item && element[1] == "notExpiring");
        if (indexOfItem != -1) {
          mustHaveItems.removeAt(indexOfItem);
        }
      }
      widget.onOptionalItemsChanged(getOptionalItems());
      widget.onMustHaveItemsChanged(getMustHaveItems());
    });

  }

  void toggleSelectExpiring(bool select) {
    setState(() {
      isSelectedExpiring = List<bool>.filled(expiringItems.length, select);
      widget.onOptionalItemsChanged(getOptionalItems());
      widget.onMustHaveItemsChanged(getMustHaveItems());
    });
  }

  void toggleItemSelectionExpiring(int index, String item) {
    setState(() {
      isSelectedExpiring[index] = !isSelectedExpiring[index];
      if (isSelectedExpiring[index]) {
        optionalItems.add([item, "expiring"]);
      }
      else {
        // Find the index of the item to remove
        int indexOfItem = optionalItems.indexWhere((element) =>
            element[0] == item && element[1] == "expiring");
        if (indexOfItem != -1) {
          optionalItems.removeAt(indexOfItem);
        }
        indexOfItem = mustHaveItems.indexWhere((element) =>
          element[0] == item && element[1] == "expiring");
        if (indexOfItem != -1) {
          mustHaveItems.removeAt(indexOfItem);
        }
      }
      widget.onOptionalItemsChanged(getOptionalItems());
      widget.onMustHaveItemsChanged(getMustHaveItems());
    });

  }

  void toggleSelectAll(bool select) {
    setState(() {
      // Select all
      if (select) {
        for (var item in expiringItems) {
          optionalItems.add([item.name, "expiring"]);
        }
        for (var item in notExpiringItems) {
          optionalItems.add([item.name, "notExpiring"]);
      }
    }
    // Deselect all
      else {
        for (var item in widget.items) {
          if (optionalItems.contains([item.name, "expiring"])) {
            optionalItems.remove([item.name, "expiring"]);
          }
          if (optionalItems.contains([item.name, "notExpiring"])) {
            optionalItems.remove([item.name, "notExpiring"]);
          }
        }
      }
    });

    toggleSelectExpiring(select);
    toggleSelectNotExpiring(select);
  
  }

  void switchList(List item, List fromList, List toList) {
    setState(() {
      fromList.remove(item);
      toList.add(item);
      widget.onOptionalItemsChanged(getOptionalItems());
      widget.onMustHaveItemsChanged(getMustHaveItems());
    });
  }

  void removeFromList(List item, List list) {
    setState(() {
      list.remove(item);
      widget.onOptionalItemsChanged(getOptionalItems());
      widget.onMustHaveItemsChanged(getMustHaveItems());
    });
  }

  void addItemToList(List item, List list) {
    setState(() {
      list.add(item);
      widget.onOptionalItemsChanged(getOptionalItems());
      widget.onMustHaveItemsChanged(getMustHaveItems());
    });
  }

  void removeToggleSelectionHighlight(List item) {
    if (item[1] == "expiring") {
      int indexOfItem = expiringItems.indexWhere((element) =>
        element.name == item[0]);
      isSelectedExpiring[indexOfItem] = !isSelectedExpiring[indexOfItem];
    }
    if (item[1] == "notExpiring") {
      int indexOfItem = notExpiringItems.indexWhere((element) =>
        element.name == item[0]);
      isSelectedNotExpiring[indexOfItem] = !isSelectedNotExpiring[indexOfItem];
    }

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
        SizedBox(height: 30),
        Text("Expiring ingredients"),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.vertical,
              spacing: 1.0,
              runSpacing: 8.0,
              children: List.generate(
                expiringItems.length,
                (index) => GestureDetector(
                  onTap: () => toggleItemSelectionExpiring(index, expiringItems[index].name),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isSelectedExpiring[index]
                          ? const Color.fromARGB(255, 78, 117, 88)
                          : null,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      (expiringItems[index].name +
                          " " +
                          formatter.format(expiringItems[index].expiryDate!.toLocal())),
                      style: const TextStyle(fontSize: 12.0),
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
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              direction: Axis.vertical,
              spacing: 1.0,
              runSpacing: 8.0,
              children: List.generate(
                notExpiringItems.length,
                (index) => GestureDetector(
                  onTap: () => toggleItemSelectionNotExpiring(index, notExpiringItems[index].name),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isSelectedNotExpiring[index]
                          ? const Color.fromARGB(255, 78, 117, 88)
                          : null,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      notExpiringItems[index].name,
                      style: AppTypography.smallTitle,
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
                              addItemToList([value, "null"], mustHaveItems);
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
                              Text(mustHaveItems[index][0]),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  removeFromList(mustHaveItems[index], mustHaveItems);
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
                              addItemToList([value, "null"], optionalItems);
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
                              Text(optionalItems[index][0]),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  removeToggleSelectionHighlight(optionalItems[index]);
                                  removeFromList(optionalItems[index], optionalItems);
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
