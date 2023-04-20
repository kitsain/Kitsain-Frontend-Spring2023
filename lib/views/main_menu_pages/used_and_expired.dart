import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';
import 'package:kitsain_frontend_spring2023/assets/top_bar.dart';

const List<Widget> tabs = <Widget>[
  Text('USED'),
  Text('BIN'),
];

const List months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

const List<String> testShoppingLists = <String>[
  'Shopping list test 1',
  'Shopping list test 2',
  'Shopping list test 3',
  'Shopping list test 4',
  'Shopping list test 5',
  'Shopping list test 6',
  'Shopping list test 7',
  'Shopping list test 8'
];

class UsedAndExpired extends StatefulWidget {
  const UsedAndExpired({super.key});

  @override
  State<UsedAndExpired> createState() => _UsedAndExpiredState();
}

class _UsedAndExpiredState extends State<UsedAndExpired> {
  final StateController = Get.put(ItemController());
  var _expDate = TextEditingController();
  var _openDate = TextEditingController();
  var _details = TextEditingController();
  String _shoppingList = testShoppingLists.first;
  bool _favorite = false;

  final month = months[DateTime.now().month -1];
  final year = DateTime.now().year;

  final List<bool> _selectedTabs = <bool>[true, false];

  _receiveItem(String data) {
    setState(() {
      //_placeholderDataModel = data;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$data")));
    });
  }

