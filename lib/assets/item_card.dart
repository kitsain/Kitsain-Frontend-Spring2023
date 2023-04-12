import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'statuscolor.dart';

class ItemCard extends StatefulWidget {
  ItemCard({super.key, required this.item});
  late Item item;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

enum _MenuValues { edit, used, bin, shoppinglist, delete }

class _ItemCardState extends State<ItemCard> {
  Color isFavorite(bool itemStatus) {
    if (itemStatus == true) {
      return Colors.red;
    } else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10.0)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(0),
        leading: Container(
          width: 15,
          color: widget.item.expiryDate == null
              ? const Color(0xffFFF8F0)
              : returnColor(widget.item.expiryDate!),
        ),
        title: Text(
          widget.item.name.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: PopupMenuButton<_MenuValues>(
          icon: const Icon(Icons.more_horiz),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: _MenuValues.edit,
                child: Text("Edit item"),
              ),
              PopupMenuItem(
                value: _MenuValues.used,
                child: Text("Move to used"),
              ),
              PopupMenuItem(
                value: _MenuValues.bin,
                child: Text("Move to bin"),
              ),
              PopupMenuItem(
                value: _MenuValues.shoppinglist,
                child: Text("Move to shopping list"),
              ),
              PopupMenuItem(
                value: _MenuValues.delete,
                child: Text("Delete from pantry"),
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
                          child: Container(
                            child: const Text("Cancel"),
                          )),
                      TextButton(
                          onPressed: () {
                            PantryProxy().deleteItem(widget.item);
                            Navigator.of(ctx).pop();
                          },
                          child: const Text("Delete"))
                    ],
                  ),
                );
                break;
            }
            // if (choice == "edit") {
            //   () {};
            // }
            // if (choice == "used") {
            //   debugPrint("used");
            //   debugPrint(widget.item.name);
            //   PantryProxy().changeLocation(widget.item, "Used");
            // }
            // if (choice == "bin") {
            //   PantryProxy().changeLocation(widget.item, "Bin");
            // }
            // if (choice == "shoppinglist") {
            //   () {};
            // }
            // if (choice == "delete") {
            //   () {
            //     showDialog(
            //       context: context,
            //       builder: (ctx) => AlertDialog(
            //         title: const Text("Delete item"),
            //         content: const Text(
            //             "Are you sure you want to delete this item? This action cannot be undone."),
            //         actions: <Widget>[
            //           TextButton(
            //               onPressed: () {
            //                 Navigator.of(ctx).pop();
            //               },
            //               child: Container(
            //                 child: const Text("Cancel"),
            //               )),
            //           TextButton(
            //               onPressed: () {
            //                 PantryProxy().deleteItem(widget.item);
            //               },
            //               child: const Text("Delete"))
            //         ],
            //       ),
            //     );
            //     // showAlertDialog(BuildContext context) {
            //     //   Widget cancelButton = TextButton(
            //     //     onPressed: () {},
            //     //     child: const Text("Cancel"),
            //     //   );
            //     //   Widget deleteButton = TextButton(
            //     //     onPressed: () {
            //     //       PantryProxy().deleteItem(widget.item);
            //     //     },
            //     //     child: const Text("Delete"),
            //     //   );

            //     //   AlertDialog alert = AlertDialog(
            //     //     title: const Text("Delete item"),
            //     //     content: const Text(
            //     //         "Are you sure you want to delete the item permanently? It will not show in your history or statistics."),
            //     //     actions: [cancelButton, deleteButton],
            //     //   );

            //     //   showDialog(
            //     //     context: context,
            //     //     builder: (BuildContext context) {
            //     //       return alert;
            //     //     },
            //     //   );
            //     // }
            //   };
            // }
          },
        ),
        subtitle: Text(widget.item.mainCat!.toUpperCase()),
        children: <Widget>[
          Row(
            children: [
              Container(
                width: 15,
                color: widget.item.expiryDate == null
                    ? const Color(0xffFFF8F0)
                    : returnColor(widget.item.expiryDate!),
              ),
              Container(width: 40, color: Colors.pink[500]),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.edit_calendar),
                        if (widget.item.openedDate != null) ...[
                          Text(DateFormat('d.M.yyyy')
                              .format(widget.item.openedDate!))
                        ] else ...[
                          const Text("ADDED")
                        ]
                        // Text("${widget.item.openedDate ?? 'OPENED'}")
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month),
                        if (widget.item.expiryDate != null) ...[
                          Text(DateFormat('d.M.yyyy')
                              .format(widget.item.expiryDate!))
                        ] else ...[
                          const Text("EXPIRATION")
                        ]
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.euro),
                        Text("${widget.item.price ?? 'PRICE'}")
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.question_mark),
                        Text("${widget.item.quantity ?? 'QUANTITY'}")
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_outline,
                          color: widget.item.everyday == true
                              ? Colors.red
                              : Colors.grey,
                        ),
                        const Text("MARK AS FAVORITE")
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
