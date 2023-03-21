import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/google_sign_in.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class NewItemForm extends StatefulWidget {
  const NewItemForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewItemFormState createState() => _NewItemFormState();
}

@override
class _NewItemFormState extends State<NewItemForm> {
  final _barcodeField = TextEditingController();

  final loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                loginController.googleLogin();
              },
              child: const Text('Google Sign In'),
            ),
            ElevatedButton(
              onPressed: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SimpleBarcodeScannerPage(),
                    ));
                setState(() {
                  if (res is String) {
                    _barcodeField.text = res;
                  }
                });
              },
              child: const Text('Open Scanner'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                controller: _barcodeField,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Barcode',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
