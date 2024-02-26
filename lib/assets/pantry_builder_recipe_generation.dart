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
    required this.onSelectedItemsChanged,
  }) : super(key: key);

  final RealmResults<Item> items;
  final String sortMethod;
  final Function(List<String>) onSelectedItemsChanged;

  @override
  State<PantryBuilder> createState() => _PantryBuilderState();
}

class _PantryBuilderState extends State<PantryBuilder> {
  late List<bool> isSelectedAll;
  late List<bool> isSelectedNotExpiring;
  late List<bool> isSelectedExpiring;
  late List expiringItems = getExpiringItems();
  late List notExpiringItems = getNotExpiringItems();
  late DateFormat formatter = DateFormat('yyyy-dd-MM');

  @override
  void initState() {
    super.initState();
    isSelectedAll = List.generate(widget.items.length, (index) => false);
    isSelectedNotExpiring =
        List.generate(notExpiringItems.length, (index) => false);
    isSelectedExpiring = List.generate(expiringItems.length, (index) => false);
  }

  List<String> getSelectedItems() {
    final selectedItems = <String>[];
    for (int i = 0; i < notExpiringItems.length; i++) {
      if (isSelectedNotExpiring[i]) {
        selectedItems.add(notExpiringItems[i].name);
      }
    }
    for (int i = 0; i < expiringItems.length; i++) {
      if (isSelectedExpiring[i]) {
        selectedItems.add(expiringItems[i].name);
      }
    }
    return selectedItems;
  }

  List getExpiringItems() {
    final DateTime currentDate = DateTime.now();
    final expiringItems = [];

    for (var item in widget.items) {
      if (item.expiryDate == null) {
        continue;
      }

      if (item.expiryDate!.difference(currentDate).inDays <= 3) {
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

      if (item.expiryDate!.difference(currentDate).inDays >= 3) {
        notExpiringItems.add(item);
      }
    }
    return notExpiringItems;
  }

  void toggleSelectNotExpiring(bool select) {
    setState(() {
      isSelectedNotExpiring =
          List<bool>.filled(notExpiringItems.length, select);
      widget.onSelectedItemsChanged(getSelectedItems());
    });
  }

  void toggleItemSelectionNotExpiring(int index) {
    setState(() {
      isSelectedNotExpiring[index] = !isSelectedNotExpiring[index];
      widget.onSelectedItemsChanged(getSelectedItems());
    });
  }

  void toggleSelectExpiring(bool select) {
    setState(() {
      isSelectedExpiring = List<bool>.filled(expiringItems.length, select);
      widget.onSelectedItemsChanged(getSelectedItems());
    });
  }

  void toggleItemSelectionExpiring(int index) {
    setState(() {
      isSelectedExpiring[index] = !isSelectedExpiring[index];
      widget.onSelectedItemsChanged(getSelectedItems());
    });
  }

  void toggleSelectAll(bool select) {
    toggleSelectExpiring(select);
    toggleSelectNotExpiring(select);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
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
          ),
          SizedBox(
            height: 30,
          ),
          Text("Expiring ingredients"),
          SizedBox(
            height: 20,
          ),
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
                      onTap: () => toggleItemSelectionExpiring(index),
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
                              formatter
                                  .format(expiringItems[index].expiryDate)),
                          style: AppTypography.smallTitle,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          Text("Rest of ingredients"),
          SizedBox(
            height: 20,
          ),
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
                      onTap: () => toggleItemSelectionNotExpiring(index),
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
              )),
        ],
      ),
    );
  }
}
