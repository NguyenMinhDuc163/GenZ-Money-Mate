import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extension/extension.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../blocs/language_bloc/language_cubit.dart';

class VersionSheet extends StatelessWidget {
  const VersionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) {
        return SizedBox(
          height: context.deviceSize.height * 0.3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text('version.title'.tr(), style: AppTextStyle.title),
                const SizedBox(height: 25),
                Text(
                  'version.copyright'.tr(),
                  style: AppTextStyle.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Text('version.developed_by'.tr(), style: AppTextStyle.body),
                const SizedBox(height: 10),
                Text(
                  'version.developer'.tr(),
                  style: AppTextStyle.title2.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
