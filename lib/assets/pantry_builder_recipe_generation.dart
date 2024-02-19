import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/assets/item_card.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';

// In this file we build the list of item cards, either in the pantry
// or in the history tab

class PantryBuilder extends StatefulWidget {
  const PantryBuilder(
      {super.key,
      required this.items,
      required this.sortMethod});
  final RealmResults<Item> items;
  final String sortMethod;

  @override
  State<PantryBuilder> createState() => _PantryBuilderState();
}

class _PantryBuilderState extends State<PantryBuilder> {
  var radioValues;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return(
          Text(widget.items[index].name)
        );
      },
    );
  }
}
