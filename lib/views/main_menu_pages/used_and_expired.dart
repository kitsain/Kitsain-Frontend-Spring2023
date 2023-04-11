import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';

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
  String _placeholderDataModel = "Drop";
  final StateController = Get.put(ItemController());
  bool _customTileExpanded = false;
  final month = months[DateTime.now().month - 1];
  final year = DateTime.now().year;
  var _expDate = TextEditingController();
  var _openDate = TextEditingController();
  bool click = true;

  final List<bool> _selectedTabs = <bool>[true, false];

  _receiveItem(String data) {
    setState(() {
      _placeholderDataModel = data;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$data")));
    });
  }

  @override
  Widget build(BuildContext context) {
    _expDate.text = '01.01.1970';
    return Scaffold(
        body: ListView(
      children: [
        /*Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
            child: Text(
              'MONTH > $month $year',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),*/
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Center(
          child: ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _selectedTabs.length; i++) {
                    _selectedTabs[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 100.0,
              ),
              children: tabs,
              isSelected: _selectedTabs),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                                child: Icon(Icons.delete, size: 150,),
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
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: Text(_selectedTabs[0] ? " BIN" : " USED ITEMS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
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
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: ClipPath(
                              child: Container(
                              decoration: BoxDecoration(
                              border: Border(
                              left: BorderSide(color: Colors.black, width: 13),
                        ),
                      ),
                      child: ExpansionTile(
                        title: Text(
                        '${_selectedTabs[0] ? StateController.expiredList[index - 1] : StateController.usedList[index - 1]}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
                        subtitle: Text('ITEM CATEGORY'),
                        trailing: Transform.translate(
                          offset: Offset(0, -15),
                          child: Icon(Icons.more_horiz),
                          ),
                        leading: Transform.translate(
                          offset: Offset(0, 0),
                          child: Icon(Icons.fastfood, size: 35),
                          ),
                        )
                      ),
                      clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))
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
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: ClipPath(
                      child: Container(
                        decoration: BoxDecoration(
                        border: Border(
                        left: BorderSide(color: Colors.black, width: 13),
                          ),
                        ),
                        child: ExpansionTile(
                          title: Text(
                              '${_selectedTabs[0] ? StateController.expiredList[index - 1] : StateController.usedList[index - 1]}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
                          subtitle: Text('ITEM CATEGORY'),
                          trailing: Transform.translate(
                              offset: Offset(0, -15),
                              child: Icon(Icons.more_horiz),
                              ),
                          leading: Transform.translate(
                            offset: Offset(0, 0),
                            child: Icon(Icons.fastfood, size: 35),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 75),
                              child: TextField(
                                enabled: false,
                                controller: _openDate,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(Icons.edit_calendar_rounded),
                                    labelText: "OPENED"
                                ),
                                readOnly: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 75),
                              child: TextField(
                                  enabled: false,
                                  controller: _expDate,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(Icons.calendar_month),
                                      labelText: "EXPIRATION"
                                  ),
                                  readOnly: true,
                                ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 75),
                              child: Row(
                                children: [
                                  Icon(Icons.favorite_border, color: Colors.grey),
                                  SizedBox(width: 16),
                                  Text('MARK AS FAVORITE', style: TextStyle(color: Colors.grey),),
                                ]
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                            Padding(
                              padding: const EdgeInsets.only(left: 50, right: 20),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.55,
                                height: MediaQuery.of(context).size.height * 0.12,
                                child: TextField(
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
      )
    );
  }
}
