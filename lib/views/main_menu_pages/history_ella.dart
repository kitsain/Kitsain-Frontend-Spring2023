import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/assets/itembuilder.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';

import '../../database/pantry_proxy.dart';

const List<Widget> tabs = <Widget>[
  Text('USED'),
  Text('BIN'),
];

const List months = [
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

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final month = months[DateTime.now().month - 1];
  final year = DateTime.now().year;

  final List<bool> _selectedTabs = <bool>[true, false];

  // Default to used items -view
  String selectedView = "used";

  // Choose whether to show all items (either as one list or by category)
  // or only opened items
  RealmResults<Item>? chosenStream(String selectedView) {
    if (selectedView == "used") {
      return PantryProxy().getUsedItems();
    } else if (selectedView == "bin") {
      return PantryProxy().getBinItems();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
                child: Text(
                  'MONTH > $month $year',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Center(
            child: DragTarget<String>(
              onWillAccept: (data) {
                _selectedTabs[0] = !_selectedTabs[0];
                _selectedTabs[1] = !_selectedTabs[1];
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
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                return ItemBuilder(items: results, sortMethod: "az");
              }
            },
          ),
        ],
      ),
    );
  }
}
