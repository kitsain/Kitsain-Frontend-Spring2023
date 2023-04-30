import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';
import 'package:kitsain_frontend_spring2023/controller/tasklist_controller.dart';

class EditShoppingListForm extends StatefulWidget {
  const EditShoppingListForm({super.key, required this.listId, required this.listIndex});

  final String listId;
  final int listIndex;

  @override
  _EditItemFormState createState() => _EditItemFormState();
}

@override
class _EditItemFormState extends State<EditShoppingListForm> {
  final _formKey = GlobalKey<FormState>();
  final _listName = TextEditingController();
  final _taskListController = Get.put(TaskListController());

  void _discardChangesDialog() {
    String originalListName = '${_taskListController.taskLists.value?.items?[widget.listIndex].title}';
    BuildContext outerContext = context;

    if(_listName.text == originalListName) {
      Navigator.pop(context);
      return;
    }
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
              Navigator.pop(outerContext);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _listName.text = '${_taskListController.taskLists.value?.items?[widget.listIndex].title}';

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
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: FloatingActionButton(
                    foregroundColor: AppColors.main2,
                    backgroundColor: AppColors.main3,
                    child: Icon(Icons.close),
                    onPressed: () => _discardChangesDialog(),
                  ),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Text(
              'EDIT\nSHOPPING\nLIST',
              textAlign: TextAlign.center,
              style: AppTypography.heading2.copyWith(color: AppColors.main3),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            SizedBox(
              child: TextFormField(
                style: AppTypography.paragraph,
                controller: _listName,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'LIST NAME',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter shopping list name";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.275),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith(
                          (states) => AppColors.main3),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.white),
                      side: MaterialStateProperty.resolveWith((states) =>
                          const BorderSide(width: 3, color: AppColors.main3)),
                    ),
                    onPressed: () => _discardChangesDialog(),
                    child: Text(
                      'CANCEL',
                      style: AppTypography.category,
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.white),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => AppColors.main3),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        int index = widget.listIndex;
                        _taskListController.editTaskLists(
                            _listName.text,
                            '${_taskListController.taskLists.value?.items?[index].id}',
                            index);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      '  DONE  ',
                      style: AppTypography.category,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
