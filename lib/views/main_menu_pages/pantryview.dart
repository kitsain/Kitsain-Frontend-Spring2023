import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/assets/item_card.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'package:kitsain_frontend_spring2023/assets/itembuilder.dart';

// This file only sets the general UI: where are the show and sort buttons
// and where the main content goes. Item lists are generated in
// itembuilder.dart, depending on the user's chosen options

class PantryView extends StatefulWidget with ChangeNotifier {
  PantryView({super.key});

  @override
  State<PantryView> createState() => _PantryViewState();
}

class _PantryViewState extends State<PantryView> {
  // Default values for chosen shown items and their sorting
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
      backgroundColor: const Color(0xffFFF8F0),
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
                debugPrint(selectedSort);
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
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        children: [
          if (selectedView == "bycat ") ...[
            for (var cat in categories)
              if (checkIfEmpty(cat))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    ItemBuilder(
                      items: PantryProxy().getByMainCat(cat),
                      sortMethod: selectedSort,
                    ),
                    const Divider(height: 4, color: Colors.black)
                  ],
                ),
          ] else if (selectedView == "opened") ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ItemBuilder(
                  items: PantryProxy().getOpenedItems(),
                  sortMethod: selectedSort,
                ),
                const Divider(height: 4, color: Colors.black)
              ],
            ),
          ] else ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ItemBuilder(
                  items: PantryProxy().getPantryItems(),
                  sortMethod: selectedSort,
                ),
                const Divider(height: 4, color: Colors.black)
              ],
            ),
          ]
        ],
      ),
    );
  }
}

class PantryView2 extends StatefulWidget with ChangeNotifier {
  PantryView2({super.key});

  @override
  State<PantryView2> createState() => _PantryViewState2();
}

class _PantryViewState2 extends State<PantryView2> {
  late RealmResults<Item> _pantryItems;

  @override
  void initState() {
    _pantryItems = PantryProxy().getPantryItems();
    _pantryItems.changes.listen((changes) {
      changes.inserted; // indexes of inserted objects
      changes.modified; // indexes of modified objects
      changes.deleted; // indexes of deleted objects
      changes.newModified; // indexes of modified objects
      // after deletions and insertions are accounted for
      changes.moved; // indexes of moved objects
      changes.results; // the full List of objects
    });
    super.initState();
  }

  String selectedView = "all";
  String selectedSort = "az";

  List<String> categories = <String>[
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
        body: _pantryItems.isNotEmpty
            ? ItemBuilder(items: _pantryItems, sortMethod: selectedSort)
            : const Text("No items found"));
  }
}

class PantryView3 extends StatefulWidget {
  const PantryView3({super.key});

  @override
  State<PantryView3> createState() => _PantryView3State();
}

class _PantryView3State extends State<PantryView3> {
  String selectedView = "all";
  String selectedSort = "az";
  late RealmResults<Item> chosenItems = PantryProxy().getOpenedItems();

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

  RealmResults<Item>? chosenStream(String selectedView) {
    if (selectedView == "all" || selectedView == "bycat") {
      return PantryProxy().getPantryItems();
    } else if (selectedView == "opened") {
      return PantryProxy().getOpenedItems();
    }
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
      backgroundColor: const Color(0xffFFF8F0),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                selectedView = value.toString();
                if (selectedView == "all" || selectedView == "bycat") {
                  chosenItems = PantryProxy().getPantryItems();
                } else if (selectedView == "opened") {
                  chosenItems = PantryProxy().getOpenedItems();
                }
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
                debugPrint(selectedSort);
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
      body: Column(
        children: [
          Container(
            height: 30,
          ),
          Flexible(
            child: StreamBuilder<RealmResultsChanges<Item>>(
              stream: chosenStream(selectedView)?.changes,
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (data == null) return const CircularProgressIndicator();
                final results = data.results;

                if (selectedView == "all") {
                  debugPrint("all/opened");
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "ALL ITEMS",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      ItemBuilder(items: results, sortMethod: selectedSort),
                    ],
                  );
                }
                if (selectedView == "opened") {
                  debugPrint("all/opened");
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "OPENED ITEMS",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      ItemBuilder(items: results, sortMethod: selectedSort),
                    ],
                  );
                } else {
                  debugPrint("bycat");
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
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              ItemBuilder(
                                  items: PantryProxy().getByMainCat(cat),
                                  sortMethod: selectedSort),
                              const Divider(
                                height: 4,
                                color: Colors.black,
                              )
                            ],
                          ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
