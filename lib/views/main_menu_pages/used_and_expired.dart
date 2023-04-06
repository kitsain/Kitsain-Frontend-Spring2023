import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';

const List<Widget> tabs = <Widget>[
  Text('EXPIRED ITEMS'),
  Text('USED ITEMS'),
];

const List months =
['January', 'February', 'March', 'April', 'May','June','July','August','September',
  'October','November','December'];

class UsedAndExpired extends StatefulWidget {
  const UsedAndExpired({super.key});

  @override
  State<UsedAndExpired> createState() => _UsedAndExpiredState();
}

class _UsedAndExpiredState extends State<UsedAndExpired> {
  String _placeholderDataModel = "Drop";
  final StateController = Get.put(ItemController());
  bool _customTileExpanded = false;
  final month = months[DateTime.now().month -1];
  final year = DateTime.now().year;

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
    return Scaffold(
        body: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  //On the first iteration (index == 0) create the top part of the list. On next iterations create the item cards.
                  //Add 1 to list lengths in order to not lose one item because of this.
                  itemCount: _selectedTabs[0] ? StateController.expiredList.length+1 : StateController.usedList.length+1,
                  itemBuilder: (context, index) {
                    return index == 0 ? Column(
                      children: [
                        Align(
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
                                minWidth: 80.0,
                              ),
                              children: tabs,
                              isSelected: _selectedTabs
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        if(_selectedTabs[0])
                          Stack(
                            children: <Widget>[
                              Container(
                                width: 230,
                                height: 180,
                              ),
                              Positioned(
                                left: 20,
                                right: 20,
                                child: Container(
                                  width: 200,
                                  height: 150,
                                  color: Colors.red,
                                  alignment: Alignment.center,
                                  child: Text('Here the visual of wasted'),
                                ),
                              ),
                              Positioned(
                                top: 120,
                                left: 170,
                                right: 10,
                                bottom: 10,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 50,
                                  color: Colors.blue,
                                  child: Text('25 %'),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ) : Draggable<String>(
                      data: _selectedTabs[0] ? StateController.expiredList[index-1] : StateController.usedList[index-1],
                      onDragCompleted: () {
                        print('drag complete');
                        //StateController.pantryList.removeAt(index);
                      },
                      feedback: Material(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: ListTile(
                            tileColor: Colors.lightGreen,
                            title: Text('${_selectedTabs[0] ? StateController.expiredList[index-1] : StateController.usedList[index-1]}'),
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text('${_selectedTabs[0] ? StateController.expiredList[index-1] : StateController.usedList[index-1]}'),
                      ),
                    );
                  }
              ),
            )
          ],
        )
    );
  }
}