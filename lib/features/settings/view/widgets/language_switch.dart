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
        final currentLocale = context.locale;
        final isVi = currentLocale.languageCode == 'vi';
        return ItemSettings(
          title: isVi ? 'Tiếng Việt' : 'English',
          iconData: FontAwesomeIcons.language,
          backgroundIcon: Colors.indigo,
          trailing: Switch(
            value: isVi,
            onChanged: (toVi) async {
              final next = toVi ? const Locale('vi') : const Locale('en');
              await context.read<LanguageCubit>().setLocale(context, next);
            },
          ),
        );
      },
    );
  }
}
