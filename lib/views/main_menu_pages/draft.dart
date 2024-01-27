import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/src/home/main_example.dart';
import 'package:kitsain_frontend_spring2023/src/search_example.dart';
import 'package:kitsain_frontend_spring2023/src/simple_example_hook.dart';

//import 'src/adv_home/home_example.dart';
import 'package:kitsain_frontend_spring2023/src/home/home_example.dart';

class mapmain extends StatelessWidget {
  const mapmain({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      initialRoute: "/home",
      routes: {
        "/home": (context) => MainPageExample(),
        "/old-home": (context) => OldMainExample(),
        "/hook": (context) => SimpleHookExample(),
        //"/adv-home": (ctx) => AdvandedMainExample(),
        // "/nav": (ctx) => MyHomeNavigationPage(
        //       map: Container(),
        // ),
        "/second": (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/old-home");
              },
              child: Text("another page"),
            ),
          ),
        ),
        "/picker-result": (context) => LocationAppExample(),
        "/search": (context) => SearchPage(),
      },
    );
  }
}