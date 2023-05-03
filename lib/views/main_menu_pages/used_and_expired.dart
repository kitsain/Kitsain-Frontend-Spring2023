import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitsain_frontend_spring2023/assets/itembuilder.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:kitsain_frontend_spring2023/views/help_pages/used_and_expired_help_page.dart';
import 'package:realm/realm.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';
import 'package:kitsain_frontend_spring2023/assets/top_bar.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';

import '../../database/pantry_proxy.dart';

const List<Widget> tabs = <Widget>[
  Text(
    'USED',
    style: AppTypography.category,
  ),
  Text(
    'BIN',
    style: AppTypography.category,
  ),
];

const List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

class UsedAndExpired extends StatefulWidget {
  const UsedAndExpired({super.key});

  @override
  State<UsedAndExpired> createState() => _UsedAndExpiredState();
}

class _UsedAndExpiredState extends State<UsedAndExpired> {
  // This variable is passed as a parameter to fetch items from the chosen month
  int monthInt = DateTime.now().month;

  // This variable controls the string shown in drop-down menu
  String month = DateFormat("MMMM").format(DateTime(0, DateTime.now().month));

  final year = DateTime.now().year;

  final List<bool> _selectedTabs = <bool>[true, false];

  final mapMonths = <int, String>{
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December'
  };

  // Default to used items -view
  String selectedView = "used";

  // Choose whether to show all items (either as one list or by category)
  // or only opened items
  RealmResults<Item>? chosenStream(String selectedView) {
    if (selectedView == "used") {
      return PantryProxy().getByYearMonthUsed(monthInt);
    } else if (selectedView == "bin") {
      return PantryProxy().getByYearMonthBin(monthInt);
    }
    return null;
  }

  _receiveItem(Item data, String tab) {
    if (tab == "used") {
      PantryProxy().changeLocation(data, "Used");
    } else {
      PantryProxy().changeLocation(data, "Bin");
    }
    setState(
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data.name),
            duration: Duration(seconds: 2),
          ),
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
          child: UsedAndExpiredHelp(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var usedPercent = double.parse(
      PantryProxy().countByMonth(monthInt, selectedView),
    );
    return Scaffold(
      backgroundColor: AppColors.main2,
      appBar: TopBar(
        title: 'PANTRY HISTORY',
        // title: AppLocalizations.of(context)!.historyScreen,
        helpFunction: _help,
        backgroundImageName: 'assets/images/ue_banner_darker_B2.png',
        titleBackgroundColor: AppColors.titleBackgroundGreen,
      ),
      body: DragTarget<Item>(
        onAccept: (data) => _receiveItem(data, selectedView),
        builder: (context, candidateData, rejectedData) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: Align(
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        DropdownButton(
                          value: month,
                          style: AppTypography.category
                              .copyWith(color: Colors.black),
                          iconSize: 0,
                          onChanged: (String? value) {
                            setState(
                              () {
                                monthInt = mapMonths.keys
                                    .firstWhere((k) => mapMonths[k] == value);
                                month = DateFormat("MMMM").format(
                                  DateTime(0, monthInt),
                                );
                              },
                            );
                          },
                          items: mapMonths
                              .map(
                                (key, value) {
                                  return MapEntry(
                                    key,
                                    DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ),
                                  );
                                },
                              )
                              .values
                              .toList(),
                        ),
                        const Text(
                          "2023",
                          style: AppTypography.category,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Center(
                child: DragTarget<Item>(
                  onWillAccept: (data) {
                    setState(() {
                      _selectedTabs[0] = !_selectedTabs[0];
                      _selectedTabs[1] = !_selectedTabs[1];
                    });
                    if (_selectedTabs[0] == true) {
                      selectedView = "used";
                    } else {
                      selectedView = "bin";
                    }
                    return true;
                  },
                  builder: (context, candidateData, rejectedData) {
                    return ToggleButtons(
                        color: Colors.black,
                        selectedColor: AppColors.main2,
                        fillColor: AppColors.main1,
                        borderColor: AppColors.main1,
                        direction: Axis.horizontal,
                        onPressed: (int index) {
                          setState(
                            () {
                              for (int i = 0; i < _selectedTabs.length; i++) {
                                _selectedTabs[i] = i == index;
                                if (_selectedTabs[0] == true) {
                                  selectedView = "used";
                                } else {
                                  selectedView = "bin";
                                }
                              }
                            },
                          );
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        constraints: const BoxConstraints(
                          minHeight: 40.0,
                          minWidth: 100.0,
                        ),
                        isSelected: _selectedTabs,
                        children: tabs);
                  },
                ),
              ),
              StreamBuilder<RealmResultsChanges<Item>>(
                stream: chosenStream(selectedView)?.changes,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (data == null) return const CircularProgressIndicator();
                  final results = data.results;

                  if (results.isEmpty) {
                    return const Center(
                      child: Text(
                        "No items found",
                        style: AppTypography.smallTitle,
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(200),
                              child: SizedBox(
                                height: 200,
                                width: 200,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Container(
                                      color: Colors.white,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 200 * usedPercent / 100,
                                        width: 200,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    const Image(
                                      image: AssetImage(
                                          'assets/images/plate1.png'),
                                      height: 200,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Text(
                                  "${PantryProxy().countByMonth(monthInt, selectedView)}%",
                                  style: AppTypography.heading1.copyWith(
                                    fontSize: 80,
                                    color: AppColors.main1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                          child: Text(
                            "${selectedView.toUpperCase()} ITEMS",
                            style: AppTypography.heading3,
                          ),
                        ),
                        ItemBuilder(
                          items: results,
                          sortMethod: "az",
                          loc: "History",
                        ),
                      ],
                    );
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
