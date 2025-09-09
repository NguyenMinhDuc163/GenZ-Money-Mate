import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../settings/data/language_repository/language_base_repository.dart';
import '../main_bloc/main_cubit.dart';

class LanguageState {
  final Locale locale;
  const LanguageState(this.locale);
}

class LanguageCubit extends Cubit<LanguageState> {
  final LanguageBaseRepository _languageRepository;
  MainCubit? _mainCubit;

  LanguageCubit({required LanguageBaseRepository languageRepository})
    : _languageRepository = languageRepository,
      super(const LanguageState(Locale('en'))) {
    getLocale();
  }

  /// Set MainCubit để có thể trigger getTotals khi đổi ngôn ngữ
  void setMainCubit(MainCubit mainCubit) {
    _mainCubit = mainCubit;
  }

  Future<void> getLocale() async {
    final locale = await _languageRepository.getLocale();
    if (!isClosed) {
      emit(LanguageState(locale));
    }
  }

  Future<void> setLocale(BuildContext context, Locale locale) async {
    // Gọi setLocale trước để trigger rebuild ngay lập tức
    await context.setLocale(locale);
    // Lưu vào repository
    await _languageRepository.setLocale(locale);
    // Emit state mới
    if (!isClosed) {
      emit(LanguageState(locale));
    }
    // Trigger getTotals để tính lại với loại tiền mới
    _mainCubit?.getTotals();
  }
}
