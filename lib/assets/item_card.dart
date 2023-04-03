import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'package:kitsain_frontend_spring2023/views/forms/edit_item.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
// Original card without the status colour and with dates

class ItemCard extends StatefulWidget {
  const ItemCard({super.key});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool _isFavourite = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              "Example item".toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Wrap(
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const EditItemForm(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                    color: _isFavourite ? Colors.red : Colors.grey,
                    onPressed: () {
                      setState(() {
                        _isFavourite = !_isFavourite;
                      });
                    },
                    icon: const Icon(Icons.favorite)),
              ],
            ),
            subtitle: Text("Categories go here".toUpperCase()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
              Icon(Icons.calendar_month),
              Text("EXPIRATION DATE"),
              Icon(Icons.calendar_today),
              Text("OPENED"),
            ],
          ),
        ],
      ),
    );
  }
}

// Smaller card without dates

class ItemCardSmall extends StatefulWidget {
  ItemCardSmall({super.key, required this.item});
  late Item item;

  @override
  State<ItemCardSmall> createState() => _ItemCardSmallState();
}

class _ItemCardSmallState extends State<ItemCardSmall> {
  bool _isFavourite = false;

  Color getColor(Item item) {
    if (item.everyday == true) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      width: 25.0,
      height: 80,
      child: Card(
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
                      widget.item.name!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Wrap(
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const EditItemForm(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            color: getColor(widget.item),
                            onPressed: () {
                              PantryProxy().toggleItemEveryday(widget.item);
                              setState(() {
                                _isFavourite = !_isFavourite;
                              });
                            },
                            icon: const Icon(Icons.favorite)),
                      ],
                    ),
                    subtitle: Text(
                      widget.item.mainCat!.toUpperCase(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// https://pub.dev/packages/expansion_tile_card#expansion_tile_card
// https://medium.flutterdevs.com/explore-expansion-tile-card-in-flutter-fe995beb6845
class ItemTile extends StatefulWidget {
  const ItemTile({super.key, required this.item});
  final Item item;

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();

  // Example item
  var item = PantryProxy().getPantryItems()[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ExpansionTileCard(
      key: cardA,
      title: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ListTile(
                  leading: Container(
                    color: Colors.amber,
                    width: 15,
                  ),
                  title: Text(
                    item.name.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Wrap(
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const EditItemForm(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          color: Colors.red,
                          onPressed: () {
                            setState(() {});
                          },
                          icon: const Icon(Icons.favorite)),
                    ],
                  ),
                  subtitle: Text(
                    item.mainCat!.toUpperCase(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      children: <Widget>[
        ListTile(
          leading: Container(
            color: Colors.amber,
            width: 15,
          ),
        )
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 50),
        //     child: Container(
        //       color: Colors
        //           .amber, // Just to see where the column is currently located :3
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text("Barcode: ${item.barcode ?? 'Not added yet'}"),
        //           Text("Brand: ${item.brand ?? 'Not added yet'}"),
        //           Text("Quantity: ${item.quantity ?? 'Not added yet'}"),
        //           Text("Price: ${item.price ?? 'Not added yet'}"),
        //           Text("Date added: ${item.addedDate ?? 'Not added yet'}"),
        //           Text("Date opened: ${item.openedDate ?? 'Not added yet'}"),
        //           Text(
        //               "Expiration date: ${item.expiryDate ?? 'Not added yet'}"),
        //           Text("Best before -date: ${item.bbDate ?? 'Not added yet'}"),
        //           Text("Labels: ${item.labels.length ?? 'Not added yet'}"),
        //           Text("Ingredients: ${item.ingredients ?? 'Not added yet'}"),
        //           Text("Processing: ${item.processing ?? 'Not added yet'}"),
        //           Text(
        //               "Nutrition grade: ${item.nutritionGrade ?? 'Not added yet'}"),
        //           Text("Nutriments: ${item.nutriments ?? 'Not added yet'}"),
        //           Text(
        //               "Ecoscore grade: ${item.ecoscoreGrade ?? 'Not added yet'}"),
        //           Text("Packaging: ${item.packaging ?? 'Not added yet'}"),
        //           Text("Origins: ${item.origins ?? 'Not added yet'}"),
        //         ],
        //       ),
        //     ),
        //   ),
        // )
      ],
    ));
  }
}

class TestTile extends StatefulWidget {
  const TestTile({super.key});

  @override
  State<TestTile> createState() => _TestTileState();
}

class _TestTileState extends State<TestTile> {
  var item = PantryProxy().getPantryItems()[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpansionTileCard(
        title: Text(item.name.toUpperCase()),
        initialElevation: 2,
        baseColor: Colors.green,
        initialPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        leading: Container(
          color: Colors.amber,
          width: 15,
        ),
        trailing: Wrap(
          children: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const EditItemForm(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                color: Colors.red,
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(Icons.favorite)),
          ],
        ),
        subtitle: Text(
          item.mainCat!.toUpperCase(),
        ),
        children: <Widget>[
          Row(
            children: [
              Container(
                color: Colors.amber,
                width: 15,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text("Barcode: ${item.barcode ?? 'Not added yet'}"),
                    Text("Brand: ${item.brand ?? 'Not added yet'}"),
                    Text("Quantity: ${item.quantity ?? 'Not added yet'}"),
                    Text("Price: ${item.price ?? 'Not added yet'}"),
                    Text("Date added: ${item.addedDate ?? 'Not added yet'}"),
                    Text("Date opened: ${item.openedDate ?? 'Not added yet'}"),
                    Text(
                        "Expiration date: ${item.expiryDate ?? 'Not added yet'}"),
                    Text(
                        "Best before -date: ${item.bbDate ?? 'Not added yet'}"),
                    Text("Labels: ${item.labels.length ?? 'Not added yet'}"),
                    Text("Ingredients: ${item.ingredients ?? 'Not added yet'}"),
                    Text("Processing: ${item.processing ?? 'Not added yet'}"),
                    Text(
                        "Nutrition grade: ${item.nutritionGrade ?? 'Not added yet'}"),
                    Text("Nutriments: ${item.nutriments ?? 'Not added yet'}"),
                    Text(
                        "Ecoscore grade: ${item.ecoscoreGrade ?? 'Not added yet'}"),
                    Text("Packaging: ${item.packaging ?? 'Not added yet'}"),
                    Text("Origins: ${item.origins ?? 'Not added yet'}"),
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
