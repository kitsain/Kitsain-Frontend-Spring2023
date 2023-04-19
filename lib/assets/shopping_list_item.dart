import 'package:flutter/material.dart';

class ShoppingListItem extends StatefulWidget {
  const ShoppingListItem({super.key, required this.itemName, this.itemDescription = ''});

  final String itemName;
  final String itemDescription;

  @override
  State<ShoppingListItem> createState() => _ShoppingListItemState();
}


class _ShoppingListItemState extends State<ShoppingListItem> {
  bool? _selected = false;

  _checkBoxChanged(newValue) {
    setState(() {
      _selected = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.itemName),
                  Text(
                    widget.itemDescription,//'Additional description',
                    style: TextStyle(color: Colors.black45),
                  ),
                ],
              ),
              Spacer(),
              Checkbox(
                  value: _selected,
                  onChanged: (newValue) => _checkBoxChanged(newValue)),
            ],
          ),
          Divider(height: 1,),
        ],
      ),
    );
  }
}