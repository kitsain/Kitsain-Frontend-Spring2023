import 'package:flutter/material.dart';

class MyPantry extends StatefulWidget {
  const MyPantry({super.key});

  @override
  State<MyPantry> createState() => _MyPantryState();
}

class _MyPantryState extends State<MyPantry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          children: <Widget>[
            Draggable<String>(
              data: 'Example item 1',
              feedback: Material(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: ListTile(
                    tileColor: Colors.lightGreen,
                    title: Text('Example item 1 - currently being dragged'),
                  ),
                ),
              ),
              child: ListTile(
                title: Text('Example item 1'),
              ),
            ),
            Draggable<String>(
              data: 'Example item 2',
              feedback: Material(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: ListTile(
                    tileColor: Colors.lightGreen,
                    title: Text('Example item 2 - currently being dragged'),
                  ),
                ),
              ),
              child: ListTile(
                title: Text('Example item 2'),
              ),
            ),
            Draggable<String>(
              data: 'Example item 3',
              feedback: Material(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: ListTile(
                    tileColor: Colors.lightGreen,
                    title: Text('Example item 3 - currently being dragged'),
                  ),
                ),
              ),
              child: ListTile(
                title: Text('Example item 3'),
              ),
            ),
          ]
      ),
    );
  }
}