import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'statuscolor.dart';

enum _MenuValues { edit, used, bin, shoppinglist, delete, pantry }

const BORDERWIDTH = 20.0;
const NULLCOLOR = Color(0xffF0EBE5);

class ItemCard extends StatefulWidget {
  ItemCard({super.key, required this.item});
  late Item item;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  void deleteItem(Item item) {
    realm.write(() {
      realm.delete(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: widget.item.expiryDate == null
                        ? NULLCOLOR
                        : returnColor(widget.item.expiryDate!),
                    width: BORDERWIDTH),
              ),
            ),
            child: ExpansionTile(
              title: Text(
                widget.item.name.toUpperCase(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              subtitle: Text(widget.item.mainCat!.toUpperCase()),
              trailing: PopupMenuButton<_MenuValues>(
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
                  }
                },
              ),
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
                        DateFormat('d.M.yyyy').format(widget.item.openedDate!),
                      )
                    ] else ...[
                      const Text(
                        "ADDED",
                        style: TextStyle(color: NULLCOLOR),
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
                      Text(DateFormat('d.M.yyyy')
                          .format(widget.item.expiryDate!))
                    ] else ...[
                      const Text(
                        "EXPIRATION",
                        style: TextStyle(color: NULLCOLOR),
                      )
                    ]
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 60,
                    ),
                    if (widget.item.everyday == true) ...[
                      IconButton(
                        onPressed: () {
                          PantryProxy().toggleItemEveryday(widget.item);
                        },
                        icon: const Icon(Icons.favorite, color: Colors.black),
                      ),
                    ] else ...[
                      IconButton(
                        onPressed: () {
                          PantryProxy().toggleItemEveryday(widget.item);
                        },
                        icon: const Icon(Icons.favorite_border,
                            color: Colors.grey),
                      ),
                    ],
                    const Text("MARK AS FAVORITE")
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryCard extends StatefulWidget {
  HistoryCard({super.key, required this.item});
  late Item item;

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  void deleteItem(Item item) {
    realm.write(() {
      realm.delete(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: widget.item.expiryDate == null
                        ? NULLCOLOR
                        : returnColor(widget.item.expiryDate!),
                    width: BORDERWIDTH),
              ),
            ),
            child: ExpansionTile(
              title: Text(widget.item.name.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 23)),
              subtitle: Text(widget.item.mainCat!.toUpperCase()),
              trailing: PopupMenuButton<_MenuValues>(
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
                  }
                },
              ),
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
                      Text(DateFormat('d.M.yyyy')
                          .format(widget.item.openedDate!))
                    ] else ...[
                      const Text(
                        "ADDED",
                        style: TextStyle(color: NULLCOLOR),
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
                        DateFormat('d.M.yyyy').format(widget.item.expiryDate!),
                      )
                    ] else ...[
                      const Text(
                        "EXPIRATION",
                        style: TextStyle(color: NULLCOLOR),
                      )
                    ]
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 60,
                    ),
                    if (widget.item.everyday == true) ...[
                      IconButton(
                        onPressed: () {
                          PantryProxy().toggleItemEveryday(widget.item);
                        },
                        icon: const Icon(Icons.favorite, color: Colors.black),
                      ),
                    ] else ...[
                      IconButton(
                        onPressed: () {
                          PantryProxy().toggleItemEveryday(widget.item);
                        },
                        icon: const Icon(Icons.favorite_border,
                            color: Colors.grey),
                      ),
                    ],
                    const Text("MARK AS FAVORITE")
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
