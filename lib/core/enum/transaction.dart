import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TransactionAction { add, edit }

enum Category {
  expense(
    name: 'Expense',
    backgroundIcon: Colors.redAccent,
    icon: FontAwesomeIcons.minus,
  ),
  income(
    name: 'Income',
    backgroundIcon: Colors.greenAccent,
    icon: FontAwesomeIcons.plus,
  );

  final String name;
  final IconData icon;
  final Color backgroundIcon;

  const Category({
    required this.name,
    required this.icon,
    required this.backgroundIcon,
  });

  String getLocalizedName() {
    switch (this) {
      case Category.expense:
        return 'home.expense'.tr();
      case Category.income:
        return 'home.income'.tr();
    }
  }

  // static TransactionCategory fromIndex(int categoryIndex) {
  //   return TransactionCategory.values.firstWhere(
  //     (category) => category.index == categoryIndex,
  //     orElse: () => TransactionCategory.expense,
  //   );
  // }
}
