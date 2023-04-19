import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitsain_frontend_spring2023/assets/itembuilder.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';
import 'package:kitsain_frontend_spring2023/assets/top_bar.dart';

import '../../database/pantry_proxy.dart';

const List<Widget> tabs = <Widget>[
  Text('USED'),
  Text('BIN'),
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

  var _expDate = TextEditingController();
  var _openDate = TextEditingController();
  var _details = TextEditingController();

  bool _favorite = false;

  _receiveItem(Item data) {
    print(data.name);
    if (_selectedTabs[0] == true) {
      print('select00000');
      PantryProxy().changeLocation(data, "Used");
    } else {
      PantryProxy().changeLocation(data, "Bin");
      print('select1111111');
    }
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data.name),
        ),
      );
    });
  }

  _temp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: AppLocalizations.of(context)!.historyScreen,
        addFunction: _temp,
        addIcon: Icons.post_add,
        helpFunction: _temp,
      ),
      body: DragTarget<Item>(
        onAccept: (data) => _receiveItem(data),
        builder: (context, candidateData, rejectedData) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    child: Row(
                      children: [
                        const Text(
                          "MONTH >",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        DropdownButton(
                          value: month,
                          style: const TextStyle(color: Colors.black),
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
                        const Text("2023")
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
                      child: Text("No items found"),
                    );
                  } else {
                    return Column(
                      children: [
                        Stack(
                          children: <Widget>[
                            const SizedBox(
                              width: 360,
                              height: 170,
                            ),
                            const Positioned(
                              top: -17,
                              left: 20,
                              right: 20,
                              child: Icon(Icons.circle,
                                  size: 200, color: Colors.amber),
                            ),
                            Positioned(
                              top: 90,
                              left: 190,
                              right: 10,
                              bottom: 10,
                              child: Text(
                                "${PantryProxy().countByMonth(monthInt, selectedView)} %",
                                style: const TextStyle(fontSize: 60),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                          child: Text(
                            "${selectedView.toUpperCase()} ITEMS",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 23),
                          ),
                        ),
                        ItemBuilder(
                          items: results,
                          sortMethod: "az",
                          loc: "history",
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
