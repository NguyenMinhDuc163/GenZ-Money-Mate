import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_service/user_service.dart';

import '../../features/home/view/all_view_transaction.dart';
import '../../features/home/view/home_view.dart';
import '../../features/profile/view/profile_view.dart';
import '../../features/settings/view/settings_view.dart';
import '../../features/transaction/view/transaction_view.dart';
import '../../features/ranking/view/ranking_view.dart';

@immutable
class RoutesName {
  const RoutesName._();
  static const String home = '/';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String transaction = '/transaction';
  static const String allViewTransaction = '/allViewTransaction';
  static const String ranking = '/ranking';
}

@immutable
class AppRouter {
  PageRoute generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final arguments = settings.arguments;
    switch (settings.name) {
      case RoutesName.home:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: const HomeView(),
        );
      case RoutesName.transaction:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: const TransactionView(),
        );
      case RoutesName.settings:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: const SettingsView(),
        );

      case RoutesName.profile:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ProfileView(user: arguments as User),
        );

      case RoutesName.allViewTransaction:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: const AllViewTransaction(),
        );

      case RoutesName.ranking:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: const RankingView(),
        );

      default:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: Scaffold(
            body: Center(
              child: Text('router.no_route'.tr(args: [settings.name ?? ''])),
            ),
          ),
        );
    }
  }

  PageRoute _getPageRoute({String? routeName, Widget? viewToShow}) {
    return CupertinoPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => viewToShow!,
    );
  }
}
