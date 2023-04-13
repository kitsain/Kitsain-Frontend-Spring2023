import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';

const List<Widget> tabs = <Widget>[
  Text('BIN'),
  Text('USED'),
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
  bool _favorite = false;

  final List<bool> _selectedTabs = <bool>[true, false];

  _receiveItem(String data) {
    setState(() {
      //_placeholderDataModel = data;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$data")));
    });
  }

  _moveToDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text('Discard changes?'),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('DISCARD'),
              onPressed: () {
                Navigator.pop(context);
                //Navigator.pop(context);
              },
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DragTarget<String>(
        onAccept: (data) => _receiveItem(data),
        builder: (context, candidateData, rejectedData) {
          return Container(
            child: ListView(
              children: [
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.02),
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
                          children: tabs,
                          isSelected: _selectedTabs);
                    }
                  ),
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.02),
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
                            ? StateController.expiredList.length + 1
                            : StateController.usedList.length + 1,
                        itemBuilder: (context, index) {
                          return index == 0
                              ? Column(
                            children: [
                              SizedBox(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.01),
                              if (_selectedTabs[0])
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      width: 360,
                                      height: 170,
                                    ),
                                    Positioned(
                                      left: 20,
                                      right: 20,
                                      child: Container(
                                        width: 10,
                                        height: 150,
                                        //color: Colors.red,
                                        alignment: Alignment.center,
                                        child: Icon(Icons.circle, size: 150,
                                            color: Colors.amber),
                                      ),
                                    ),
                                    Positioned(
                                      top: 110,
                                      left: 225,
                                      right: 10,
                                      bottom: 10,
                                      child: Text(
                                        '25%',
                                        style: TextStyle(fontSize: 40),
                                      ),
                                    ),
                                  ],
                                ),
                              if(_selectedTabs[0])
                                SizedBox(height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.02),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.03,
                                    child: Text(
                                      _selectedTabs[0] ? " BIN" : " USED ITEMS",
                                      style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),)
                                ),
                              ),
                              //SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            ],
                          )
                              : LongPressDraggable<String>(
                              data: _selectedTabs[0]
                                  ? StateController.expiredList[index - 1]
                                  : StateController.usedList[index - 1],
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
                                        child: ExpansionTile(
                                          title: Text(
                                              '${_selectedTabs[0]
                                                  ? StateController
                                                  .expiredList[index - 1]
                                                  : StateController
                                                  .usedList[index - 1]}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 23)),
                                          subtitle: Text('ITEM CATEGORY'),
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
                                              .expiredList[index - 1]
                                              : StateController.usedList[index -
                                              1]}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 23)),
                                      subtitle: Text('ITEM CATEGORY'),
                                      trailing: Transform.translate(
                                          offset: Offset(10, -15),
                                          child: IconButton(
                                              icon: Icon(Icons.more_horiz),
                                              onPressed: (){
                                                _moveToDialog();
                                              },
                                              color: Colors.black,
                                              iconSize: 30,
                                          ),
                                      ),
                                        /*child: IconButton(
                                            onPressed: (){
                                            _moveToDialog();
                                            },
                                            icon: Icon(Icons.more_horiz),
                                            alignment: Alignment.topRight,
                                        ),*/
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
