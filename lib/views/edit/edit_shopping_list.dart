import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    return Form(
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
            SizedBox( height: MediaQuery.of(context).size.height * 0.03),
            Text(
              'EDIT SHOPPING LIST',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox( height: MediaQuery.of(context).size.height * 0.03),
            SizedBox(
              child: TextFormField(
                controller: _listName,
                decoration: const InputDecoration(
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
            SizedBox( height: MediaQuery.of(context).size.height * 0.375),
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
                        int index = widget.listIndex;
                        _taskListController.editTaskLists(
                            _listName.text,
                            '${_taskListController.taskLists.value?.items?[index].id}',
                            index);
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
    );
  }
}
