import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const List<List<String>> paragraphs = [
  [
    "Once you've opened a shopping list, you",
    'can manage its contents.'
  ],
  [
    'While grocery shopping, you can check off',
    "items as you go. Once you're done, you can",
    'move all checked items to pantry. This',
    "doesn't remove items from the",
    'shopping lists, so you can keep reusing the',
    'same list over and over if you want to!'
  ],
  [
    'Add items to the shopping list either by',
    'hand or by using your phone as an EAN',
    'code scanner. Item needs to be sorted to a',
    'category upon adding, and you can add a',
    'description.'
  ],
  [
    'Other details, like an expiration date can',
    'be added after you move it to the pantry'
  ]
];

class UserShoppingListHelp extends StatefulWidget {
  const UserShoppingListHelp({super.key});

  @override
  State<UserShoppingListHelp> createState() => _UserShoppingListHelp();
}

class _UserShoppingListHelp extends State<UserShoppingListHelp> {

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
                Text("WHAT CAN I DO", style: TextStyle(fontSize: 35)),
                Text("WITH AN OPENED", style: TextStyle(fontSize: 35)),
                Text("SHOPPING LIST?", style: TextStyle(fontSize: 35)),
                SizedBox(height: 15),
                _createParagraph(paragraphs[0], true),
                _createParagraph(paragraphs[1], true),
                _createParagraph(paragraphs[2], true),
                _createParagraph(paragraphs[3], false),
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
