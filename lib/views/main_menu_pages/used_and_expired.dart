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
              Stack(
                  children: <Widget>[
                    Container(
                      width: 230,
                      height: 180,
                      //color: Colors.black,
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      child: Container(
                        width: 200,
                        height: 150,
                        color: Colors.red,
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Center(
                child: ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: (int index) {
                      setState(() {
                        // The button that is tapped is set to true, and the others to false.
                        for (int i = 0; i < _selectedTabs.length; i++) {
                          _selectedTabs[i] = i == index;
                        }
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor: Colors.red[700],
                    selectedColor: Colors.white,
                    fillColor: Colors.red[200],
                    color: Colors.red[400],
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 80.0,
                    ),
                    children: tabs,
                    isSelected: _selectedTabs
                ),
              ),
              Flexible(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _selectedTabs[0] ? StateController.expiredList.length : StateController.usedList.length,
                  itemBuilder: (context, index) {
                  return ListTile(
                  title: Text(_selectedTabs[0] ? StateController.expiredList[index] : StateController.usedList[index]),
                    );
                  }
                ),
              )
              ],
              )
              );
  }
}


/*children: [
          DragTarget<String>(
            onAccept: (data) => _receiveItem(data),
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.50,
                height: MediaQuery.of(context).size.height * 0.20,
                color: Colors.lightGreen,
                alignment: Alignment.center,
                child: Text(_placeholderDataModel),
              );
            },
          ),
        ],*/

/*

            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
                child: Text(
                  'EXPIRED ITEMS',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
 */