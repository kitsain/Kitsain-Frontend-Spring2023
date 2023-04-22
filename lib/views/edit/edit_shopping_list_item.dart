import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/controller/task_controller.dart';

class EditShoppingListItemForm extends StatefulWidget {
  const EditShoppingListItemForm({super.key, required this.itemId, required this.listId, required this.itemIndex});

  final String itemId;
  final String listId;
  final int itemIndex;

  @override
  _EditItemFormState createState() => _EditItemFormState();
}

@override
class _EditItemFormState extends State<EditShoppingListItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _itemTitle = TextEditingController();
  final _itemDescription = TextEditingController();
  final _taskController = Get.put(TaskController());

  void _discardChangesDialog() {
    String originalItemName = '${_taskController.shoppingListItem.value?[widget.itemIndex].title}';
    String originalItemDescription = '${_taskController.shoppingListItem.value?[widget.itemIndex].description}';
    BuildContext outerContext = context;

    if(_itemTitle.text == originalItemName && _itemDescription.text == originalItemDescription) {
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
    _itemTitle.text = '${_taskController.shoppingListItem.value?[widget.itemIndex].title}';
    _itemDescription.text = '${_taskController.shoppingListItem.value?[widget.itemIndex].description}';

    return Form(
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
                    child: Icon(Icons.close),
                    onPressed: () => _discardChangesDialog(),
                  ),
                )
              ],
            ),
            SizedBox( height: MediaQuery.of(context).size.height * 0.03),
            Text(
              'EDIT SHOPPING LIST ITEM',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox( height: MediaQuery.of(context).size.height * 0.03),
            SizedBox(
              child: TextFormField(
                controller: _itemTitle,
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
            ),
            SizedBox( height: MediaQuery.of(context).size.height * 0.03),
            SizedBox(
              child: TextFormField(
                controller: _itemDescription,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ITEM DESCRIPTION',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter item name";
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
                        int index = widget.itemIndex;
                        _taskController.editTask(
                            _itemTitle.text,
                            _itemDescription.text,
                            widget.listId,
                            widget.itemId,
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