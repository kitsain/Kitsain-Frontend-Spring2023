import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'package:kitsain_frontend_spring2023/assets/itembuilder.dart';

// This file only sets the general UI: where are the show and sort buttons
// and where the main content goes. Item lists are generated in
// itembuilder.dart, depending on the user's chosen options

const HEADERSIZE = 23.0;

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

  // Choose what items to query from db based on user selection
  RealmResults<Item>? chosenStream(String selectedView) {
    if (selectedView == "all" || selectedView == "bycat") {
      return PantryProxy().getPantryItems(selectedSort);
    } else if (selectedView == "opened") {
      return PantryProxy().getOpenedItems(selectedSort);
    } else if (selectedView == "favorites") {
      return PantryProxy().getFavouriteItems(selectedSort);
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
            initialValue: selectedView,
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
                  child: Text("ALL"),
                ),
                PopupMenuItem(
                  value: "favorites",
                  child: Text("FAVORITES"),
                ),
                PopupMenuItem(
                  value: "opened",
                  child: Text("OPENED"),
                ),
                PopupMenuItem(
                  value: "bycat",
                  child: Text("BY CATEGORY"),
                ),
              ];
            },
          ),
          PopupMenuButton(
            initialValue: selectedSort,
            onSelected: (value) {
              setState(() {
                selectedSort = value.toString();
              });
            },
            child: const Icon(
              Icons.tune,
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
        children: [
          Flexible(
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
                    debugPrint("all");
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Text(
                            "ALL ITEMS",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: HEADERSIZE),
                          ),
                        ),
                        ItemBuilder(
                          items: results,
                          sortMethod: selectedSort,
                          loc: "pantry",
                        ),
                      ],
                    );
                  }
                  if (selectedView == "favorites") {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Text(
                            "FAVORITE ITEMS",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: HEADERSIZE),
                          ),
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
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Text(
                            "OPENED ITEMS",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: HEADERSIZE),
                          ),
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  child: Text(
                                    cat.toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: HEADERSIZE),
                                  ),
                                ),
                                ItemBuilder(
                                  items: PantryProxy()
                                      .getByMainCat(cat, selectedSort),
                                  sortMethod: selectedSort,
                                  loc: "pantry",
                                ),
                                const Divider(
                                  height: 15,
                                  indent: 20,
                                  endIndent: 20,
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
