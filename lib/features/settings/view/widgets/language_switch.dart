import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../blocs/language_bloc/language_cubit.dart';
import 'item_settings.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final current = context.locale;
        String title;
        switch (current.languageCode) {
          case 'vi':
            title = 'Tiếng Việt';
            break;
          case 'zh':
            title = '中文';
            break;
          default:
            title = 'English';
        }
        return ItemSettings(
          title: title,
          iconData: FontAwesomeIcons.language,
          backgroundIcon: Colors.indigo,
          trailing: DropdownButton<Locale>(
            value: current,
            underline: const SizedBox.shrink(),
            items: const [
              DropdownMenuItem(value: Locale('en'), child: Text('English')),
              DropdownMenuItem(value: Locale('vi'), child: Text('Tiếng Việt')),
              DropdownMenuItem(value: Locale('zh'), child: Text('中文')),
            ],
            onChanged: (locale) async {
              if (locale == null) return;
              await context.read<LanguageCubit>().setLocale(context, locale);
            },
          ),
        );
      },
    );
  }
}
