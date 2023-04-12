import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/assets/item_card.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';

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
