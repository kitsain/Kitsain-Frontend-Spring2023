import 'package:flutter/material.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar(
      {super.key,
      required this.title,
      this.addFunction,
      this.addIcon = Icons.add,
      required this.helpFunction});

  final String title;
  final Function? addFunction;
  final IconData addIcon;
  final Function helpFunction;

  @override
  State<TopBar> createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.175,
        color: Colors.green,
        padding: const EdgeInsets.only(left: 15, top: 15),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.66,
              child: Text(
                widget.title,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const Spacer(),
            if (widget.addFunction != null)
              FloatingActionButton(
                onPressed: () => widget.addFunction!(),
                child: Icon(widget.addIcon),
              ),
            Column(
              children: [
                IconButton(
                  onPressed: () => widget.helpFunction(),
                  icon: const Icon(Icons.help_outline),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
