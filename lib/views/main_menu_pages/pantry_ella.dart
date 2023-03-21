import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/assets/item_card.dart';
import 'package:kitsain_frontend_spring2023/database/pantry_proxy.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:provider/provider.dart';

class Pantry extends StatefulWidget {
  const Pantry({super.key});

  @override
  State<Pantry> createState() => _PantryState();
}

class _PantryState extends State<Pantry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: Column(
      //     children: const [
      //       ItemCard(),
      //       ItemCard(),
      //     ],
      //   ),
      // ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 12,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _ItemInfo(index),
            ),
          )
        ],
      ),
    );
  }
}

class _ItemInfo extends StatelessWidget {
  final int index;
  const _ItemInfo(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var item = context.select<Pantry, Item>(
      (pantry) => pantry.getByPosition(index),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            Expanded(
              child: Text(item.name),
            ),
          ],
        ),
      ),
    );
  }
}
