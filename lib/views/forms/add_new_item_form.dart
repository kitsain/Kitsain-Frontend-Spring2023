import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

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
  final _barcodeField = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mainCatController = TextEditingController();
  final _expDate = TextEditingController();
  final _openDate = TextEditingController();
  bool click = true;
  String dropdownValue = categories.first;

  void _discardChangesDialog() {
    if (_nameController.text.isEmpty &&
        _barcodeField.text.isEmpty &&
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
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        //mainAxisAlignment: MainAxisAlignment.center,
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: FloatingActionButton(
                  child: Icon(Icons.close),
                  onPressed: () => _discardChangesDialog(), //Close sheet
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            child: const Text(
              'ADD ITEM',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          SizedBox(
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Item name',
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
              label: const Text('Mark as an "everyday" item'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton(
                  onPressed: () => _discardChangesDialog(),
                  child: const Text('CANCEL'),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint("painettu");
                    if (_formKey.currentState!.validate()) {
                      var newItem = Item(
                          ObjectId().toString(), _nameController.text,
                          mainCat: dropdownValue, location: "Pantry");
                      PantryProxy().upsertItem(newItem);
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
                  child: const Text('ADD ITEM'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
