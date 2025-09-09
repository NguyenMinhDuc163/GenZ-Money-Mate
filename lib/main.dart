import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'app/daily_tracker_app.dart';
import 'bloc_observer.dart';
import 'core/app_injections.dart';
import 'core/router/app_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Future.wait([initAppConfig()]);
  Bloc.observer = AppBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi'), Locale('zh')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      child: DailyTrackerApp(appRoute: AppRouter()),
    ),
  );
}
