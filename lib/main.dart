import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';
import 'package:kitsain_frontend_spring2023/views/add_new_item_form.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/my_pantry.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/used_and_expired.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/shopping_list_navigation.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kitsain 2023 MVP',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const HomePage(title: 'Kitsain MVP 2023'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StateController = Get.put(ItemController());

  @override
  void initState() {
    // TODO: implement initState
    StateController.addData();
    super.initState();
  }

  int _navigationMenuIndex = 0;
  final _pages = [
    MyPantry(),
    ShoppingListNavigation(),
    UsedAndExpired(),
  ];

  void _navMenuItemSelected(int index) {
    setState(() {
      _navigationMenuIndex = index;
    });
  }

  void _addNewItem() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return NewItemForm();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title),
              Image(
                image: AssetImage('assets/images/Kitsain_logo.png'),
                width: 150,
                height: 150,
              )
            ],
          ),
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
          destinations: [
            DragTarget(
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return const NavigationDestination(
                    icon: Icon(Icons.house), label: 'MY PANTRY');
              },
              onMove: (details) {
                _navigationMenuIndex = 0;
                _navMenuItemSelected(0);
              },
            ),
            DragTarget(
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return const NavigationDestination(
                    icon: Icon(Icons.shopping_cart), label: 'SHOPPING LIST');
              },
              onMove: (details) {
                _navigationMenuIndex = 1;
                _navMenuItemSelected(1);
              },
            ),
            DragTarget(
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return const NavigationDestination(
                    icon: Icon(Icons.recycling), label: 'USED & EXPIRED');
              },
              onMove: (details) {
                _navigationMenuIndex = 2;
                _navMenuItemSelected(2);
              },
            ),
          ],
        ),
      ),
    );
  }
}
