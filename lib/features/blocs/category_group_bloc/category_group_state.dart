part of 'category_group_cubit.dart';

@freezed
class CategoryGroupState with _$CategoryGroupState {
  const factory CategoryGroupState.initial() = _Initial;
  const factory CategoryGroupState.loading() = _Loading;
  const factory CategoryGroupState.loaded(List<CategoryGroup> groups) = _Loaded;
  const factory CategoryGroupState.success(String message) = _Success;
  const factory CategoryGroupState.error(String message) = _Error;
}
