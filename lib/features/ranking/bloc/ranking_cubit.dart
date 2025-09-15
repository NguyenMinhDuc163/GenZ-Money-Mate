import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/ranking_model.dart';
import '../../../core/service/ranking_service.dart';
import '../../home/data/main_repository/main_base_repository.dart';
import '../../transaction/data/repository/category_group_base_repository.dart';

part 'ranking_cubit.freezed.dart';
part 'ranking_state.dart';

class RankingCubit extends Cubit<RankingState> {
  final MainBaseRepository _mainRepository;
  final CategoryGroupBaseRepository _categoryGroupRepository;

  RankingCubit({
    required MainBaseRepository mainRepository,
    required CategoryGroupBaseRepository categoryGroupRepository,
  }) : _mainRepository = mainRepository,
       _categoryGroupRepository = categoryGroupRepository,
       super(const RankingState.initial());

  Future<void> loadRankingData() async {
    emit(const RankingState.loading());

    try {
      // Load transactions
      final transactionsResult = await _mainRepository.getAll(limit: null);
      final categoryGroupsResult =
          await _categoryGroupRepository.getAllCategoryGroups();

      transactionsResult.when(
        success: (transactions) {
          categoryGroupsResult.when(
            success: (categoryGroups) {
              // Tính toán ranking
              final userRanking = RankingService.calculateUserRanking(
                transactions: transactions,
                categoryGroups: categoryGroups,
                userId: 'current_user', // Có thể lấy từ auth
              );

              emit(RankingState.loaded(userRanking));
            },
            failure: (message) => emit(RankingState.error(message)),
          );
        },
        failure: (message) => emit(RankingState.error(message)),
      );
    } catch (e) {
      emit(RankingState.error(e.toString()));
    }
  }
}
