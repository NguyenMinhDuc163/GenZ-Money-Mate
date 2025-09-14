import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/models/category_group_model.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../transaction/data/repository/category_group_base_repository.dart';

part 'category_group_cubit.freezed.dart';
part 'category_group_state.dart';

class CategoryGroupCubit extends Cubit<CategoryGroupState> {
  final CategoryGroupBaseRepository _categoryGroupRepository;

  CategoryGroupCubit({
    required CategoryGroupBaseRepository categoryGroupRepository,
  }) : _categoryGroupRepository = categoryGroupRepository,
       super(const CategoryGroupState.initial());

  /// Lấy tất cả category groups
  Future<void> getAllCategoryGroups() async {
    emit(const CategoryGroupState.loading());

    final result = await _categoryGroupRepository.getAllCategoryGroups();
    result.when(
      success: (groups) => emit(CategoryGroupState.loaded(groups)),
      failure: (message) => emit(CategoryGroupState.error(message)),
    );
  }

  /// Thêm category group mới
  Future<void> addCategoryGroup({
    required String name,
    required IconData icon,
    required Color color,
    double spendingLimit = 0.0,
  }) async {
    emit(const CategoryGroupState.loading());

    // Debug log
    print(
      'CategoryGroupCubit: Creating group with spending limit: $spendingLimit',
    );

    final categoryGroup = CategoryGroup(
      uuid: '',
      userId: '',
      name: name,
      iconName: IconHelper.iconDataToString(icon),
      colorValue: color.value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      spendingLimit: spendingLimit,
    );

    // Debug log
    print('CategoryGroupCubit: Created group: $categoryGroup');

    final result = await _categoryGroupRepository.addCategoryGroup(
      categoryGroup,
    );
    result.when(
      success: (_) {
        emit(
          const CategoryGroupState.success('category_group.created_success'),
        );
      },
      failure: (message) => emit(CategoryGroupState.error(message)),
    );
  }

  /// Cập nhật category group
  Future<void> updateCategoryGroup(CategoryGroup categoryGroup) async {
    emit(const CategoryGroupState.loading());

    final result = await _categoryGroupRepository.updateCategoryGroup(
      categoryGroup,
    );
    result.when(
      success: (_) {
        emit(
          const CategoryGroupState.success('category_group.updated_success'),
        );
      },
      failure: (message) => emit(CategoryGroupState.error(message)),
    );
  }

  /// Xóa category group
  Future<void> deleteCategoryGroup(String groupId) async {
    emit(const CategoryGroupState.loading());

    final result = await _categoryGroupRepository.deleteCategoryGroup(groupId);
    result.when(
      success: (_) {
        // Reload danh sách groups sau khi xóa thành công
        getAllCategoryGroups();
      },
      failure: (message) => emit(CategoryGroupState.error(message)),
    );
  }

  /// Khởi tạo groups mặc định
  Future<void> initializeDefaultGroups() async {
    emit(const CategoryGroupState.loading());

    final result = await _categoryGroupRepository.initializeDefaultGroups();
    result.when(
      success: (_) {
        // Reload danh sách groups sau khi khởi tạo
        getAllCategoryGroups();
      },
      failure: (message) => emit(CategoryGroupState.error(message)),
    );
  }
}
