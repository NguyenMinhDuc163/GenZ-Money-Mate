part of 'ranking_cubit.dart';

@freezed
class RankingState with _$RankingState {
  const factory RankingState.initial() = _Initial;
  const factory RankingState.loading() = _Loading;
  const factory RankingState.loaded(UserRanking userRanking) = _Loaded;
  const factory RankingState.error(String message) = _Error;
}
