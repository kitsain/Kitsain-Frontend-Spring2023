import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/views/edit_item.dart';

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
                          builder: (BuildContext context) => const EditItem(),
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

class ItemCardTesting extends StatefulWidget {
  const ItemCardTesting({super.key});

  @override
  State<ItemCardTesting> createState() => _ItemCardTestingState();
}

class _ItemCardTestingState extends State<ItemCardTesting> {
  bool _isFavourite = false;
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
                    title: const Text(
                      "EXAMPLE ITEM",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Wrap(
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const EditItem(),
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
                    subtitle: Text(
                      "Categories go here".toUpperCase(),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: const <Widget>[
                  //     Icon(Icons.calendar_month),
                  //     Text("EXPIRATION DATE"),
                  //     Icon(Icons.calendar_today),
                  //     Text("OPENED"),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
