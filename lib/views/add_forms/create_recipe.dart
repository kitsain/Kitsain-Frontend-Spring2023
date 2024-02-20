import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';
import 'package:kitsain_frontend_spring2023/categories.dart';
import 'package:kitsain_frontend_spring2023/database/recipes_proxy.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'package:kitsain_frontend_spring2023/database/openaibackend.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';
import 'package:kitsain_frontend_spring2023/assets/pantry_builder_recipe_generation.dart';

const List<String> categories = <String>[
  'Choose category',
  'No category',
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
  var _pantryItems;
  bool _isLoading = true; // Flag to track loading state
  var _formSubmitted = false;

  @override
  void initState() {
    super.initState();
    _loadPantryItems();
  }

  // Load pantry items asynchronously
  Future<void> _loadPantryItems() async {
    try {
      // Call your method to get pantry items
      _pantryItems = await PantryProxy().getPantryItems();
    } catch (e) {
      // Handle any potential errors
      print("Error loading pantry items: $e");
    } finally {
      // Set loading state to false after items are loaded or in case of error
      setState(() {
        _isLoading = false;
      });
    }
  }
  // These dates control the date string user sees in the form

  // var _expDateString = TextEditingController();
  // var _openDateString = TextEditingController();
  // var _recipeType = TextEditingController();
  // var _ingredients = TextEditingController();
  // var _supplies = TextEditingController();
  // var _exp_soon = TextEditingController();
  // var _pantry_only = TextEditingController();
  String selected = "True";

  // These values are actually saved to the db as DateTime
  // var _openDateDT;
  // var _expDateDT;
  final TextEditingController _recipeTypeController = TextEditingController();
  final TextEditingController _suppliesController = TextEditingController();
  final TextEditingController _expSoonController = TextEditingController();
  // bool _favorite = false;
  // bool _hasExpiryDate = false;
  String _category = "Choose category";
  var _catInt;
  // var _details = TextEditingController();
  // var _details2 = TextEditingController();
  // // var _details3 = TextEditingController();
  // var _details4 = TextEditingController();
  String? _selectedOption;
  var radioValues;

  var _offData;
  UnfocusDisposition _disposition = UnfocusDisposition.scope;

  void _discardChangesDialog(bool discardForm) {
    if (discardForm ||
        (_itemName.text.isEmpty &&
            _recipeTypeController.text.isEmpty &&
            _suppliesController.text.isEmpty &&
            _expSoonController.text.isEmpty)) {
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
// Choose what items to query from db based on user selection

  @override
  Widget build(BuildContext context) {
    // Display loading indicator while pantry items are being loaded
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(), // Or any other loading indicator
      );
    }
      
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
                          decoration: InputDecoration.collapsed(hintText: ''),
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
                  // First TextFormField
                  TextFormField(
                    style: AppTypography.paragraph,
                    controller: _recipeTypeController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText:
                          'Your diet and other wishes for the recipe? eg. vegan, 15-minute recipe, breakfast.',
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  // Second TextFormField
                  TextFormField(
                    style: AppTypography.paragraph,
                    controller: _suppliesController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText:
                          'List the cooking tools available/ the tools you want to use for this recipe, eg. airfryer',
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  // Fourth TextFormField
                  TextFormField(
                    style: AppTypography.paragraph,
                    controller: _expSoonController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText:
                          'Any ingredients you Want to use, eg. ingredients soon expiring?',
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  // Add the dropdown menu here
                  DropdownButtonFormField<String>(
                    value: _selectedOption,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption = newValue!;
                      });
                    },
                    items: <String>[
                      'Use only pantry items',
                      'Can use other items that are not in pantry'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  
                  PantryBuilder(
                      items: _pantryItems,
                      sortMethod: "az",
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Get values from controllers
                              String recipeType = _recipeTypeController.text;
                              String supplies = _suppliesController.text;
                              String expSoon = _expSoonController.text;

                              // Call your function with the values
                              var generatedRecipe = await generateRecipe(
                                  "chicken, pasta, tomato, pesto, anjovis, chocolate, mint",
                                  recipeType,
                                  expSoon,
                                  supplies,
                                  "True");

                              RecipeProxy().upsertRecipe(generatedRecipe);
                              _formSubmitted = false;
                              setState(() {});

                              // Clear the text fields if needed
                              _recipeTypeController.clear();
                              _suppliesController.clear();
                              _expSoonController.clear();

                              // Close the current screen if needed
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
            ),
          ],
        ),
      ),
    );
  }
}
