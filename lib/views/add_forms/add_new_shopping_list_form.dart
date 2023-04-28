import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/controller/tasklist_controller.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';

class NewShoppingListForm extends StatefulWidget {
  const NewShoppingListForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewItemFormState createState() => _NewItemFormState();
}

@override
class _NewItemFormState extends State<NewShoppingListForm> {
  final _formKey = GlobalKey<FormState>();
  final _listName = TextEditingController();
  final _taskListController = Get.put(TaskListController());

  bool _discardChangesDialog() {
    BuildContext outerContext = context;
    bool _close = false;
    if(_listName.text.isEmpty) {
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
    return WillPopScope(
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
              SizedBox( height: MediaQuery.of(context).size.height * 0.03),
              Text(
                'NEW\nSHOPPING\nLIST',
                textAlign: TextAlign.center,
                style: AppTypography.heading2.copyWith(color: AppColors.main3),
              ),
              SizedBox( height: MediaQuery.of(context).size.height * 0.03),
              Stack(
                  children: [
                    TextFormField(
                      style: AppTypography.smallTitle,
                      controller: _listName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'LIST NAME',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter list name";
                        }
                        return null;
                      },
                    ),
                    Positioned(
                        right: 27,
                        top: 15,
                        child: Icon(Icons.keyboard_alt_outlined,
                          color: AppColors.main3,
                        )
                    )
                  ]
              ),
              SizedBox( height: MediaQuery.of(context).size.height * 0.27),
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
                      child: Text('CANCEL'),
                    ),
                  ),
                  SizedBox( width: MediaQuery.of(context).size.width * 0.05),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main2),
                        backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main3),
                      ),
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          _taskListController.createTaskLists(_listName.text);
                          Navigator.pop(context);
                        }
                      },
                      child: Text('  DONE  '),
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

