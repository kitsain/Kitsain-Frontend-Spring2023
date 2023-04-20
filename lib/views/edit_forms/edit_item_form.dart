import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:kitsain_frontend_spring2023/database/openfoodfacts.dart';

const List<String> categories = <String>[
  'ITEM CATEGORY',
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
  final _formKey = GlobalKey<FormState>();
  final _EANCodeField = TextEditingController();
  var _itemName = TextEditingController();
  var _expDate = TextEditingController();
  var _openDate = TextEditingController();
  var _details = TextEditingController();
  bool _click = false;
  String _category = 'ITEM CATEGORY';
  var _offData;
  UnfocusDisposition _disposition = UnfocusDisposition.scope;

  bool _discardChangesDialog() {
    bool _close = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
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
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: FloatingActionButton(
                      child: Icon(Icons.close),
                      onPressed: () => _discardChangesDialog(),
                    ),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: Text(
                  'EDIT ITEM',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7, right: 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _EANCodeField,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'EAN CODE',
                          suffixIcon: Container(
                            width: 80,
                            height: 60,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadiusDirectional.only(
                                                topEnd: Radius.circular(5), bottomEnd: Radius.circular(5))
                                        )
                                    )
                                ),
                                onPressed: () async {
                                  if(_EANCodeField.text.isNotEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text('Fetching item data...')));
                                    try {
                                      primaryFocus!.unfocus(disposition: _disposition);
                                      _offData = await getFromJson(_EANCodeField.text);
                                      _itemName.text = _offData.productName.toString();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(content: Text('Item not found. Input manually.')));
                                    } if(_itemName.text.isNotEmpty) {
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(content: Text('Item found!')));
                                    }
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) => SizedBox(
                                          width: 10,
                                          height: 10,
                                          child: AlertDialog(
                                              content: const Text('Please input EAN-code'),
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
                                child: Text('FETCH\n ITEM')),
                          )
                      ),
                    ),
                    SizedBox( height: MediaQuery.of(context).size.height * 0.03),
                    Stack(
                        children: [
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
                          Positioned(
                              right: 27,
                              top: 15,
                              child: Icon(Icons.keyboard_alt_outlined)
                          )
                        ]
                    ),
                    SizedBox( height: MediaQuery.of(context).size.height * 0.03),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: 200,
                          value: _category,
                          icon: Positioned(
                              right: 30,
                              child: Icon(Icons.arrow_drop_down)),
                          decoration: InputDecoration.collapsed(
                              hintText: ''),
                          onChanged: (String? value) {
                            print(value);
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
                          validator: (value) {
                            if (value == categories.first) {
                              return "Please enter a category";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox( height: MediaQuery.of(context).size.height * 0.04),
                    SizedBox(
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _click = !_click;
                          });
                        },
                        icon: Icon(_click ? Icons.favorite : Icons.favorite_border),
                        label: Text('Mark as favorite'),
                      ),
                    ),
                    TextFormField(
                      controller: _expDate,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          labelText: "EXPIRATION DATE"
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate:DateTime(2000),
                            lastDate: DateTime(2101));
                        if(pickedDate != null) {
                          String expirationDate = pickedDate.day.toString() + "." +  pickedDate.month.toString() + "." + pickedDate.year.toString();
                          _expDate.text = expirationDate;
                        } else {
                          _expDate.text = "";
                        };
                      },
                    ),
                    TextFormField(
                      controller: _openDate,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          labelText: "OPENING DATE"
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate:DateTime(2000),
                            lastDate: DateTime(2101));
                        if(pickedDate != null) {
                          String openedDate = pickedDate.day.toString() + "." +  pickedDate.month.toString() + "." + pickedDate.year.toString();
                          _openDate.text = openedDate;
                        } else {
                          _openDate.text = "";
                        };
                      },
                    ),
                    SizedBox( height: MediaQuery.of(context).size.height * 0.05),
                    TextFormField(
                      controller: _details,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Details',
                      ),
                      maxLines: 5,
                    ),
                    SizedBox( height: MediaQuery.of(context).size.height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.height * 0.15,
                          child: ElevatedButton(
                            onPressed: () => _discardChangesDialog(),
                            child: Text('CANCEL'),
                          ),
                        ),
                        SizedBox( width: MediaQuery.of(context).size.width * 0.05),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.height * 0.15,
                          child: ElevatedButton(
                            onPressed: () {
                              if(_formKey.currentState!.validate()) {
                                print("OK");
                              }
                            },
                            child: Text(' DONE '),
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
      ),
    );
  }
}