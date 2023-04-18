import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'package:kitsain_frontend_spring2023/assets/itembuilder.dart';

// This file only sets the general UI: where are the show and sort buttons
// and where the main content goes. Item lists are generated in
// itembuilder.dart, depending on the user's chosen options

class PantryView extends StatefulWidget {
  const PantryView({super.key});

  @override
  State<PantryView> createState() => _PantryViewState();
}

class _PantryViewState extends State<PantryView> {
  // Default values for what the user sees: all items in alphabetical order
  String selectedView = "all";
  String selectedSort = "az";

  List<String> categories = <String>[
    'New',
    'Meat',
    'Seafood',
    'Fruit',
    'Vegetables',
    'Frozen',
    'Drinks',
    'Bread',
    'Sweets',
    'Dairy',
    'Ready meals',
    'Dry & canned goods',
    'Other'
  ];

  // Choose whether to show all items (either as one list or by category)
  // or only opened items
  RealmResults<Item>? chosenStream(String selectedView) {
    if (selectedView == "all" || selectedView == "bycat") {
      return PantryProxy().getPantryItems(selectedSort);
    } else if (selectedView == "opened") {
      return PantryProxy().getOpenedItems(selectedSort);
    }
    return null;
  }

  // If the category has no items, the header for it will not be shown
  bool checkIfEmpty(String cat) {
    if (PantryProxy().getCatCount(cat) > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                selectedView = value.toString();
              });
            },
            child: const Text("SHOW"),
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem(
                  value: "all",
                  child: Text("All"),
                ),
                PopupMenuItem(
                  value: "opened",
                  child: Text("Opened"),
                ),
                PopupMenuItem(
                  value: "bycat",
                  child: Text("By category"),
                ),
              ];
            },
          ),
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                selectedSort = value.toString();
              });
            },
            child: const Icon(
              Icons.sort_rounded,
              size: 30,
            ),
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem(
                  value: "expdate",
                  child: Text("Expiration date"),
                ),
                PopupMenuItem(
                  value: "addedlast",
                  child: Text("Added last"),
                ),
                PopupMenuItem(
                  value: "az",
                  child: Text("A - Z"),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 20, // To give space for the show/sort options
          ),
          Expanded(
            child: StreamBuilder<RealmResultsChanges<Item>>(
              stream: chosenStream(selectedView)?.changes,
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (data == null) {
                  return const CircularProgressIndicator(); // while loading data
                }
                final results = data.results;

                if (results.isEmpty) {
                  return const Center(
                    child: Text("No items found"),
                  );
                } else {
                  if (selectedView == "all") {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "ALL ITEMS",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        ItemBuilder(
                          items: results,
                          sortMethod: selectedSort,
                          loc: "pantry",
                        ),
                      ],
                    );
                  }
                  if (selectedView == "opened") {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "OPENED ITEMS",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        ItemBuilder(
                          items: results,
                          sortMethod: selectedSort,
                          loc: "pantry",
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        for (var cat in categories)
                          if (checkIfEmpty(cat))
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cat.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                ItemBuilder(
                                  items: PantryProxy()
                                      .getByMainCat(cat, selectedSort),
                                  sortMethod: selectedSort,
                                  loc: "pantry",
                                ),
                                const Divider(
                                  height: 4,
                                  color: Colors.black,
                                )
                              ],
                            ),
                      ],
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
