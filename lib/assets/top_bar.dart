import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';
import 'package:kitsain_frontend_spring2023/l10n/language_picker.dart';
import 'package:kitsain_frontend_spring2023/l10n/locale_provider.dart';
import 'package:provider/provider.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    required this.title,
    this.addFunction,
    this.addIcon,
    required this.helpFunction,
    required this.backgroundImageName,
    required this.titleBackgroundColor,
  });

  final String title;
  final Function? addFunction;
  final Image? addIcon;
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
        //color: Colors.green,
        padding: const EdgeInsets.only(left: 15, top: 25, bottom: 1, right: 15),
        decoration: BoxDecoration(
          image: DecorationImage(
            //image: AssetImage("assets/images/pantry_banner_2.jpg"),
            //image: AssetImage("assets/images/ue_banner_darker_3.png"),
            image: AssetImage(widget.backgroundImageName),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.64,
              child: Text(
                ' ${widget.title} ${'\u200e'}',
                style: AppTypography.whiteHeading2.copyWith(
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
                      icon: const Icon(Icons.help_outline,
                        color: Colors.white,
                      ),
                    ),
                    LanguagePicker(icon: const Icon(Icons.settings, color: Colors.white,)),
                    // IconButton(
                    //   visualDensity: topIconsDensity,
                    //   padding: EdgeInsets.zero,
                    //   onPressed: () => _openSettings(),
                    //   icon: const Icon(Icons.settings,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    IconButton(
                      visualDensity: topIconsDensity,
                      padding: EdgeInsets.zero,
                      onPressed: () => _openAccountSettings(),
                      icon: const Icon(Icons.account_circle,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (widget.addFunction != null)
                  Container(
                    height: 60,
                    width: 60,
                    child: InkWell(
                      onTap: () => widget.addFunction!(),
                      child: widget.addIcon ?? Image.asset('assets/images/post_add.png'),
                      // child: Image.asset('assets/images/post_add.png',
                      //   color: Colors.white,
                      //   fit: BoxFit.cover,
                      // ),
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
