import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'package:realm/realm.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:kitsain_frontend_spring2023/database/openfoodfacts.dart';

const List<String> categories = <String>[
  'Choose category',
  'Meat',
  'Seafood',
  'Fruit',
  'Vegetables',
  'Frozen',
  'Drinks',
  'Bread',
  'Treats',
  'Dairy',
  'Ready meals',
  'Dry & canned goods',
  'Other'
];

final catEnglish = <int, String>{
  1: 'New',
  2: 'Meat',
  3: 'Seafood',
  4: 'Fruit',
  5: 'Vegetables',
  6: 'Frozen',
  7: 'Drinks',
  8: 'Bread',
  9: 'Treats',
  10: 'Dairy',
  11: 'Ready meals',
  12: 'Dry & canned goods',
  13: 'Other'
};

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

  // These dates control the date string user sees in the form
  var _expDateString = TextEditingController();
  var _openDateString = TextEditingController();

  // These values are actually saved to the db as DateTime
  var _openDateDT;
  var _expDateDT;

  bool _favorite = false;
  bool _hasExpiryDate = false;
  String _category = "Choose category";
  var _catInt;
  var _details = TextEditingController();

  var _offData;
  UnfocusDisposition _disposition = UnfocusDisposition.scope;

  void _discardChangesDialog(bool discardForm) {
    if (discardForm ||
        (_itemName.text.isEmpty &&
            _EANCodeField.text.isEmpty &&
            _openDateString.text.isEmpty &&
            _expDateString.text.isEmpty)) {
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
                _discardChangesDialog(true);
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                  child: FloatingActionButton(
                    child: const Icon(Icons.close),
                    onPressed: () => _discardChangesDialog(false),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              'ADD ITEM\nTO PANTRY',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            Padding(
              padding: const EdgeInsets.only(left: 7, right: 7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.add_a_photo_rounded,
                        size: 40,
                      ),
                      label: const Text('SCAN EAN',
                          style: TextStyle(fontSize: 20)),
                      onPressed: () async {
                        var res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SimpleBarcodeScannerPage(),
                          ),
                        );
                        if (res is String && res != '-1') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Fetching item...')));
                          try {
                            _EANCodeField.text = res;
                            primaryFocus!.unfocus(disposition: _disposition);
                            _offData = await getFromJson(res);
                            _itemName.text = _offData.productName.toString();
                          } catch (e) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Item not found. Please enter item information.')));
                          }
                          if (_itemName.text.isNotEmpty) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Item found!')));
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  TextFormField(
                    controller: _EANCodeField,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'EAN CODE',
                      suffixIcon: SizedBox(
                        width: 80,
                        height: 60,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            shape: MaterialStatePropertyAll<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadiusDirectional.only(
                                  topEnd: Radius.circular(5),
                                  bottomEnd: Radius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (_EANCodeField.text.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Fetching item data...')));
                              try {
                                primaryFocus!
                                    .unfocus(disposition: _disposition);
                                _offData =
                                    await getFromJson(_EANCodeField.text);
                                _itemName.text =
                                    _offData.productName.toString();
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Item not found. Input manually.'),
                                  ),
                                );
                              }
                              if (_itemName.text.isNotEmpty) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Item found!'),
                                  ),
                                );
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: AlertDialog(
                                    content:
                                        const Text('Please input EAN-code'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text('FETCH\n ITEM'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Stack(children: [
                    TextFormField(
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
                    const Positioned(
                        right: 27,
                        top: 15,
                        child: Icon(Icons.keyboard_alt_outlined))
                  ]),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        menuMaxHeight: 200,
                        value: _category,
                        icon: const Positioned(
                          right: 30,
                          child: Icon(Icons.arrow_drop_down),
                        ),
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        onChanged: (String? value) {
                          setState(
                            () {
                              _category = value!;
                              _catInt = catEnglish.keys.firstWhere(
                                      (key) => categories[key] == value) +
                                  1;
                            },
                          );
                        },
                        items: categories.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        validator: (value) {
                          if (value == categories.first) {
                            return "Please enter a category";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  SizedBox(
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _favorite = !_favorite;
                        });
                      },
                      icon: Icon(
                          _favorite ? Icons.favorite : Icons.favorite_border),
                      label: const Text('Mark as favorite'),
                    ),
                  ),
                  TextFormField(
                    controller: _openDateString,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "OPENING DATE"),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        String openedDate =
                            "${pickedDate.day}.${pickedDate.month}.${pickedDate.year}";
                        _openDateString.text = openedDate;
                        _openDateDT = pickedDate;
                      } else {
                        _openDateString.text = "";
                      }
                    },
                  ),
                  TextFormField(
                    controller: _expDateString,
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
                        String expirationDate =
                            "${pickedDate.day}.${pickedDate.month}.${pickedDate.year}";
                        _expDateString.text = expirationDate;
                        _expDateDT = pickedDate;
                        _hasExpiryDate = true;
                      } else {
                        _expDateString.text = "";
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  TextFormField(
                    controller: _details,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Details',
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: ElevatedButton(
                          onPressed: () => _discardChangesDialog(false),
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
                            if (_formKey.currentState!.validate()) {
                              var newItem = Item(
                                ObjectId().toString(),
                                _itemName.text,
                                "Pantry",
                                _catInt,
                                favorite: _favorite,
                                openedDate: _openDateDT,
                                expiryDate: _expDateDT,
                                hasExpiryDate: _hasExpiryDate,
                                addedDate: DateTime.now().toUtc(),
                                details: _details.text,
                              );
                              PantryProxy().upsertItem(newItem);
                              setState(() {});
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('ADD ITEM'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
