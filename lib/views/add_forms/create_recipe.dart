// JOS EI LAITA KATEGORIAA RESEPTILLE TULEE VIRHE, VOI KATSOA MALLIA MITEN KORJATAAN ADD_NEW_ITEM_FORM.DART-tiedostosta JOS SIELLÄ TOIMIS

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
  'Weekend',
  'Weekday',
  'Holiday',
  'Quick recipes',
];

class CreateNewRecipeForm extends StatefulWidget {
  const CreateNewRecipeForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateNewRecipeFormState createState() => _CreateNewRecipeFormState();
}

@override
class _CreateNewRecipeFormState extends State<CreateNewRecipeForm> {
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
              'GENERATE A NEW RECIPE',
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
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Container(
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
                          hint: Text(
                              'Choose Category'), // Set 'Choose Category' as hint
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
                            if (value == 'Choose Category') {
                              return "Please choose a category";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
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
                                _details
                                    .text, // using details as the item name for simplicity
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
                            'CREATE RECIPE',
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
