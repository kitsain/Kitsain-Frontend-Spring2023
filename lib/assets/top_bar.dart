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
  VisualDensity topIconsDensity = VisualDensity(horizontal: -4.0, vertical: -4.0);

  _openAccountSettings() {
    // todo
  }

  _openSettings() {
    // todo
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        color: Colors.green,
        padding: const EdgeInsets.only(left: 15, top: 25, bottom: 1, right: 15),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.64,
              child: Text(
                widget.title,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      visualDensity: topIconsDensity,
                      padding: EdgeInsets.zero,
                      onPressed: () => widget.helpFunction(),
                      icon: const Icon(Icons.help_outline),
                    ),
                    IconButton(
                      visualDensity: topIconsDensity,
                      padding: EdgeInsets.zero,
                      onPressed: () => _openSettings(),
                      icon: const Icon(Icons.settings),
                    ),
                    IconButton(
                      visualDensity: topIconsDensity,
                      padding: EdgeInsets.zero,
                      onPressed: () => _openAccountSettings(),
                      icon: const Icon(Icons.account_circle),
                    ),
                  ],
                ),
                if (widget.addFunction != null)
                  Container(
                    height: 48,
                    width: 48,
                    child: FloatingActionButton(
                      onPressed: () => widget.addFunction!(),
                      child: Icon(widget.addIcon),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
