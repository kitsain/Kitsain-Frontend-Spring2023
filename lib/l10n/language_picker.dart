import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/l10n/l10n.dart';
import 'package:kitsain_frontend_spring2023/l10n/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:kitsain_frontend_spring2023/app_typography.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key, required this.icon});

  final Icon icon;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final provider = Provider.of<LocaleProvider>(context, listen: false);

    return DropdownButton(
      icon: icon,
      items: L10n.all.map((locale) {
        return DropdownMenuItem(
          value: locale,
          child: Center(
            child: Text(locale.languageCode,
              style: AppTypography.category,
            ),
          ),
        );
      },
      ).toList(),
      onChanged: (locale) {
        provider.setLocale(locale as Locale);
      },
    );
  }
}