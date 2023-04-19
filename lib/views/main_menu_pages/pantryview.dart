import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';
import 'package:kitsain_frontend_spring2023/assets/top_bar.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:kitsain_frontend_spring2023/views/add_forms/add_new_item_form.dart';
import 'package:realm/realm.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'package:kitsain_frontend_spring2023/assets/itembuilder.dart';
import 'package:kitsain_frontend_spring2023/views/help_pages/pantry_help_page.dart';

class PantryView extends StatefulWidget with ChangeNotifier {
  late final Function(Item) onToggle;

  PantryView({super.key});

  @override
  State<PantryView> createState() => _PantryViewState();
}

class _PantryViewState extends State<PantryView> {
  Future<RealmResults<Item>> _getPantryItems() async {
    return PantryProxy().getPantryItems();
  }

  List<String> categories = <String>[
    'Meat',
    'Seafood',
    'Fruit',
    'Vegetables',
    'Frozen',
    'Drinks',
    'Bread',
    'Sweets',
    'Dairy',
    'Ready meals',
    'Dry & canned goods',
    'Other'
  ];

  void _addNewItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          heightFactor: 0.7,
          child: NewItemForm(),
        );
      },
    );
  }
  void _help() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          //heightFactor: 0.7,
          child: PantryHelp(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: AppLocalizations.of(context)!.pantryScreen,
        addFunction: _addNewItem,
        addIcon: Icons.add_home,
        helpFunction: _help,
      ),
      body: FutureBuilder<RealmResults>(
        future: _getPantryItems(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Your pantry is empty."),
            );
          } else {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  for (var cat in categories)
                    Column(
                      children: [
                        Text(
                          cat.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        ItemBuilder(
                          items: PantryProxy().getByMainCat(cat),
                        ),
                      ],
                    )
                ],
              );
            } else {
              return const Center(
                child: Text("Your pantry is empty."),
              );
            }
          }
        },
      ),
    );
  }
}
