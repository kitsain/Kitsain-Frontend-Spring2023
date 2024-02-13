import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/assets/recipe_card.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';

// In this file we build the list of item cards, either in the pantry
// or in the history tab

class RecipeBuilder extends StatefulWidget {
  const RecipeBuilder(
      {super.key,
      required this.recipes,
      required this.sortMethod});
  final RealmResults<Recipe> recipes;
  final String sortMethod;

  @override
  State<RecipeBuilder> createState() => _RecipeBuilderState();
}

class _RecipeBuilderState extends State<RecipeBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.recipes.length,
      itemBuilder: (context, index) {
          return RecipeCard(
            recipe: widget.recipes[index],
          );
      },
    );
  }
}
