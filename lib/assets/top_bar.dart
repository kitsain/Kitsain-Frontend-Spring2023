import 'package:flutter/material.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    required this.title,
    this.addFunction,
    this.addIcon = Icons.add,
    required this.helpFunction,
    required this.backgroundImageName,
    required this.titleBackgroundColor,
  });

  final String title;
  final Function? addFunction;
  final IconData addIcon;
  final Function helpFunction;
  final String backgroundImageName;
  final Color titleBackgroundColor;

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
        padding: const EdgeInsets.only(left: 15, top: 0, bottom: 1, right: 15),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.backgroundImageName),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).viewPadding.top),
            IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    width: MediaQuery.of(context).size.width * 0.64,
                    child: Text(
                      ' ${widget.title} ${'\u200e'}',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        backgroundColor: widget.titleBackgroundColor,
                      ),
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
                            icon: const Icon(
                              Icons.help_outline,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            visualDensity: topIconsDensity,
                            padding: EdgeInsets.zero,
                            onPressed: () => _openSettings(),
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            visualDensity: topIconsDensity,
                            padding: EdgeInsets.zero,
                            onPressed: () => _openAccountSettings(),
                            icon: const Icon(
                              Icons.account_circle,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      if (widget.addFunction != null)
                        Container(
                          height: 44,
                          width: 44,
                          child: FloatingActionButton(
                            onPressed: () => widget.addFunction!(),
                            child: Icon(widget.addIcon),
                          ),
                        ),
                      if (widget.addFunction == null)
                        const SizedBox(height: 44, width: 44),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
