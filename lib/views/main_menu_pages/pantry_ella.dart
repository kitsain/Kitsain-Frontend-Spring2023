import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/assets/item_card.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:provider/provider.dart';

class Pantry extends StatefulWidget {
  late List<Item> items;
  late Function(Item) onToggle;
  Pantry({super.key});

  @override
  State<Pantry> createState() => _PantryState();
}

class _PantryState extends State<Pantry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: const [
            ListTile(
              title: Text("MEALS"),
            ),
            ItemCard(),
            ItemCardTesting(),
            ListTile(
              title: Text("PROTEINS"),
            ),
            ListTile(
              title: Text("FRUITS"),
            ),
            ListTile(
              title: Text("VEGETABLES"),
            ),
            ListTile(
              title: Text("DAIRY"),
            ),
            ListTile(
              title: Text("FROZEN"),
            ),
            ListTile(
              title: Text("DRY & CANNED"),
            ),
            ListTile(
              title: Text("DRINKS"),
            ),
            ListTile(
              title: Text("TREATS"),
            ),
          ],
        ),
      ),
    );
  }
}

//   Widget getItemBuilder(BuildContext context, int index) {
//     Item item = items[index];
//   }

// class _ItemInfo extends StatelessWidget {
//   final int index;
//   const _ItemInfo(this.index, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var item = context.select<Pantry, Item>(
//       (pantry) => pantry.getByPosition(index),
//     );

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: LimitedBox(
//         maxHeight: 48,
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(item.name),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Pantry extends StatelessWidget {
//   var items = PantryProxy().getItems();
//   late Function(Item) onToggle;
//   Pantry({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       itemBuilder: getItemBuilder,
//       separatorBuilder: getSeparatorBuilder,
//       itemCount: items.length,
//       padding: const EdgeInsets.all(10),
//       shrinkWrap: true,
//       scrollDirection: Axis.vertical,
//       physics: const BouncingScrollPhysics(),
//     );
//   }

//   Widget getItemBuilder(BuildContext context, int index) {
//     Item item = items[index];
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Text(item.name),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget getSeparatorBuilder(BuildContext, int index) {
//     return const Divider();
//   }
// }

