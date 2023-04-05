import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';

class UsedAndExpired extends StatefulWidget {
  const UsedAndExpired({super.key});

  @override
  State<UsedAndExpired> createState() => _UsedAndExpiredState();
}

class _UsedAndExpiredState extends State<UsedAndExpired> {
  String _placeholderDataModel = "Drop";

  _receiveItem(String data) {
    setState(() {
      _placeholderDataModel = data;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$data")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      _placeholderDataModel = AppLocalizations.of(context)!.dropTarget;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DragTarget<String>(
            onAccept: (data) => _receiveItem(data),
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.50,
                height: MediaQuery.of(context).size.height * 0.20,
                color: Colors.lightGreen,
                alignment: Alignment.center,
                child: Text(_placeholderDataModel),
              );
            },
          ),
        ],
      );
    });
  }
}