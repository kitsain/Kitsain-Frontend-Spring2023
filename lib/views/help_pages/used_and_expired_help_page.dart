import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';

class UsedAndExpiredHelp extends StatefulWidget {
  const UsedAndExpiredHelp({super.key});

  @override
  State<UsedAndExpiredHelp> createState() => _UsedAndExpiredHelp();
}

class _UsedAndExpiredHelp extends State<UsedAndExpiredHelp> {

  //Helper function for creating texts and icons.
  //Returns text and icon widgets.
  Widget _createParagraph(List<String> paragraph, bool icons) {
    List<Widget> list = <Widget>[];
    for(var line in paragraph) {
      list.add(Text(line, style: AppTypography.paragraph));
      //After last row don't add empty space
      if(line != paragraph[paragraph.length -1]) {
        list.add(SizedBox(height: 3));
      }
    }
    if(icons) {
      list.add(Row(
        children: [
          Icon(Icons.check_box_outline_blank, size: 180),
          Icon(Icons.check_box_outline_blank, size: 180),
        ],
      ));
    }
    return new Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> paragraphs = [
      AppLocalizations.of(context)!.pantryHistoryHelpText1.split("\n"),
      AppLocalizations.of(context)!.pantryHistoryHelpText2.split("\n"),
      AppLocalizations.of(context)!.pantryHistoryHelpText3.split("\n"),
      AppLocalizations.of(context)!.pantryHistoryHelpText4.split("\n"),
    ];

    return Builder(builder: (context) {
      return ListView(
          children: <Widget> [
            Column(
              children: [
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: FloatingActionButton(
                        foregroundColor: AppColors.main2,
                        backgroundColor: AppColors.main3,
                        child: const Icon(Icons.close),
                        onPressed: () {
                            Navigator.pop(context);
                          }
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(AppLocalizations.of(context)!.pantryHistoryHelpTitle,
                  style: AppTypography.heading2.copyWith(color: AppColors.main3),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                _createParagraph(paragraphs[0], true),
                _createParagraph(paragraphs[1], true),
                _createParagraph(paragraphs[2], true),
                _createParagraph(paragraphs[3], false),
                SizedBox(height: 50),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main2),
                      backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.main3),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.closeHelpSection,
                      style: AppTypography.category,
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ]
      );
    });
  }
}
