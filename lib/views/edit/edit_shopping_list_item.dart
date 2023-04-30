import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';
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
                    foregroundColor: AppColors.main2,
                    backgroundColor: AppColors.main3,
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
              style: AppTypography.heading2.copyWith(color: AppColors.main3),
            ),
            SizedBox( height: MediaQuery.of(context).size.height * 0.03),
            SizedBox(
              child: TextFormField(
                style: AppTypography.smallTitle,
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
                style: AppTypography.smallTitle,
                controller: _itemDescription,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ITEM DESCRIPTION',
                ),
              ),
            ),
            SizedBox( height: MediaQuery.of(context).size.height * 0.275),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: ElevatedButton(
                    onPressed: () => _discardChangesDialog(),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main3),
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                      side: MaterialStateProperty.resolveWith((states) => const BorderSide(width: 3, color: AppColors.main3)),
                    ),
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
                      foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main2),
                      backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main3),
                    ),
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
                    child: Text('  DONE  ', style: AppTypography.category,),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}