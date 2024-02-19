// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:kitsain_frontend_spring2023/database/recipes_proxy.dart';
import 'package:kitsain_frontend_spring2023/views/edit_forms/edit_item_form.dart';
import 'statuscolor.dart';
import 'package:kitsain_frontend_spring2023/categories.dart';

enum _MenuValues {
  edit,
  delete,
}

const double BORDER_WIDTH = 30.0;
const Color NULL_STATUS_COLOR = Color(0xffF0EBE5);
const Color NULL_TEXT_COLOR = Color(0xff979797);

class RecipeCard extends StatefulWidget {
  RecipeCard({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  void deleteItem(Recipe recipe) {
    realm.write(() {
      realm.delete(recipe);
    });
  }

  bool showAbbreviation = true;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Recipe>(
      data: widget.recipe,
      onDragCompleted: () {},
      feedback: _buildFeedbackWidget(),
      child: _buildRecipeCardWidget(),
    );
  }

  Widget _buildFeedbackWidget() {
    return SizedBox(
      height: 85,
      width: 320,
      child: Card(
        elevation: 7,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: ClipPath(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: NULL_STATUS_COLOR,
                  width: BORDER_WIDTH,
                ),
              ),
            ),
            child: ListTile(
              title: Text(
                widget.recipe.name.toUpperCase(),
                style: AppTypography.heading3,
              ),
            ),
          ),
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCardWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Card(
        elevation: 7,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
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
                      color: NULL_STATUS_COLOR,
                      width: BORDER_WIDTH,
                    ),
                  ),
                ),
                child: ExpansionTile(
                  onExpansionChanged: (val) => setState(() => showAbbreviation = !val),
                  title: Text(
                    widget.recipe.name.toUpperCase(),
                    style: AppTypography.heading3.copyWith(color: Colors.black),
                  ),
                  children: [
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    if (widget.recipe.details != null) ...[
                      _buildDetailsContainer(widget.recipe.details!),
                    ] else ...[
                      _buildDetailsContainer('[{"details":"1"},["details"]]', color: NULL_TEXT_COLOR),
                    ],
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsContainer(String details, {Color? color}) {
  print(details);
  dynamic parsedJson = jsonDecode(details);

  // Separate the two parts
  Map<String, dynamic> ingredients = parsedJson[0];
  List<dynamic> steps = parsedJson[1];

  // Create a widget for ingredients
  Widget ingredientsWidget = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
      for (var entry in ingredients.entries)
        Text('${entry.key}: ${entry.value}'),
    ],
  );

  // Create a widget for steps
  Widget stepsWidget = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10),
      Text('Steps:', style: TextStyle(fontWeight: FontWeight.bold)),
      for (int i = 0; i < steps.length; i++)
        Text('${i + 1}. ${steps[i]}'),
    ],
  );

  return Container(
    width: 200,
    decoration: BoxDecoration(
      border: Border.all(color: color ?? Colors.black),
    ),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ingredientsWidget,
          stepsWidget,
        ],
      ),
    ),
  );
}
}
