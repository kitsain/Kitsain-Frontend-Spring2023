import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/l10n/l10n.dart';
import 'package:kitsain_frontend_spring2023/locale_provider.dart';
import 'package:provider/provider.dart';

class LanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final provider = Provider.of<LocaleProvider>(context, listen: false);

    return DropdownButton(
      value: locale,
      items: L10n.all.map( (locale) {
        return DropdownMenuItem(
          value: locale,
          child: Center(
            child: Text(locale.languageCode),
          ),
        );
    }).toList(),
    onChanged: (locale) {
        provider.setLocale(locale as Locale);
    });
  }
}