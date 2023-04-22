import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
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

Map catEnglish = {
  1: 'ITEM CATEGORY',
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

class EditItemForm extends StatefulWidget {
  EditItemForm({super.key, required this.item});

  late Item item;

  @override
  // ignore: library_private_types_in_public_api
  _EditItemFormState createState() => _EditItemFormState();
}

@override
class _EditItemFormState extends State<EditItemForm> {
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
  String _category = 'ITEM CATEGORY';
  var _catInt;
  var _hasExpiryDate;
  var _details = TextEditingController();

  var _offData;
  UnfocusDisposition _disposition = UnfocusDisposition.scope;

  bool _noEditsWereMade() {
    bool noEditsOnBarcode = _EANCodeField.text == widget.item.barcode ||
        (_EANCodeField.text == "" && widget.item.barcode == null);

    return noEditsOnBarcode &&
        _itemName.text == widget.item.name &&
        _details.text == widget.item.details &&
        _expDateDT == widget.item.expiryDate &&
        _openDateDT == widget.item.openedDate &&
        _catInt == widget.item.mainCat;
  }

  void _discardChangesDialog(bool discardForm) {
    if (discardForm || _noEditsWereMade() ||
        (_itemName.text.isEmpty &&
            _EANCodeField.text.isEmpty &&
            _openDateString.text.isEmpty &&
            _expDateString.text.isEmpty)) {
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
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

  // Prepopulating form fields with item data
  @override
  void initState() {
    super.initState();

    // Mandatory fields
    _itemName.text = widget.item.name;
    _category = catEnglish[widget.item.mainCat];
    _favorite = widget.item.favorite;
    _catInt = widget.item.mainCat;

    // Optional fields
    if (widget.item.barcode != null) {
      _EANCodeField.text = widget.item.barcode!;
    }

    if (widget.item.openedDate != null) {
      _openDateDT = widget.item.openedDate!;
      String openedDate =
          "${_openDateDT.day}.${_openDateDT.month}.${_openDateDT.year}";
      _openDateString.text = openedDate;
    }
    if (widget.item.expiryDate != null) {
      _expDateDT = widget.item.expiryDate!;
      String expirationDate =
          "${_expDateDT.day}.${_expDateDT.month}.${_expDateDT.year}";
      _expDateString.text = expirationDate;
    }
    if (widget.item.details != null) {
      _details.text = widget.item.details!;
    }

    _hasExpiryDate = widget.item.hasExpiryDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.04,
                  child: FloatingActionButton(
                    child: const Icon(Icons.close),
                    onPressed: () => _discardChangesDialog(false),
                  ),
                )
              ],
            ),
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height * 0.01),
            Text(
                'EDIT ITEM',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            SizedBox( height: MediaQuery.of(context).size.height * 0.05),
            Padding(
              padding: const EdgeInsets.only(left: 7, right: 7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                                      borderRadius:
                                      BorderRadiusDirectional.only(
                                          topEnd: Radius.circular(5),
                                          bottomEnd: Radius.circular(5))))),
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
                                        content: Text(
                                            'Item not found. Input manually.')));
                              }
                              if (_itemName.text.isNotEmpty) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Item found!')));
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    SizedBox(
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
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.03),
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
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.03),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
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
                                      (k) => categories[k] == value) +
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
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.04),
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
                            "${pickedDate.day}.${pickedDate.month}.${pickedDate
                            .year}";
                        _openDateString.text = openedDate;
                        _openDateDT = pickedDate.toUtc();
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
                            "${pickedDate.day}.${pickedDate.month}.${pickedDate
                            .year}";
                        _expDateString.text = expirationDate;
                        _expDateDT = pickedDate.toUtc();
                        _hasExpiryDate = true;
                      } else {
                        _expDateString.text = "";
                        _expDateDT = null;
                        _hasExpiryDate = false;
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.05),
                  TextFormField(
                    controller: _details,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Details',
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.07,
                        width: MediaQuery
                            .of(context)
                            .size
                            .height * 0.15,
                        child: ElevatedButton(
                          onPressed: () => _discardChangesDialog(false),
                          child: const Text('CANCEL'),
                        ),
                      ),
                      SizedBox(width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.05),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.07,
                        width: MediaQuery
                            .of(context)
                            .size
                            .height * 0.15,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              var item = Item(widget.item.id, _itemName.text,
                                  widget.item.location, _catInt,
                                  favorite: _favorite,
                                  openedDate: _openDateDT,
                                  expiryDate: _expDateDT,
                                  hasExpiryDate: _hasExpiryDate,
                                  details: _details.text);
                              PantryProxy().upsertItem(item);
                              setState(() {});
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(' DONE '),
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
