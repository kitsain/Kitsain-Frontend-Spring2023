import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/views/edit_item.dart';

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
