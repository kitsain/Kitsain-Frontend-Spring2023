import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/assets/item_card.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';

import '../database/pantry_proxy.dart';

// In this file we build the list of item cards

class ItemBuilder extends StatefulWidget {
  const ItemBuilder({super.key, required this.items, required this.sortMethod});
  final RealmResults<Item> items;
  final String sortMethod;

  @override
  State<ItemBuilder> createState() => _ItemBuilderState();
}

class _ItemBuilderState extends State<ItemBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return ItemCard(item: widget.items[index]);
      },
    );
  }
}

class ByCatBuilder extends StatefulWidget {
  const ByCatBuilder({super.key});

  @override
  State<ByCatBuilder> createState() => _ByCatBuilderState();
}

class _ByCatBuilderState extends State<ByCatBuilder> {
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
    return Container(
      child: Column(
        children: [],
      ),
    );
  }
}
