import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';
import 'package:kitsain_frontend_spring2023/assets/top_bar.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:kitsain_frontend_spring2023/views/add_forms/add_new_item_form.dart';
import 'package:kitsain_frontend_spring2023/views/help_pages/pantry_help_page.dart';
import 'package:realm/realm.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'package:kitsain_frontend_spring2023/assets/itembuilder.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/categories.dart';

// This file only sets the general UI: where are the show and sort buttons
// and where the main content goes. Item lists are generated in
// itembuilder.dart, depending on the user's chosen options

// const double HEADERSIZE = 23.0;

class PantryView extends StatefulWidget {
  const PantryView({super.key});

  @override
  State<PantryView> createState() => _PantryViewState();
}

class _PantryViewState extends State<PantryView> {
  // Default values for what the user sees: all items in alphabetical order
  String selectedView = "all";
  String selectedSort = "az";

  // List<String> categories = <String>[
  //   'New',
  //   'Meat',
  //   'Seafood',
  //   'Fruit',
  //   'Vegetables',
  //   'Frozen',
  //   'Drinks',
  //   'Bread',
  //   'Sweets',
  //   'Dairy',
  //   'Ready meals',
  //   'Dry & canned goods',
  //   'Other'
  // ];

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
  bool checkIfEmpty(int cat) {
    if (PantryProxy().getCatCount(cat) > 0) {
      return true;
    } else {
      return false;
    }
  }

  void _addNewItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          child: NewItemForm(),
        );
      },
    );
  }

  void _help() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          //heightFactor: 0.7,
          child: PantryHelp(),
        );
      },
    );
  }

  _receiveItem(Item data) {
    PantryProxy().changeLocation(data, "Pantry");
    setState(
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data.name, style: AppTypography.smallTitle,),
          ),
        );
      },
    );
  }

  // final catEnglish = <int, String>{
  //   1: 'New',
  //   2: 'Meat',
  //   3: 'Seafood',
  //   4: 'Fruit',
  //   5: 'Vegetables',
  //   6: 'Frozen',
  //   7: 'Drinks',
  //   8: 'Bread',
  //   9: 'Treats',
  //   10: 'Dairy',
  //   11: 'Ready meals',
  //   12: 'Dry & canned goods',
  //   13: 'Other'
  // };

  // Map catFinnish = {
  //   1: 'Uudet',
  //   2: 'Liha',
  //   3: 'Merenantimet',
  //   4: 'Hedelmät',
  //   5: 'Vihannekset',
  //   6: 'Pakasteet',
  //   7: 'Juomat',
  //   8: 'Leivät',
  //   9: 'Herkut',
  //   10: 'Maitotuotteet',
  //   11: 'Valmisateriat',
  //   12: 'Kuivatuotteet',
  //   13: 'Muut'
  // };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main2,
      appBar: TopBar(
        title: 'MY PANTRY',
        //title: AppLocalizations.of(context)!.pantryScreen,
        addFunction: _addNewItem,
        helpFunction: _help,
        backgroundImageName: 'assets/images/pantry_banner_B1.jpg',
        titleBackgroundColor: AppColors.titleBackgroundBrown,
      ),
      body: DragTarget<Item>(
        onAccept: (data) => _receiveItem(data),
        builder: (context, candidateData, rejectedData) {
          return ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton(
                    initialValue: selectedView,
                    onSelected: (value) {
                      setState(
                        () {
                          selectedView = value.toString();
                        },
                      );
                    },
                    child: const Icon(
                      Icons.tune,
                      size: 30,
                    ),
                    itemBuilder: (BuildContext context) {
                      return const [
                        PopupMenuItem(
                          value: "all",
                          child: Text("ALL", style: AppTypography.smallTitle,),
                        ),
                        PopupMenuItem(
                          value: "favorites",
                          child: Text("FAVORITES", style: AppTypography.smallTitle,),
                        ),
                        PopupMenuItem(
                          value: "opened",
                          child: Text("OPENED", style: AppTypography.smallTitle,),
                        ),
                        PopupMenuItem(
                          value: "bycat",
                          child: Text("BY CATEGORY", style: AppTypography.smallTitle,),
                        ),
                      ];
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  PopupMenuButton(
                    initialValue: selectedSort,
                    onSelected: (value) {
                      setState(
                        () {
                          selectedSort = value.toString();
                        },
                      );
                    },
                    child: const Icon(
                      Icons.filter_list,
                      size: 30,
                    ),
                    itemBuilder: (BuildContext context) {
                      return const [
                        PopupMenuItem(
                          value: "az",
                          child: Text("A - Z", style: AppTypography.smallTitle,),
                        ),
                        PopupMenuItem(
                          value: "expdate",
                          child: Text("Expiration date", style: AppTypography.smallTitle,),
                        ),
                        PopupMenuItem(
                          value: "addedlast",
                          child: Text("Added last", style: AppTypography.smallTitle,),
                        ),
                      ];
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
              StreamBuilder<RealmResultsChanges<Item>>(
                stream: chosenStream(selectedView)?.changes,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (data == null) {
                    return const CircularProgressIndicator(); // while loading data
                  }
                  final results = data.results;

                  if (results.isEmpty) {
                    return const Center(
                      child: Text("No items found", style: AppTypography.smallTitle,),
                    );
                  } else {
                    if (selectedView == "all") {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                            child: Text(
                              "ALL ITEMS",
                              style: AppTypography.heading3,
                            ),
                          ),
                          ItemBuilder(
                            items: results,
                            sortMethod: selectedSort,
                            loc: "Pantry",
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
                              style: AppTypography.heading3,
                            ),
                          ),
                          ItemBuilder(
                            items: results,
                            sortMethod: selectedSort,
                            loc: "Pantry",
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
                              style: AppTypography.heading3,
                            ),
                          ),
                          ItemBuilder(
                            items: results,
                            sortMethod: selectedSort,
                            loc: "Pantry",
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          for (var cat in Categories.categoriesByIndex.keys)
                            if (checkIfEmpty(cat))
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    child: Text(
                                      Categories.categoriesByIndex[cat]!.toUpperCase(),
                                      style: AppTypography.heading3,
                                    ),
                                  ),
                                  ItemBuilder(
                                    items: PantryProxy()
                                        .getByMainCat(cat, selectedSort),
                                    sortMethod: selectedSort,
                                    loc: "Pantry",
                                  ),
                                  const Divider(
                                    height: 15,
                                    indent: 20,
                                    endIndent: 20,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                        ],
                      );
                    }
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
