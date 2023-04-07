import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key, required this.title, this.addFunction, this.addIcon = const Icon(Icons.add), required this.helpFunction});

  final String title;
  final Function? addFunction;
  final Icon addIcon;
  final Function helpFunction;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.175,
        color: Colors.green,
        padding: EdgeInsets.only(left: 15, top: 15),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.66,
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 32),
              ),
            ),
            Spacer(),
            if (widget.addFunction != null)
              FloatingActionButton(
                onPressed: () => widget.addFunction!(),
                child: widget.addIcon,
              ),
            Column(
              children: [
                IconButton(
                  onPressed: () => widget.helpFunction(),
                  icon: Icon(Icons.help_outline),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}