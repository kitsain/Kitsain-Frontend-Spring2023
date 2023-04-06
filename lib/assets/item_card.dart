import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'statuscolor.dart';

class ItemCard extends StatefulWidget {
  ItemCard({super.key, required this.item});
  late Item item;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: Container(
          width: 15,
          color: widget.item.bbDate == null
              ? Colors.grey
              : returnColor(widget.item.bbDate!),
        ),
        title: Text(widget.item.name),
        trailing: Wrap(
          children: <Widget>[
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          ],
        ),
        children: <Widget>[
          Column(
            children: [
              Text("Barcode: ${widget.item.barcode ?? 'Not added yet'}"),
              Text("Brand: ${widget.item.brand ?? 'Not added yet'}"),
              Text("Quantity: ${widget.item.quantity ?? 'Not added yet'}"),
              Text("Price: ${widget.item.price ?? 'Not added yet'}"),
              Text("Date added: ${widget.item.addedDate ?? 'Not added yet'}"),
              Text("Date opened: ${widget.item.openedDate ?? 'Not added yet'}"),
              Text(
                  "Expiration date: ${widget.item.expiryDate ?? 'Not added yet'}"),
              Text("Best before: ${widget.item.bbDate ?? 'Not added yet'}"),
              Text("Labels: ${widget.item.labels ?? 'Not added yet'}"),
              Text(
                  "Ingredients: ${widget.item.ingredients ?? 'Not added yet'}"),
              Text("Processing: ${widget.item.processing ?? 'Not added yet'}"),
              Text(
                  "Nutrition grade: ${widget.item.nutritionGrade ?? 'Not added yet'}"),
              Text("Nutriments: ${widget.item.nutriments ?? 'Not added yet'}"),
              Text(
                  "Ecoscore grade: ${widget.item.ecoscoreGrade ?? 'Not added yet'}"),
              Text("Packaging: ${widget.item.packaging ?? 'Not added yet'}"),
              Text("Origins: ${widget.item.origins ?? 'Not added yet'}"),
            ],
          ),
        ],
      ),
    );
  }
}
