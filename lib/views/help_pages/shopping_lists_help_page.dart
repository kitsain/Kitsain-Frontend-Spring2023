import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    'designated shopping list.'
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
    for(var line in paragraph) {
      list.add(Text(line, style: TextStyle(fontSize: 15)));
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
                          child: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          }
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text("WHAT'S IN", style: TextStyle(fontSize: 35)),
                Text("SHOPPING LISTS?", style: TextStyle(fontSize: 35)),
                SizedBox(height: 15),
                _createParagraph(paragraphs[0], true),
                _createParagraph(paragraphs[1], true),
                _createParagraph(paragraphs[2], false),
                SizedBox(height: 50),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("GOT IT"),
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
