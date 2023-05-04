import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';
import 'package:realm/realm.dart';


class ShoppingListsHelp extends StatefulWidget {
  const ShoppingListsHelp({super.key});

  @override
  State<ShoppingListsHelp> createState() => _ShoppingListsHelp();
}

class _ShoppingListsHelp extends State<ShoppingListsHelp> {

  //Helper function for creating texts and icons.
  //Returns text and icon widgets.
  Widget _createParagraph(List<String> paragraph, bool icons) {
    List<Widget> list = <Widget>[];
    for(var line in paragraph) {
      list.add(Text(line, style: AppTypography.paragraph));
      //After last row don't add empty space
      if(line != paragraph[paragraph.length -1]) {
        list.add(SizedBox(height: 3));
      }
    }
    if(icons) {
      list.add(Row(
        children: [
          Icon(Icons.check_box_outline_blank, size: 180),
          Icon(Icons.check_box_outline_blank, size: 180),
        ],
      ));
    }
    return new Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> paragraphs = [
      AppLocalizations.of(context)!.allListsHelpText1.split("\n"),
      AppLocalizations.of(context)!.allListsHelpText2.split("\n"),
      // [
      //   'You can add a new item to you pantry',
      //   'either by hand or using your phones',
      //   'camera as an EAN code scanner. You can',
      //   'edit an item card anytime via the options',
      //   'icon on the card.'
      // ],
    ];
    return Builder(builder: (context) {
      return ListView(
          children: <Widget> [
            Column(
              children: [
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: FloatingActionButton(
                        foregroundColor: AppColors.main2,
                        backgroundColor: AppColors.main3,
                        child: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        }
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(AppLocalizations.of(context)!.allListsHelpTitle,
                  style: AppTypography.heading2.copyWith(color: AppColors.main3),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                _createParagraph(paragraphs[0], true),
                _createParagraph(paragraphs[1], false),
                SizedBox(height: 50),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main2),
                      backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main3),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.closeHelpSection,
                      style: AppTypography.category,
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ]
      );
    });
  }
}
