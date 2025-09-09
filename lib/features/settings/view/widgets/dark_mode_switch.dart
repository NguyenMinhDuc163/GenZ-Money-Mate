import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../blocs/themes_bloc/themes_cubit.dart';
import '../../../blocs/language_bloc/language_cubit.dart';
import 'widgets.dart';

class DarkModeSwitch extends StatefulWidget {
  const DarkModeSwitch({super.key});

  @override
  State<DarkModeSwitch> createState() => _DarkModeSwitchState();
}

class _DarkModeSwitchState extends State<DarkModeSwitch> {
  late bool isSwitched;

  @override
  void initState() {
    isSwitched = context.read<ThemesCubit>().state.maybeMap(
      orElse: () => false,
      loadedThemeMode: (state) => state.themeMode == ThemeMode.dark,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) {
        return ItemSettings(
          title:
              isSwitched ? 'setting.dark_mode'.tr() : 'setting.light_mode'.tr(),
          iconData:
              isSwitched ? FontAwesomeIcons.moon : FontAwesomeIcons.solidSun,
          backgroundIcon: Colors.grey.shade800,
          trailing: BlocBuilder<ThemesCubit, ThemesState>(
            builder: (context, state) {
              return Switch(
                value: isSwitched,
                onChanged: (themeMode) {
                  setState(() {
                    isSwitched = themeMode;
                    context.read<ThemesCubit>().toggleTheme();
                  });
                },
              );
            },
          ),
        );
      },
    );
  }
}
