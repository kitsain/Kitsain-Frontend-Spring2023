import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:kitsain_frontend_spring2023/database/openfoodfacts.dart';

import '../../database/item.dart';
import '../../database/pantry_proxy.dart';

const List<String> categories = <String>[
  'Meat',
  'Seafood',
  'Fruit',
  'Vegetables',
  'Frozen',
  'Drinks',
  'Bread',
  'Sweets',
  'Dairy',
  'Ready meals',
  'Dry & canned goods',
  'Other'
];

class NewItemForm extends StatefulWidget {
  const NewItemForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewItemFormState createState() => _NewItemFormState();
}

@override
class _NewItemFormState extends State<NewItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _EANCodeField = TextEditingController();
  var _itemName = TextEditingController();
  var _expDate = TextEditingController();
  var _openDate = TextEditingController();
  var _bbdate;
  var _oDate;
  bool click = true;
  String dropdownValue = categories.first;

  void _discardChangesDialog() {
    if (_itemName.text.isEmpty &&
        _EANCodeField.text.isEmpty &&
        _openDate.text.isEmpty &&
        _expDate.text.isEmpty) {
      Navigator.pop(context);
    } else {
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
                      Navigator.pop(context);
                    },
                  ),
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: FloatingActionButton(
                    child: const Icon(Icons.close),
                    onPressed: () => _discardChangesDialog(),
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: const Text(
                'ADD TO PANTRY',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SimpleBarcodeScannerPage(),
                          ));
                      setState(() {
                        if (res is String && res != '-1') {
                          _EANCodeField.text = res;
                        }
                        //Res will be the EAN-code
                        //Here add OFF-api call and populate item name
                        //fields if the product was found
                        //_itemName.text =
                      });
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      size: 40,
                    ),
                    label: Text('SCAN EAN', style: TextStyle(fontSize: 20)),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: ElevatedButton(
                    onPressed: () {
                      var item = getFromJson(_EANCodeField.text);
                    },
                    child: Text('      ADD MANUALLY     '),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            SizedBox(
              child: TextFormField(
                controller: _EANCodeField,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'EAN CODE',
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            SizedBox(
              child: TextFormField(
                controller: _itemName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ITEM NAME',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter item name";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            SizedBox(
              child: DropdownButtonFormField<String>(
                value: dropdownValue,
                decoration: InputDecoration(labelText: 'ITEM CATEGORY'),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            SizedBox(
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    click = !click;
                  });
                },
                icon: Icon(
                    (click == false) ? Icons.favorite : Icons.favorite_border),
                label: Text('Mark as favorite'),
              ),
            ),
            TextFormField(
              controller: _expDate,
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: "EXPIRATION DATE"),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  String expirationDate = pickedDate.day.toString() +
                      "." +
                      pickedDate.month.toString() +
                      "." +
                      pickedDate.year.toString();
                  _expDate.text = expirationDate;
                  _bbdate = pickedDate;
                } else {
                  _expDate.text = "";
                }
                ;
              },
            ),
            TextFormField(
              controller: _openDate,
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today), labelText: "OPENED"),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  String openedDate = pickedDate.day.toString() +
                      "." +
                      pickedDate.month.toString() +
                      "." +
                      pickedDate.year.toString();
                  _openDate.text = openedDate;
                  _oDate = pickedDate;
                } else {
                  _openDate.text = "";
                }
                ;
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: ElevatedButton(
                    onPressed: () => _discardChangesDialog(),
                    child: Text('CANCEL'),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        var newItem = Item(
                            ObjectId().toString(), _itemName.text,
                            mainCat: dropdownValue,
                            openedDate: _oDate,
                            bbDate: _bbdate,
                            location: "Pantry");
                        PantryProxy().upsertItem(newItem);
                      }
                    },
                    child: Text('ADD ITEM'),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
