import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _navigationMenuIndex = 0;
  final _pages = [
    ListView(
        children: const <Widget>[
          ListTile(
            title: Text('example item'),
          ),
          ListTile(
            title: Text('example item'),
          ),
          ListTile(
            title: Text('example item'),
          ),
          ListTile(
            title: Text('example item'),
          )
        ]
    ),
    ListView(children: const <Widget>[]),
    ListView(children: const <Widget>[]),
    ListView(children: const <Widget>[]),
  ];

  void _navMenuItemSelected(int index) {
    setState(() {
      _navigationMenuIndex = index;
    });
  }

  void _addNewItem() {
    // todo: Logic for adding items
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        toolbarHeight: MediaQuery.of(context).size.height * 0.25,
      ),
      body: Center(
          child: _pages[_navigationMenuIndex],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem,
        tooltip: 'Add new item',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    bottomNavigationBar: NavigationBar(
      selectedIndex: _navigationMenuIndex,
      onDestinationSelected: (index) => _navMenuItemSelected(index),
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.restaurant),
            label: 'Page 1'),
        NavigationDestination(
            icon: Icon(Icons.playlist_add),
            label: 'page 2'),
        NavigationDestination(
            icon: Icon(Icons.blender),
            label: 'page 3'),
        NavigationDestination(
            icon: Icon(Icons.recycling),
            label: 'page 4')
      ],
    ),
    );
  }
}