  _shoppingLists() {
    List<PopupMenuItem<String>> list = <PopupMenuItem<String>>[];
    for(var sList in testShoppingLists) {
      list.add(PopupMenuItem<String>(
          child: Text(sList, textAlign: TextAlign.left),
          onTap: () {Navigator.pop(context);}
        ));
    }
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: list
      );
  }

  _addToShoppingDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Move to shopping list'),
          content:
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                menuMaxHeight: 200,
                value: _shoppingList,
                icon: Positioned(
                    right: 30,
                    child: Icon(Icons.arrow_drop_down)),
                decoration: InputDecoration.collapsed(
                    hintText: ''),
                onChanged: (String? value) {
                  setState(() {
                    _shoppingList = value!;
                  });
                },
                items: testShoppingLists.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('DONE'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
    );
  }

  Widget _actionPopUpMenu() {
    return PopupMenuButton(
      constraints: BoxConstraints(maxHeight: 300, maxWidth: 200),
      icon: Icon(Icons.more_horiz, color: Colors.black),
      onSelected: (newValue) {
        setState(() {
          if(newValue == "0") {
            //Move to bin or used
          }else if(newValue == "1") {
            //Add to shopping list
            _addToShoppingDialog();
          } else {
            //Add to pantry
          }
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Item action",
                    style: TextStyle(color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_drop_up, color: Colors.black, size: 35)
                )
              ],
            ),
        ),
        PopupMenuItem<String>(
          child: Text( _selectedTabs[0] ? "MOVE TO BIN": "MOVE TO USED",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          value: "0",
        ),
        PopupMenuItem(
          child: Text('ADD TO SHOPPING', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          value: "1",
        ),
        PopupMenuItem(
          child: Text("ADD TO PANTRY",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          value: "2",
        ),
      ],
    );
  }

  _temp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(
          title: AppLocalizations.of(context)!.historyScreen,
          helpFunction: _temp,
          backgroundImageName: 'assets/images/ue_banner_darker_B2.png',
          titleBackgroundColor: Color.fromRGBO(152, 88, 75, 0.75),
        ),
        body: DragTarget<String>(
        onAccept: (data) => _receiveItem(data),
        builder: (context, candidateData, rejectedData) {
          return Container(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                      child: Text(
                        'MONTH > $month $year',
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Center(
                  child: DragTarget<String>(
                    onWillAccept: (data) {
                      _selectedTabs[0] = !_selectedTabs[0];
                      _selectedTabs[1] = !_selectedTabs[1];
                      return true;
                    },
                    builder: (context, candidateData, rejectedData) {
                      return ToggleButtons(
                          direction: Axis.horizontal,
                          onPressed: (int index) {
                            setState(() {
                              for (int i = 0; i < _selectedTabs.length; i++) {
                                _selectedTabs[i] = i == index;
                              }
                            });
                          },
                          borderRadius: const BorderRadius.all(Radius.circular(
                              8)),
                          constraints: const BoxConstraints(
                            minHeight: 40.0,
                            minWidth: 100.0,
                          ),
                          isSelected: _selectedTabs,
                          children: tabs);
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        //On the first iteration (index == 0) create the graph. On next iterations create the item cards.
                        //Add 1 to list lengths in order to not lose one item because of this.
                        itemCount: _selectedTabs[0]
                            ? StateController.usedList.length + 1
                            : StateController.expiredList.length + 1,
                        itemBuilder: (context, index) {
                          return index == 0
                              ? Column(
                            children: [
                              Stack(
                                children: <Widget>[
                                  Container(
                                    width: 360,
                                    height: 170,
                                  ),
                                  Positioned(
                                    top: -17,
                                    left: 20,
                                    right: 20,
                                    child: Icon(Icons.circle, size: 200,
                                        color: Colors.amber),
                                  ),
                                  Positioned(
                                    top: 90,
                                    left: 190,
                                    right: 10,
                                    bottom: 10,
                                    child: Text(
                                      '25%',
                                      style: TextStyle(fontSize: 60),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.03,
                                    child: Text(
                                      _selectedTabs[0] ? " USED ITEMS": " BIN",
                                      style: TextStyle(fontSize: 25,
                                          fontWeight: FontWeight.bold),)
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                            ],
                          )
                              : LongPressDraggable<String>(
                              data: _selectedTabs[0]
                                  ? StateController.usedList[index - 1]
                                  : StateController.expiredList[index - 1],
                              onDragCompleted: () {
                                print('drag complete');
                                //StateController.pantryList.removeAt(index);
                              },
                              feedback: Container(
                                height: 85,
                                width: 320,
                                child: Card(
                                  elevation: 7,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  child: ClipPath(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                                color: Colors.black, width: 13),
                                          ),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                              '${_selectedTabs[0]
                                                  ? StateController
                                                  .usedList[index - 1]
                                                  : StateController
                                                  .expiredList[index - 1]}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 23)),
                                          subtitle: Text('ITEM CATEGORY', style: TextStyle(color: Colors.black)),
                                          trailing: Transform.translate(
                                            offset: Offset(0, -15),
                                            child: Icon(Icons.more_horiz),
                                          ),
                                          leading: Transform.translate(
                                            offset: Offset(0, 0),
                                            child: Icon(
                                                Icons.fastfood, size: 35),
                                          ),
                                        )
                                    ),
                                    clipper: ShapeBorderClipper(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                5))
                                    ),
                                  ),
                                ),
                              ),
                              child: Card(
                                elevation: 7,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                ),
                                child: ClipPath(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            color: Colors.black, width: 13),
                                      ),
                                    ),
                                    child: ExpansionTile(
                                      title: Text(
                                          '${_selectedTabs[0]
                                              ? StateController
                                              .usedList[index - 1]
                                              : StateController.expiredList[index -
                                              1]}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 23)),
                                      subtitle: Text('ITEM CATEGORY'),
                                      trailing: Transform.translate(
                                          offset: Offset(0, -15),
                                          child: _actionPopUpMenu()
                                      ),
                                      leading: Transform.translate(
                                        offset: Offset(0, 0),
                                        child: Icon(Icons.fastfood, size: 35),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 75),
                                          child: TextField(
                                            enabled: false,
                                            controller: _openDate,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(Icons
                                                    .edit_calendar_rounded),
                                                labelText: "OPENED"
                                            ),
                                            readOnly: true,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 75),
                                          child: TextField(
                                            enabled: false,
                                            controller: _expDate,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(
                                                    Icons.calendar_month),
                                                labelText: "EXPIRATION"
                                            ),
                                            readOnly: true,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 75),
                                          child: Row(
                                              children: [
                                                Icon(_favorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                    color: Colors.grey),
                                                SizedBox(width: 16),
                                                Text('MARK AS FAVORITE',
                                                  style: TextStyle(
                                                      color: Colors.grey),),
                                              ]
                                          ),
                                        ),
                                        SizedBox(height: MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.02),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 50, right: 20),
                                          child: SizedBox(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.55,
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .height * 0.12,
                                            child: TextField(
                                              enabled: false,
                                              readOnly: true,
                                              controller: _details,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Details',
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  clipper: ShapeBorderClipper(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      )
                                  ),
                                ),
                              )
                          );
                        }),
                  ),
                )
              ],
            ),
          );
        }
        )
        );
  }
}
