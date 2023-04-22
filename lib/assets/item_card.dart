// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'package:kitsain_frontend_spring2023/views/edit_forms/edit_item_form.dart';
import 'statuscolor.dart';

enum _MenuValues { edit, used, bin, shoppinglist, delete, pantry }

const double BORDERWIDTH = 30.0;
const Color NULLSTATUSCOLOR = Color(0xffF0EBE5);
const Color NULLTEXTCOLOR = Color(0xff979797);

final catEnglish = <int, String>{
  1: 'New',
  2: 'Meat',
  3: 'Seafood',
  4: 'Fruit',
  5: 'Vegetables',
  6: 'Frozen',
  7: 'Drinks',
  8: 'Bread',
  9: 'Treats',
  10: 'Dairy',
  11: 'Ready meals',
  12: 'Dry & canned goods',
  13: 'Other'
};

class ItemCard extends StatefulWidget {
  ItemCard({super.key, required this.item, required this.loc});
  late Item item;
  late String loc;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  void deleteItem(Item item) {
    realm.write(
      () {
        realm.delete(item);
      },
    );
  }

  void _editItem(Item item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          child: EditItemForm(item: item),
        );
      },
    );
  }

  bool showAbbreviation = true;

  @override
  Widget build(BuildContext context) {
    var popupMenuButton = PopupMenuButton<_MenuValues>(
      icon: const Icon(Icons.more_horiz),
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            value: _MenuValues.edit,
            child: Text("Edit item"),
          ),
          const PopupMenuItem(
            value: _MenuValues.used,
            child: Text("Move to used"),
          ),
          const PopupMenuItem(
            value: _MenuValues.bin,
            child: Text("Move to bin"),
          ),
          const PopupMenuItem(
            value: _MenuValues.shoppinglist,
            child: Text("Move to shopping list"),
          ),
          const PopupMenuItem(
            value: _MenuValues.delete,
            child: Text("Delete item"),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case _MenuValues.edit:
            _editItem(widget.item);
            break;
          case _MenuValues.used:
            PantryProxy().changeLocation(widget.item, "Used");
            break;
          case _MenuValues.bin:
            PantryProxy().changeLocation(widget.item, "Bin");
            break;
          case _MenuValues.shoppinglist:
            break;
          case _MenuValues.delete:
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Delete item"),
                content: const Text(
                    "Are you sure you want to delete this item? This action cannot be undone."),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        deleteItem(widget.item);
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Delete"))
                ],
              ),
            );
            break;
          case _MenuValues.pantry:
            break;
        }
      },
    );

    var popupMenuButtonHistory = PopupMenuButton<_MenuValues>(
      icon: const Icon(Icons.more_horiz),
      itemBuilder: (BuildContext context) {
        return [
          if (widget.item.location == "Bin") ...[
            const PopupMenuItem(
              value: _MenuValues.used,
              child: Text("Move to used"),
            ),
          ],
          if (widget.item.location == "Used") ...[
            const PopupMenuItem(
              value: _MenuValues.bin,
              child: Text("Move to bin"),
            ),
          ],
          const PopupMenuItem(
            value: _MenuValues.pantry,
            child: Text("Move to pantry"),
          ),
          const PopupMenuItem(
            value: _MenuValues.shoppinglist,
            child: Text("Move to shopping list"),
          ),
          const PopupMenuItem(
            value: _MenuValues.delete,
            child: Text("Delete item"),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case _MenuValues.bin:
            PantryProxy().changeLocation(widget.item, "Bin");
            break;
          case _MenuValues.used:
            PantryProxy().changeLocation(widget.item, "Used");
            break;
          case _MenuValues.pantry:
            PantryProxy().changeLocation(widget.item, "Pantry");
            break;
          case _MenuValues.shoppinglist:
            break;
          case _MenuValues.delete:
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Delete item"),
                content: const Text(
                    "Are you sure you want to delete this item? This action cannot be undone."),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        deleteItem(widget.item);
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Delete"))
                ],
              ),
            );
            break;
          case _MenuValues.edit:
            break;
        }
      },
    );

    return LongPressDraggable<Item>(
      data: widget.item,
      onDragCompleted: () {},
      feedback: SizedBox(
        height: 85,
        width: 320,
        child: Card(
          elevation: 7,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: ClipPath(
            child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.black, width: 13),
                  ),
                ),
                child: ListTile(
                  title: Text(widget.item.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
                  subtitle: Text(
                    'ITEM CATEGORY',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Transform.translate(
                    offset: Offset(0, -15),
                    child: Icon(Icons.more_horiz),
                  ),
                  leading: Transform.translate(
                    offset: Offset(0, 0),
                    child: Icon(Icons.fastfood, size: 35),
                  ),
                )),
            clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Card(
          elevation: 7,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: ClipPath(
            clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                          color: widget.item.expiryDate == null
                              ? NULLSTATUSCOLOR
                              : returnColor(widget.item.expiryDate!),
                          width: BORDERWIDTH),
                    ),
                  ),
                  child: ExpansionTile(
                    onExpansionChanged: (val) =>
                        setState(() => showAbbreviation = !val),
                    title: Text(
                      widget.item.name.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 23),
                    ),
                    subtitle: Text(
                      catEnglish[widget.item.mainCat]!.toUpperCase(),
                    ),
                    trailing: widget.loc == "Pantry"
                        ? popupMenuButton
                        : popupMenuButtonHistory,
                    leading: Transform.translate(
                      offset: const Offset(0, 0),
                      child: const Icon(Icons.fastfood, size: 35),
                    ),
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 70,
                          ),
                          const Icon(Icons.edit_calendar),
                          const SizedBox(
                            width: 15,
                          ),
                          if (widget.item.openedDate != null) ...[
                            Text(
                              DateFormat('d.M.yyyy').format(
                                widget.item.openedDate!.toLocal(),
                              ),
                            )
                          ] else ...[
                            const Text(
                              "ADDED",
                              style: TextStyle(color: NULLTEXTCOLOR),
                            )
                          ]
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 70,
                          ),
                          const Icon(Icons.calendar_month),
                          const SizedBox(
                            width: 15,
                          ),
                          if (widget.item.expiryDate != null) ...[
                            Text(
                              DateFormat('d.M.yyyy')
                                  .format(widget.item.expiryDate!.toLocal()),
                            )
                          ] else ...[
                            const Text(
                              "EXPIRATION",
                              style: TextStyle(color: NULLTEXTCOLOR),
                            )
                          ]
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 60,
                          ),
                          if (widget.item.favorite == true) ...[
                            IconButton(
                              onPressed: () {
                                PantryProxy().toggleItemFavorite(widget.item);
                              },
                              icon: const Icon(Icons.favorite,
                                  color: Colors.black),
                            ),
                          ] else ...[
                            IconButton(
                              onPressed: () {
                                PantryProxy().toggleItemFavorite(widget.item);
                              },
                              icon: const Icon(Icons.favorite_border,
                                  color: Colors.grey),
                            ),
                          ],
                          const Text("MARK AS FAVORITE")
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      if (widget.item.details != null) ...[
                        Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(widget.item.details!),
                          ),
                        ),
                      ] else ...[
                        Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: NULLTEXTCOLOR),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "Details",
                              style: TextStyle(color: NULLTEXTCOLOR),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 9, top: 9),
                  child: Column(
                    children: [
                      if (widget.item.expiryDate != null) ...[
                        if (widget.item.expiryDate!
                                .difference(DateTime.now())
                                .inDays <
                            7) ...[
                          if (showAbbreviation) ...[
                            for (var rune in DateFormat(DateFormat.ABBR_WEEKDAY)
                                .format(widget.item.expiryDate!)
                                .runes) ...[
                              Text(
                                String.fromCharCode(rune),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ]
                          ] else ...[
                            for (var rune in DateFormat(DateFormat.WEEKDAY)
                                .format(widget.item.expiryDate!)
                                .runes) ...[
                              Text(
                                String.fromCharCode(rune),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ]
                          ],
                        ],
                      ]
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
