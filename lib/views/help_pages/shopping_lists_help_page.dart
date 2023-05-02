import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';

const List<List<String>> paragraphs = [
  [
    'In shopping lists, you can manage your',
    'grocery shopping through personal or',
    'shared shopping lists. Kitsain shopping',
    'lists is connected to Google Tasks so you',
    'can access them easily outside of the app.'
  ],
  [
    'You can create a new shopping through the',
    'icon in the top banner. Items can be either',
    'dragged or sent via options into a',
    'designated shopping list. The destination',
    'list will be indicated with a border.'
  ],
  [
    'You can add a new item to you pantry',
    'either by hand or using your phones',
    'camera as an EAN code scanner. You can',
    'edit an item card anytime via the options',
    'icon on the card.'
  ],
];

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
    for (var line in paragraph) {
      list.add(Text(line, style: AppTypography.paragraph));
      //After last row don't add empty space
      if (line != paragraph[paragraph.length - 1]) {
        list.add(SizedBox(height: 3));
      }
    }

    return new Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: AppColors.main2,
        body: ListView(children: <Widget>[
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
                        }),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                "WHAT'S IN\nSHOPPING LISTS?",
                style: AppTypography.heading2.copyWith(color: AppColors.main3),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              _createParagraph(paragraphs[0], true),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/shopping_list_help.png"),
                    // fit: BoxFit.cover,
                    // alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
              _createParagraph(paragraphs[1], true),
              SizedBox(height: 50),
              SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith(
                        (states) => AppColors.main2),
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => AppColors.main3),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "GOT IT",
                    style: AppTypography.category,
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ]),
      );
    });
  }
}
