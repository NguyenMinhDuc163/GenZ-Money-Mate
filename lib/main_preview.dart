import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/helper/helper.dart';
import '../features/blocs/auth_bloc/auth_cubit.dart';
import '../features/blocs/main_bloc/main_cubit.dart';
import '../features/blocs/profile_bloc/profile_cubit.dart';
import '../features/blocs/state_bloc/state_cubit.dart';
import '../features/blocs/themes_bloc/themes_cubit.dart';
import '../features/blocs/transaction_bloc/transaction_cubit.dart';
import '../features/blocs/language_bloc/language_cubit.dart';
import '../features/blocs/custom_category_bloc/custom_category_cubit.dart';
import '../features/blocs/category_group_bloc/category_group_cubit.dart';
import '../features/ranking/bloc/ranking_cubit.dart';
import 'bloc_observer.dart';
import 'core/app_injections.dart';
import 'core/router/app_route.dart';
import 'package:device_preview/device_preview.dart';

// Cho phép bật DevicePreview khi build release qua --dart-define=ENABLE_DEVICE_PREVIEW=true
const bool kEnableDevicePreview = bool.fromEnvironment(
  'ENABLE_DEVICE_PREVIEW',
  defaultValue: false,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([initAppConfig()]);
  Bloc.observer = AppBlocObserver();

  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi'), Locale('zh')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      child: DevicePreview(
        enabled: kEnableDevicePreview || !kReleaseMode,
        builder: (context) => DailyTrackerApp(appRoute: AppRouter()),
      ),
    ),
  );
}

class DailyTrackerApp extends StatelessWidget {
  const DailyTrackerApp({super.key, required AppRouter appRoute})
    : _appRouter = appRoute;

  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    Helper.overlayNavigation(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<MainCubit>()),
        BlocProvider(create: (_) => getIt<TransactionCubit>()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()),
        BlocProvider(create: (_) => getIt<StateCubit>()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<ThemesCubit>()),
        BlocProvider(create: (_) => getIt<LanguageCubit>()),
        BlocProvider(create: (_) => getIt<CustomCategoryCubit>()),
        BlocProvider(create: (_) => getIt<CategoryGroupCubit>()),
        BlocProvider(create: (_) => getIt<RankingCubit>()),
      ],
      child: BlocBuilder<ThemesCubit, ThemesState>(
        buildWhen: (previous, current) => current is LoadedThemeMode,
        builder: (context, state) {
          final themeMode = context.read<ThemesCubit>().state.maybeMap(
            orElse: () => ThemeMode.dark,
            loadedThemeMode: (state) => state.themeMode,
          );
          // Thiết lập MainCubit vào LanguageCubit như app chính
          final mainCubit = context.read<MainCubit>();
          final languageCubit = context.read<LanguageCubit>();
          languageCubit.setMainCubit(mainCubit);
          Intl.defaultLocale = context.locale.toLanguageTag();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'app.title'.tr(),
            useInheritedMediaQuery: true,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            builder: DevicePreview.appBuilder,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode,
            initialRoute: RoutesName.home,
            onGenerateRoute: _appRouter.generateRoute,
          );
        },
      ),
    );
  }
}
