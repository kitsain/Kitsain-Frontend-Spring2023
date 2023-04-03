import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:kitsain_frontend_spring2023/views/forms/add_new_item_form.dart';
import 'package:kitsain_frontend_spring2023/views/forms/edit_item.dart';
import 'package:realm/realm.dart';
import '../../assets/item_card.dart';
import '../../database/pantry_proxy.dart';
import 'package:kitsain_frontend_spring2023/assets/itembuilder.dart';
import 'package:flutter/foundation.dart';

class PantryView extends StatefulWidget {
  late final Function(Item) onToggle;
  PantryView({super.key});

  @override
  State<PantryView> createState() => _PantryViewState();
}

class _PantryViewState extends State<PantryView> {
  Future<RealmResults<Item>> _getItems() async {
    return PantryProxy().getItems();
  }

  List<String> categories = <String>[
    'Meat',
    'Seafood',
    'Fruit',
    'Vegetables',
    'Frozen',
    'Drinks',
    'Bread',
    'Sweets',
    'Dairy',
    'Ready meals',
    'Dry & canned goods',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RealmResults>(
      future: _getItems(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text("Your pantry is empty."),
            ),
          );
        } else {
          if (snapshot.hasData) {
            return Scaffold(
              body: ListView(
                children: [
                  for (var cat in categories)
                    Column(
                      children: [
                        Text(cat),
                        ItemBuilder2(
                          items: PantryProxy().getByMainCat(cat),
                        ),
                      ],
                    )
                ],
              ),
              // body: Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     for (var cat in categories)
              //       Column(
              //         children: [
              //           Title(
              //             color: Colors.black,
              //             child: Text(cat),
              //           ),
              //           const ItemBuilder(),
              //         ],
              //       )
              //   ],
              // ),
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return const AlertDialog(
              //           scrollable: true,
              //           content: Padding(
              //             padding: EdgeInsets.all(8.0),
              //             child: NewItemForm(),
              //           ),
              //         );
              //       },
              //     );
              //   },
              //   child: const Icon(Icons.add),
              // ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text("Your pantry is empty."),
              ),
            );
          }
        }
      },
    );
  }
}

class Testing extends StatelessWidget {
  final RealmResults<Item> items;
  const Testing({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: getItemBuilder,
      shrinkWrap: true,
      itemCount: items.length,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
    );
  }

  Widget getItemBuilder(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      height: 80,
      child: const ItemBuilder(),
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
                    items[index].name.toUpperCase(),
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
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          highlightColor: Colors.red,
                          color: Colors.grey,
                          onPressed: () {
                            debugPrint("onPressed");
                            PantryProxy().toggleItemEveryday(items[index]);
                            ;
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
