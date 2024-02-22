import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';
import 'package:kitsain_frontend_spring2023/categories.dart';
import 'package:kitsain_frontend_spring2023/database/recipes_proxy.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'package:kitsain_frontend_spring2023/database/openaibackend.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:realm/realm.dart';
import 'dart:async';
import 'package:kitsain_frontend_spring2023/assets/pantry_builder_recipe_generation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CreateNewRecipeForm extends StatefulWidget {
  const CreateNewRecipeForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateNewRecipeFormState createState() => _CreateNewRecipeFormState();
}

class LoadingDialogWithTimeout extends StatefulWidget {
  @override
  _LoadingDialogWithTimeoutState createState() =>
      _LoadingDialogWithTimeoutState();
}

class _LoadingDialogWithTimeoutState extends State<LoadingDialogWithTimeout> {
/*   @override
  void initState() {
    super.initState();
    // Start a timer to close the dialog after 10 seconds
    Timer(Duration(seconds: 20), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }); 
  } */

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitWanderingCubes(color: Colors.white, size: 50),
          SizedBox(height: 16),
          Text('Creating recipe...', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

@override
class _CreateNewRecipeFormState extends State<CreateNewRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  final _EANCodeField = TextEditingController();
  var _itemName = TextEditingController();
  var _pantryItems;
  bool _isLoading = true; // Flag to track loading state
  var _formSubmitted = false;
  List<String> selectedItems = [];

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
    if (discardForm || _areFormFieldsEmpty()) {
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
            _buildDialogButton('CANCEL', Colors.black38, () {
              Navigator.pop(context);
            }),
            _buildDialogButton('DISCARD', AppColors.main1, () {
              Navigator.pop(context);
              _discardChangesDialog(true);
            }),
          ],
        ),
      );
    }
  }

  bool _areFormFieldsEmpty() {
    return _itemName.text.isEmpty &&
        _recipeTypeController.text.isEmpty &&
        _suppliesController.text.isEmpty &&
        _expSoonController.text.isEmpty;
  }

  Widget _buildDialogButton(
      String text, Color textColor, void Function() onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: AppTypography.category.copyWith(color: textColor),
      ),
    );
  }
// Choose what items to query from db based on user selection

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }

    return Scaffold(
      backgroundColor: AppColors.main2,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            _buildCloseButton(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            _buildRecipeHeading(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            _buildRecipeForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildCloseButton() {
    return Row(
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
    );
  }

  Widget _buildRecipeHeading() {
    return Column(
      children: [
        Text(
          'GENERATE A NEW RECIPE',
          textAlign: TextAlign.center,
          style: AppTypography.heading2.copyWith(color: AppColors.main3),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.06),
      ],
    );
  }

  Widget _buildRecipeForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTextFormField(
            controller: _recipeTypeController,
            hintText:
                'Your diet and other wishes for the recipe? eg. vegan, 15-minute recipe, breakfast.',
            maxLines: 5,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          _buildTextFormField(
            controller: _suppliesController,
            hintText:
                'List the cooking tools available/ the tools you want to use for this recipe, eg. airfryer',
            maxLines: 5,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          _buildTextFormField(
            controller: _expSoonController,
            hintText:
                'Any ingredients you Want to use, eg. ingredients soon expiring?',
            maxLines: 5,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          _buildDropdownMenu(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
          PantryBuilder(
              items: _pantryItems,
              sortMethod: "az",
              onSelectedItemsChanged: (selectedItems) {
                setState(() {
                  this.selectedItems = selectedItems;
                });
              }),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required int maxLines,
  }) {
    return TextFormField(
      style: AppTypography.paragraph,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(),
        hintText: hintText,
      ),
      maxLines: maxLines,
    );
  }

  Widget _buildDropdownMenu() {
    return DropdownButtonFormField<String>(
      value: _selectedOption,
      onChanged: (String? newValue) {
        setState(() {
          _selectedOption = newValue!;
        });
      },
      items: <String>[
        'Use only pantry items',
        'Can use other items that are not in pantry'
      ].map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
    );
  }

  Widget _buildActionButtons() {
    bool isLoading = false; // Set this to true when waiting for createRecipe

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton('CANCEL', AppColors.main3, Colors.white, () {
          _discardChangesDialog(false);
        }),
        SizedBox(width: MediaQuery.of(context).size.width * 0.03),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.main3,
          ),
          onPressed: () async {
            if (isLoading) return; // Do nothing if loading

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                // Use a Builder widget to create a new valid BuildContext
                return Builder(
                  builder: (BuildContext context) {
                    return _loadingDialog(context);
                  },
                );
              },
            );

            try {
              await _createRecipe();
            } finally {
              // Use rootNavigator: true to pop the dialog from the root navigator
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context).pop(); // Close the loading dialog
            }
          },
          child: const Text('CREATE RECIPE'),
        ),
      ],
    );
  }

  Widget _loadingDialog(BuildContext context) {
    return LoadingDialogWithTimeout();
  }

  Widget _buildButton(String label, Color backgroundColor, Color textColor,
      Function() onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Future<void> _createRecipe() async {
    if (_formKey.currentState!.validate()) {
      String recipeType = _recipeTypeController.text;
      String supplies = _suppliesController.text;
      String expSoon = _expSoonController.text;

      var generatedRecipe = await generateRecipe(
        selectedItems,
        recipeType,
        [expSoon],  // temporary solution. rather ask the user for an actual list
        [supplies], // temporary solution. rather ask the user for an actual list
        true,
      );

      RecipeProxy().upsertRecipe(generatedRecipe);
      _formSubmitted = false;
      _recipeTypeController.clear();
      _suppliesController.clear();
      _expSoonController.clear();
    }
  }
}
