import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/controller/task_controller.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';

class NewShoppingListItemForm extends StatefulWidget {
  const NewShoppingListItemForm({super.key, required this.taskListId});

  final String taskListId;
  @override
  // ignore: library_private_types_in_public_api
  _NewItemFormState createState() => _NewItemFormState();
}

@override
class _NewItemFormState extends State<NewShoppingListItemForm> {
  final _formKey = GlobalKey<FormState>();
  var _itemName = TextEditingController();
  var _details = TextEditingController();
  final _taskController = Get.put(TaskController());

  bool _discardChangesDialog() {
    BuildContext outerContext = context;
    bool _close = false;

    if(_itemName.text.isEmpty && _details.text.isEmpty) {
      Navigator.pop(context);
      _close = true;
      return _close;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: const Text('Discard changes?',
              style: AppTypography.paragraph,
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.cancelGrey),
                ),
                child: const Text('CANCEL',
                  style: AppTypography.category,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _close = false;
                },
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main1),
                ),
                child: const Text('DISCARD',
                  style: AppTypography.category,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(outerContext);
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
    return Scaffold(
      backgroundColor: AppColors.main2,
      body: WillPopScope(
        onWillPop: () async {
          return _discardChangesDialog();
        },
        child: Form(
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
                        foregroundColor: AppColors.main2,
                        backgroundColor: AppColors.main3,
                        child: const Icon(Icons.close),
                        onPressed: () => _discardChangesDialog(),
                      ),
                    )
                  ],
                ),
                Text(
                  'ADD ITEM\nTO SHOPPING LIST',
                  textAlign: TextAlign.center,
                  style: AppTypography.heading2.copyWith(color: AppColors.main3),
                ),
                SizedBox( height: MediaQuery.of(context).size.height * 0.05),
                Stack(
                    children: [
                      TextFormField(
                        style: AppTypography.paragraph,
                        controller: _itemName,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
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
                        child: Icon(Icons.keyboard_alt_outlined,
                          color: AppColors.main3,
                        ),
                      )
                    ]
                ),
                SizedBox( height: MediaQuery.of(context).size.height * 0.025),
                TextFormField(
                  style: AppTypography.paragraph,
                  controller: _details,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Details',
                  ),
                  maxLines: 5,
                ),
                SizedBox( height: MediaQuery.of(context).size.height * 0.15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main3),
                          backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                          side: MaterialStateProperty.resolveWith((states) => const BorderSide(width: 3, color: AppColors.main3)),
                        ),
                        onPressed: () => _discardChangesDialog(),
                        child: const Text(' CANCEL ',
                          style: AppTypography.category,
                        ),
                      ),
                    ),
                    SizedBox( width: MediaQuery.of(context).size.width * 0.05),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                          backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main3),
                        ),
                        onPressed: () {
                          if(_formKey.currentState!.validate()) {
                            _taskController.createTask(
                                _itemName.text,
                                _details.text,
                                widget.taskListId);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('ADD ITEM',
                          style: AppTypography.category,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}

