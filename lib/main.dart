import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/pantryview.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/recipeview.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/used_and_expired.dart';
import 'package:kitsain_frontend_spring2023/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';
import 'package:kitsain_frontend_spring2023/views/homepage2.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/shopping_list_navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kitsain 2023 MVP',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.main2,
        primarySwatch: Colors.grey,
      ),
      home: HomePage2(),
      //home: const HomePage(title: 'Kitsain MVP 2023'),
      supportedLocales: L10n.all,
      localizationsDelegates: const [
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

  @override
  Widget build(BuildContext context) {
    double navBarHeight = 75;
    double paddingBoxHeight = 10;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Material(
        child: DefaultTabController(
          // animationDuration: Duration.zero,

          length: 4,
          child: Builder(
            builder: (BuildContext context) {
              return Container(
                color: Colors.black,
                child: SafeArea(
                  child: Scaffold(
                    backgroundColor: AppColors.main1,
                    body: const TabBarView(
                      // physics: NeverScrollableScrollPhysics(),
                      // clipBehavior: Clip.antiAlias,
                      children: [
                        PantryView(),
                        ShoppingListNavigation(),
                        UsedAndExpired(),
                        RecipeView(),
                      ],
                    ),
                    bottomNavigationBar: TabBar(
                      splashFactory: NoSplash.splashFactory,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      indicatorColor: AppColors.main2,
                      indicatorWeight: 4,
                      unselectedLabelColor: AppColors.main2,
                      labelColor: AppColors.main2,
                      tabs: [
                        DragTarget(
                          builder: (
                            BuildContext context,
                            List<dynamic> accepted,
                            List<dynamic> rejected,
                          ) {
                            return SizedBox(
                              height: navBarHeight,
                              child: Column(
                                children: [
                                  SizedBox(height: paddingBoxHeight),
                                  const Icon(
                                    Icons.house,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .pantryTabLabel,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                          onMove: (details) {
                            DefaultTabController.of(context).animateTo(0);
                          },
                        ),
                        DragTarget(
                          builder: (
                            BuildContext context,
                            List<dynamic> accepted,
                            List<dynamic> rejected,
                          ) {
                            return SizedBox(
                              height: navBarHeight,
                              child: Column(
                                children: [
                                  SizedBox(height: paddingBoxHeight),
                                  const Icon(
                                    Icons.shopping_cart,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .shoppingListsTabLabel,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            );
                          },
                          onMove: (details) {
                            DefaultTabController.of(context).animateTo(1);
                          },
                        ),
                        DragTarget(
                          builder: (
                            BuildContext context,
                            List<dynamic> accepted,
                            List<dynamic> rejected,
                          ) {
                            return Container(
                              height: navBarHeight,
                              child: Column(
                                children: [
                                  SizedBox(height: paddingBoxHeight),
                                  const Icon(
                                    Icons.pie_chart,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .pantryTabLabel,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                          onMove: (details) {
                            DefaultTabController.of(context).animateTo(2);
                          },
                        ),
                        DragTarget(
                          builder: (
                            BuildContext context,
                            List<dynamic> accepted,
                            List<dynamic> rejected,
                          ) {
                            return SizedBox(
                              height: navBarHeight,
                              child: Column(
                                children: [
                                  SizedBox(height: paddingBoxHeight),
                                  const Icon(
                                    Icons.food_bank_outlined,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .recipeTabLabel,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                          onMove: (details) {
                            DefaultTabController.of(context).animateTo(0);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
