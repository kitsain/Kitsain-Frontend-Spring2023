import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';
import 'package:kitsain_frontend_spring2023/categories.dart';
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
          content: const Text(
            'Discard changes?',
            style: AppTypography.paragraph,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'CANCEL',
                style: AppTypography.category.copyWith(color: Colors.black38),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'DISCARD',
                style: AppTypography.category.copyWith(color: AppColors.main1),
              ),
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
      backgroundColor: AppColors.main2,
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
                    onPressed: () => _discardChangesDialog(false),
                    foregroundColor: AppColors.main2,
                    backgroundColor: AppColors.main3,
                    child: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              'ADD ITEM\nTO PANTRY',
              textAlign: TextAlign.center,
              style: AppTypography.heading2.copyWith(color: AppColors.main3),
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
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => AppColors.main3),
                          foregroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.white)),
                      icon: const Icon(
                        Icons.add_a_photo_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                      label: Text('SCAN EAN',
                          style: AppTypography.category
                              .copyWith(color: Colors.white)),
                      onPressed: () async {
                        var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SimpleBarcodeScannerPage(),
                          ),
                        );
                        if (res is String && res != '-1') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Fetching item...'),
                            duration: Duration(seconds: 2),
                          ));
                          try {
                            _EANCodeField.text = res;
                            primaryFocus!.unfocus(disposition: _disposition);
                            _offData = await getFromJson(res);
                            _itemName.text = _offData.productName.toString();
                          } catch (e) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  'Item not found. Please enter item information.'),
                              duration: Duration(seconds: 2),
                            ));
                          }
                          if (_itemName.text.isNotEmpty) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Item found!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  TextFormField(
                    style: AppTypography.paragraph,
                    controller: _EANCodeField,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(),
                      labelText: 'EAN CODE',
                      suffixIcon: SizedBox(
                        width: 80,
                        height: 60,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => AppColors.main3),
                            foregroundColor: MaterialStateProperty.resolveWith(
                                (states) => AppColors.main2),
                            shape: const MaterialStatePropertyAll<
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Fetching item data...'),
                                duration: Duration(seconds: 2),
                              ));
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
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                              if (_itemName.text.isNotEmpty) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Item found!'),
                                    duration: Duration(seconds: 2),
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
                      style: AppTypography.paragraph,
                      controller: _itemName,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
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
                        child: Icon(
                          Icons.keyboard_alt_outlined,
                          color: AppColors.main3,
                        ))
                  ]),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        style: AppTypography.smallTitle
                            .copyWith(color: Colors.black),
                        menuMaxHeight: 200,
                        value: _category,
                        icon: Icon(Icons.arrow_drop_down),
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        onChanged: (String? value) {
                          setState(
                            () {
                              _category = value!;
                              _catInt = Categories.categoriesByIndex.keys
                                      .firstWhere(
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
                        _favorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.black,
                      ),
                      label: Text(
                        'Mark as favorite',
                        style: AppTypography.paragraph
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  TextFormField(
                    style:
                        AppTypography.smallTitle.copyWith(color: Colors.black),
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
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppColors.main1,
                                onPrimary: AppColors.main2,
                                onSurface: AppColors.main3,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                              )),
                            ),
                            child: child!,
                          );
                        },
                      );
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
                    style:
                        AppTypography.smallTitle.copyWith(color: Colors.black),
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
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppColors.main1,
                                onPrimary: AppColors.main2,
                                onSurface: AppColors.main3,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                              )),
                            ),
                            child: child!,
                          );
                        },
                      );
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
                    style: AppTypography.paragraph,
                    controller: _details,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
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
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.white),
                            foregroundColor: MaterialStateProperty.resolveWith(
                                (states) => AppColors.main3),
                            side: MaterialStateProperty.resolveWith((states) =>
                                const BorderSide(
                                    width: 3, color: AppColors.main3)),
                          ),
                          onPressed: () => _discardChangesDialog(false),
                          child: const Text(
                            'CANCEL',
                            style: AppTypography.category,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => AppColors.main3),
                            foregroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.white),
                          ),
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
                          child: const Text(
                            'ADD ITEM',
                            style: AppTypography.category,
                          ),
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
