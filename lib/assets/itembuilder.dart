import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/assets/item_card.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'package:realm/realm.dart';
import 'package:kitsain_frontend_spring2023/views/forms/edit_item.dart';

// This class will eventually control how each pantry item
// is represented. However, as I'm having trouble updating the
// screen, the current item card WIP is found in item_card.dart where
// the changes can be seen

class ItemBuilder extends StatefulWidget {
  const ItemBuilder({super.key});

  @override
  State<ItemBuilder> createState() => _ItemBuilderState();
}

class _ItemBuilderState extends State<ItemBuilder> {
  Color getColor(Item item) {
    if (item.everyday == true) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  RealmResults<Item> items = PantryProxy().getPantryItems();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          height:
              80, // If remove the height, I get an error. If I make it higher to fit the initial item tile, it doesn't open. Bah.
          child: ItemCardSmall(item: items[index]),
        );
      },
    );
  }

  Card ItemCard(int index, BuildContext context) {
    return Card(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Colors.amber,
            width: 15,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text(
                    items[index].name!.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Wrap(
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  scrollable: true,
                                  content: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: EditItemForm(),
                                  ),
                                );
                              },
                            );
                            setState(() {});
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          highlightColor: Colors.red,
                          color: Colors.grey,
                          onPressed: () {
                            debugPrint("onPressed");
                            PantryProxy().toggleItemEveryday(items[index]);
                            setState(() {});
                          },
                          icon: const Icon(Icons.favorite)),
                    ],
                  ),
                  subtitle: Text(
                    "${items[index].mainCat!.toUpperCase()}, ${items[index].everyday.toString().toUpperCase()}",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemBuilder2 extends StatefulWidget {
  const ItemBuilder2({super.key, required this.items});
  final RealmResults<Item> items;

  @override
  State<ItemBuilder2> createState() => _ItemBuilder2State();
}

class _ItemBuilder2State extends State<ItemBuilder2> {
  Color getColor(Item item) {
    if (item.everyday == true) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: ItemCard(item: widget.items[index]),
        );
      },
    );
  }
}
