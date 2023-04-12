import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:kitsain_frontend_spring2023/database/openfoodfacts.dart';

const List<String> categories = <String>['Meat', 'Seafood', 'Fruit', 'Vegetables',
  'Frozen', 'Drinks', 'Bread', 'Sweets',
  'Dairy', 'Ready meals',
  'Dry & canned goods', 'Other'];

class NewShoppingListItemForm extends StatefulWidget {
  const NewShoppingListItemForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewItemFormState createState() => _NewItemFormState();
}

@override
class _NewItemFormState extends State<NewShoppingListItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _EANCodeField = TextEditingController();
  var _itemName = TextEditingController();
  String _category = categories.first;
  var _offData;

  bool _discardChangesDialog() {
    bool _close = false;
    if(_itemName.text.isEmpty && _EANCodeField.text.isEmpty
        && _category == categories.first) {
      Navigator.pop(context);
      _close = true;
      return _close;
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
                  _close = false;
                },
              ),
              TextButton(
                child: const Text('DISCARD'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  _close = true;
                },
              ),
            ],
          )
      );
      return _close;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _discardChangesDialog();
      },
      child: Form(
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
                      child: Icon(Icons.close),
                      onPressed: () => _discardChangesDialog(),
                    ),
                  )
                ],
              ),
              Text(
                'ADD TO\n SHOPPING LIST',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox( height: MediaQuery.of(context).size.height * 0.03),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        var res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SimpleBarcodeScannerPage(),
                            ));
                        setState(() async {
                          if (res is String && res != '-1') {
                            try {
                              _EANCodeField.text = res;
                              _offData = await getFromJson(res);
                              _itemName.text = _offData.productName.toString();

                            } catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: AlertDialog(
                                        content: const Text('Item not found\n'
                                            'Input manually'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ]
                                    ),
                                  )
                              );
                            }
                          }
                        });
                        //Res will be the EAN-code
                        //Here add OFF-api call and populate item name and category
                        //fields if the product was found
                        //_itemName.text =
                      },
                      icon: Icon(Icons.camera_alt, size: 40,),
                      label: Text('SCAN EAN', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox( height: MediaQuery.of(context).size.height * 0.01),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_EANCodeField.text.isNotEmpty) {
                          try {
                            _offData = await getFromJson(_EANCodeField.text);
                            setState(() {
                              _itemName.text = _offData.productName.toString();
                            });
                          } catch (e) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: AlertDialog(
                                          content: const Text('Item not found\n'
                                              'Input manually'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ]
                                      ),
                                    )
                            );
                          }
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: AlertDialog(
                                        content: const Text(
                                            'Please input EAN-code'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ]
                                    ),
                                  )
                          );
                        }
                      },
                      child: Text('      ADD MANUALLY     '),
                    ),
                  ),
                  SizedBox( height: MediaQuery.of(context).size.height * 0.03),
                  SizedBox(
                    child: TextFormField(
                      controller: _EANCodeField,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'EAN CODE',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox( height: MediaQuery.of(context).size.height * 0.03),
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
              SizedBox( height: MediaQuery.of(context).size.height * 0.03),
              SizedBox(
                child: DropdownButtonFormField<String>(
                  value: _category,
                  decoration: InputDecoration(labelText: 'ITEM CATEGORY'),
                  onChanged: (String? value) {
                    setState(() {
                      _category = value!;
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
              SizedBox( height: MediaQuery.of(context).size.height * 0.05),
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

                  SizedBox( width: MediaQuery.of(context).size.width * 0.05),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          print("OK");
                        }
                      },
                      child: Text('ADD ITEM'),
                    ),
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
}

