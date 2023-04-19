import 'package:flutter/material.dart';

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

  bool _discardChangesDialog() {
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
                  Navigator.pop(context);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: FloatingActionButton(
                      child: Icon(Icons.close),
                      onPressed: () => _discardChangesDialog(),
                    ),
                  )
                ],
              ),
              SizedBox( height: MediaQuery.of(context).size.height * 0.03),
              Text(
                'NEW\nSHOPPING\nLIST',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox( height: MediaQuery.of(context).size.height * 0.03),
              Stack(
                  children: [
                    TextFormField(
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
                        child: Icon(Icons.keyboard_alt_outlined)
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
      ),
    );
  }
}

