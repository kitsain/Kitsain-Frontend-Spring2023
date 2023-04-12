import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/assets/itembuilder.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';

import '../../database/pantry_proxy.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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
      backgroundColor: const Color(0xffFFF8F0),
      body: Column(
        children: [
          Container(
            height: 30,
          ),
          Container(
            child: StreamBuilder<RealmResultsChanges<Item>>(
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
          ),
        ],
      ),
    );
  }
}
