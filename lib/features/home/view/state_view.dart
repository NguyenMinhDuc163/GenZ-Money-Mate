import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/enum.dart';
import '../../../core/shared/shared.dart';
import '../../blocs/language_bloc/language_cubit.dart';
import 'widgets/widgets.dart';

class StateView extends StatelessWidget {
  const StateView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Scaffold(body: _buidBody()),
        );
      },
    );
  }

  Widget _buidBody() {
    return SafeArea(
      bottom: false,
      child: Center(
        child: Column(
          children: [
            const HeaderAppBarFilter(),
            const SizedBox(height: 12),
            Expanded(
              child: CustomTabBar(
                tabControllerCount: 2,
                tabs: [
                  Tab(text: 'home.income'.tr()),
                  Tab(text: 'home.expense'.tr()),
                ],
                children: [
                  TransactionFilter(category: Category.income),
                  TransactionFilter(category: Category.expense),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
