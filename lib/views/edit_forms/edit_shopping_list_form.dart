import 'package:flutter/material.dart';

class EditShoppingListForm extends StatefulWidget {
  const EditShoppingListForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditItemFormState createState() => _EditItemFormState();
}

@override
class _EditItemFormState extends State<EditShoppingListForm> {
  final _formKey = GlobalKey<FormState>();
  final _listName = TextEditingController();
  var _currentList = 'DAILY';

  void _discardChangesDialog() {
    if(_listName.text.isEmpty) {
      Navigator.pop(context);
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
                },
              ),
              TextButton(
                child: const Text('DISCARD'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              'EDIT "${_currentList}"',
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
                        print("OK");
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

