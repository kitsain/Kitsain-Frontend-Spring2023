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

class EditItemForm extends StatefulWidget {
  const EditItemForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditItemFormState createState() => _EditItemFormState();
}

@override
class _EditItemFormState extends State<EditItemForm> {
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
    return Scaffold();
  }
}
