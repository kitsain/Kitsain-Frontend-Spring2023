// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:kitsain_frontend_spring2023/database/recipes_proxy.dart';
import 'package:kitsain_frontend_spring2023/views/edit_forms/edit_item_form.dart';
import 'statuscolor.dart';
import 'package:kitsain_frontend_spring2023/categories.dart';

enum _MenuValues {
  edit,
// shoppinglist,
  delete,
}

const double BORDERWIDTH = 30.0;
const Color NULLSTATUSCOLOR = Color(0xffF0EBE5);
const Color NULLTEXTCOLOR = Color(0xff979797);


class RecipeCard extends StatefulWidget {
  RecipeCard({super.key, required this.recipe});
  late Recipe recipe;
  late String loc;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  void deleteItem(Recipe recipe) {
    realm.write(
      () {
        realm.delete(recipe);
      },
    );
  }

/*   void _editRecipe(Recipe recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          child: EditItemForm(item: recipe),
        );
      },
    );
  } */

  bool showAbbreviation = true;

  @override
  Widget build(BuildContext context) {
    var popupMenuButton = PopupMenuButton<_MenuValues>(
      icon: const Icon(Icons.more_horiz,
        color: Colors.black,
      ),
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            value: _MenuValues.edit,
            child: Text("Edit item", style: AppTypography.smallTitle,),
          ),
          //const PopupMenuItem(
          //  value: _MenuValues.shoppinglist,
          //  child: Text(
          //    "Move to shopping list",
          //    style: AppTypography.smallTitle
          //  ),
          //),
          const PopupMenuItem(
            value: _MenuValues.delete,
            child: Text("Delete item", style: AppTypography.smallTitle,),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          // case _MenuValues.shoppinglist:
          //   break;
          case _MenuValues.delete:
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Delete item", style: AppTypography.heading3,),
                content: const Text(
                    "Are you sure you want to delete this item? This action cannot be undone.",
                  style: AppTypography.paragraph,),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Cancel"),
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.resolveWith((states) => AppTypography.category),
                      foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.cancelGrey),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteItem(widget.recipe);
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Delete"),
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.resolveWith((states) => AppTypography.category),
                      foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main1),
                    )
                  )
                ],
              ),
            );
            break;
        }
      },
    );

    var popupMenuButtonHistory = PopupMenuButton<_MenuValues>(
      icon: const Icon(Icons.more_horiz,
        color: Colors.black,
      ),
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            value: _MenuValues.delete,
            child: Text("Delete item", style: AppTypography.smallTitle,),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          // case _MenuValues.shoppinglist:
          //   break;
          case _MenuValues.delete:
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Delete item", style: AppTypography.heading3,),
                content: const Text(
                    "Are you sure you want to delete this item? This action cannot be undone.",
                style: AppTypography.paragraph,),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Cancel"),
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.resolveWith((states) => AppTypography.category),
                      foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.cancelGrey),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteItem(widget.recipe);
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Delete"),
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.resolveWith((states) => AppTypography.category),
                      foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main1),
                    )
                  ),
                ],
              ),
            );
            break;
          case _MenuValues.edit:
            break;
        }
      },
    );

    return LongPressDraggable<Recipe>(
      data: widget.recipe,
      onDragCompleted: () {},
      feedback: SizedBox(
        height: 85,
        width: 320,
        child: Card(
          elevation: 7,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: ClipPath(
            // The following container is the item card during dragging
            child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        color: NULLSTATUSCOLOR,
                        width: BORDERWIDTH),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    widget.recipe.name.toUpperCase(),
                    style: AppTypography.heading3,
                  ),
                )),
            clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Card(
          // This card is the normal card in the pantry
          elevation: 7,
          shape: const RoundedRectangleBorder(
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
                          color: NULLSTATUSCOLOR,
                          width: BORDERWIDTH),
                    ),
                  ),
                  child: ExpansionTile(
                    onExpansionChanged: (val) =>
                        setState(() => showAbbreviation = !val),
                    title: Text(
                      widget.recipe.name.toUpperCase(),
                      style: AppTypography.heading3.copyWith(color: Colors.black),
                    ),
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      if (widget.recipe.details != null) ...[
                        Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(widget.recipe.details!,
                              style: AppTypography.paragraph,
                            ),
                          ),
                        ),
                      ] else ...[
                        Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: NULLTEXTCOLOR),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "Details",
                              style: AppTypography.paragraph.copyWith(color: NULLTEXTCOLOR),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
