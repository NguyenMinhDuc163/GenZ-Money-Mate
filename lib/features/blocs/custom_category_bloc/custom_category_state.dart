part of 'custom_category_cubit.dart';

@freezed
class CustomCategoryState with _$CustomCategoryState {
  const factory CustomCategoryState.initial() = _Initial;
  const factory CustomCategoryState.loading() = _Loading;
  const factory CustomCategoryState.loaded(List<CustomCategory> categories) =
      _Loaded;
  const factory CustomCategoryState.success(String message) = _Success;
  const factory CustomCategoryState.error(String message) = _Error;
}
