import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/pantryview.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/used_and_expired.dart';
import 'package:kitsain_frontend_spring2023/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';
import 'package:kitsain_frontend_spring2023/views/homepage2.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/shopping_list_navigation.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: HomePage2()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kitsain 2023 MVP',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.main2,
        primarySwatch: Colors.lightGreen,
      ),
      //home: const HomePage(title: 'Kitsain MVP 2023'),
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
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
  final stateController = Get.put(ItemController());

  @override
  void initState() {
    // TODO: implement initState
    stateController.addData();
    super.initState();
  }

  int _navigationMenuIndex = 0;
  final _pages = [
    PantryView(),
    ShoppingListNavigation(),
    UsedAndExpired(),
  ];

  void _navMenuItemSelected(int index) {
    setState(
      () {
        _navigationMenuIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Material(
        child: Scaffold(
          backgroundColor: AppColors.main2,
          body: Center(
            child: _pages[_navigationMenuIndex],
          ), // This trailing comma makes auto-formatting nicer for build methods.
          bottomNavigationBar: NavigationBar(
            //backgroundColor: AppColors.main1,
            selectedIndex: _navigationMenuIndex,
            onDestinationSelected: (index) => _navMenuItemSelected(index),
            destinations: [
              DragTarget(
                builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                ) {
                  return NavigationDestination(
                      icon: Icon(
                        Icons.house,
                        //color: AppColors.main2,
                      ),
                      label: 'MY PANTRY');
                  //label: AppLocalizations.of(context)!.pantryScreen);
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
                  return NavigationDestination(
                      icon: Icon(
                        Icons.shopping_cart,
                        //color: AppColors.main2,
                      ),
                      label: 'SHOPPING LISTS');
                  //label: AppLocalizations.of(context)!.shoppingListsScreen);
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
                  return NavigationDestination(
                      icon: Icon(
                        Icons.recycling,
                        //color: AppColors.main2,
                      ),
                      label: 'PANTRY HISTORY');
                  //label: AppLocalizations.of(context)!.historyScreen);
                },
                onMove: (details) {
                  _navigationMenuIndex = 2;
                  _navMenuItemSelected(2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
