import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';

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

class UsedAndExpired extends StatefulWidget {
  const UsedAndExpired({super.key});

  @override
  State<UsedAndExpired> createState() => _UsedAndExpiredState();
}

class _UsedAndExpiredState extends State<UsedAndExpired> {
  var _expDate = TextEditingController();
  var _openDate = TextEditingController();
  var _details = TextEditingController();
  bool _favorite = false;

  final month = months[DateTime.now().month - 1];
  final year = DateTime.now().year;

  final List<bool> _selectedTabs = <bool>[true, false];

  _receiveItem(String data) {
    setState(() {
      //_placeholderDataModel = data;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DragTarget<String>(
        onAccept: (data) => _receiveItem(data),
        builder: (context, candidateData, rejectedData) {
          return ListView(
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
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                          setState(
                            () {
                              for (int i = 0; i < _selectedTabs.length; i++) {
                                _selectedTabs[i] = i == index;
                              }
                            },
                          );
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        constraints: const BoxConstraints(
                          minHeight: 40.0,
                          minWidth: 100.0,
                        ),
                        isSelected: _selectedTabs,
                        children: tabs);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    //On the first iteration (index == 0) create the graph. On next iterations create the item cards.
                    //Add 1 to list lengths in order to not lose one item because of this.
                    itemCount: _selectedTabs[0]
                        ? PantryProxy().getUsedItems().length + 1
                        : PantryProxy().getBinItems().length + 1,
                    itemBuilder: (context, index) {
                      return index == 0
                          ? Column(
                              children: [
                                Stack(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 360,
                                      height: 170,
                                    ),
                                    const Positioned(
                                      top: -17,
                                      left: 20,
                                      right: 20,
                                      child: Icon(Icons.circle,
                                          size: 200, color: Colors.amber),
                                    ),
                                    const Positioned(
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                      child: Text(
                                        _selectedTabs[0]
                                            ? " USED ITEMS"
                                            : " BIN",
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                              ],
                            )
                          : LongPressDraggable<Item>(
                              data: _selectedTabs[0]
                                  ? PantryProxy().getUsedItems()[index - 1]
                                  : PantryProxy().getBinItems()[index - 1],
                              onDragCompleted: () {
                                print('drag complete');
                                //StateController.pantryList.removeAt(index);
                              },
                              feedback: SizedBox(
                                height: 85,
                                width: 320,
                                child: Card(
                                  elevation: 7,
                                  shape: const RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: ClipPath(
                                    clipper: ShapeBorderClipper(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                              color: Colors.black, width: 13),
                                        ),
                                      ),
                                      child: ExpansionTile(
                                        title: Text(
                                            _selectedTabs[0]
                                                ? PantryProxy()
                                                    .getUsedItems()[index - 1]
                                                    .name
                                                : PantryProxy()
                                                    .getBinItems()[index - 1]
                                                    .name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 23)),
                                        subtitle: const Text('ITEM CATEGORY'),
                                        trailing: Transform.translate(
                                          offset: const Offset(0, -15),
                                          child: const Icon(Icons.more_horiz),
                                        ),
                                        leading: Transform.translate(
                                          offset: const Offset(0, 0),
                                          child: const Icon(Icons.fastfood,
                                              size: 35),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              child: Card(
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
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            color: Colors.black, width: 13),
                                      ),
                                    ),
                                    child: ExpansionTile(
                                      title: Text(
                                          _selectedTabs[0]
                                              ? PantryProxy()
                                                  .getUsedItems()[index - 1]
                                                  .name
                                              : PantryProxy()
                                                  .getBinItems()[index - 1]
                                                  .name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 23)),
                                      subtitle: const Text('ITEM CATEGORY'),
                                      trailing: Transform.translate(
                                        offset: const Offset(10, -15),
                                        child: IconButton(
                                          icon: const Icon(Icons.more_horiz),
                                          onPressed: () {
                                            _moveToDialog();
                                          },
                                          color: Colors.black,
                                          iconSize: 30,
                                        ),
                                      ),
                                      leading: Transform.translate(
                                        offset: const Offset(0, 0),
                                        child: const Icon(Icons.fastfood,
                                            size: 35),
                                      ),
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 75),
                                          child: TextField(
                                            enabled: false,
                                            controller: _openDate,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(Icons
                                                    .edit_calendar_rounded),
                                                labelText: "OPENED"),
                                            readOnly: true,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 75),
                                          child: TextField(
                                            enabled: false,
                                            controller: _expDate,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                icon:
                                                    Icon(Icons.calendar_month),
                                                labelText: "EXPIRATION"),
                                            readOnly: true,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 75),
                                          child: Row(
                                            children: [
                                              Icon(
                                                  _favorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Colors.grey),
                                              const SizedBox(width: 16),
                                              const Text(
                                                'MARK AS FAVORITE',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 50, right: 20),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.55,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.12,
                                            child: TextField(
                                              enabled: false,
                                              controller: _details,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Details',
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
