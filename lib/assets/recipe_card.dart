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
import 'package:kitsain_frontend_spring2023/database/openaibackend.dart';

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

/*   void _editItem() async {
    var generatedRecipe = await changeRecipe(
        "chicken, pasta, tomato, pesto, anjovis, chocolate, mint",
        recipeType,
        expSoon,
        supplies,
        "True");

    RecipeProxy().upsertRecipe(generatedRecipe);
  }
 */
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
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildDetailsScreen(context, widget.recipe.details!, widget.recipe.name),
          );
        },
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
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.recipe.name.toUpperCase(),
                          style: AppTypography.heading3.copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildChangeButton(String text, Color? color, String recipeName) {
    return ElevatedButton(
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildChangeAlert(context, recipeName),
        );
      }
    );
  }

  Widget _buildDeleteButton(String text, Color? color, String recipeName) {
    return ElevatedButton(
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildDeleteAlert(context, recipeName),
        );
      }
    );
  }

  Widget _buildDetailsScreen(BuildContext context, String details, String recipeName) {
    dynamic parsedJson = jsonDecode(details);
    Map<String, dynamic> ingredients = parsedJson[0];
    List<dynamic> steps = parsedJson[1];

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(recipeName, style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
          for (var entry in ingredients.entries)
            Text('${entry.key}: ${entry.value}'),
          Text('Steps:', style: TextStyle(fontWeight: FontWeight.bold)),
          for (int i = 0; i < steps.length; i++)
            Text('${i + 1}. ${steps[i]}'),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildChangeButton("Change", Colors.grey[200], recipeName),
            _buildDeleteButton("Delete", Colors.grey[200], recipeName),
          ],
        ),
      ],
    );
  }

  Widget _buildChangeAlert(BuildContext context, String recipeName) {
    return AlertDialog(
      title: Text('Change recipe'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Please enter wanted changes to'),
          Text(recipeName, style: const TextStyle(fontWeight: FontWeight.bold)),
          Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 8,
                decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
              ),
            )
          )
          ],
        ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              // Call change functionality here
            },
            child: const Text('Change'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ]
        ),
      ],
    );
  }

  Widget _buildDeleteAlert(BuildContext context, String recipeName) {
    return AlertDialog(
      title: Text('Delete recipe'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Are you sure you want to delete $recipeName')
          ],
        ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              deleteItem(widget.recipe);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ]
        ),
      ],
    );
  }

  /* Widget _buildDetailsContainer(String details, {Color? color}) {
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
        for (int i = 0; i < steps.length; i++) Text('${i + 1}. ${steps[i]}'),
      ],
    );

    return Container(
      width: 100,
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
  } */
}
