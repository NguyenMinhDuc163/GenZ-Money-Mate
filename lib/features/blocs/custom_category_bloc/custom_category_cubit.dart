import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/models/custom_category_model.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../transaction/data/repository/custom_category_base_repository.dart';

part 'custom_category_cubit.freezed.dart';
part 'custom_category_state.dart';

class CustomCategoryCubit extends Cubit<CustomCategoryState> {
  final CustomCategoryBaseRepository _customCategoryRepository;

  CustomCategoryCubit({
    required CustomCategoryBaseRepository customCategoryRepository,
  }) : _customCategoryRepository = customCategoryRepository,
       super(const CustomCategoryState.initial());

  /// Lấy tất cả custom categories
  Future<void> getAllCustomCategories() async {
    emit(const CustomCategoryState.loading());

    final result = await _customCategoryRepository.getAllCustomCategories();
    result.when(
      success: (categories) => emit(CustomCategoryState.loaded(categories)),
      failure: (message) => emit(CustomCategoryState.error(message)),
    );
  }

  /// Thêm custom category mới
  Future<void> addCustomCategory({
    required String name,
    required IconData icon,
    required Color color,
  }) async {
    emit(const CustomCategoryState.loading());

    final customCategory = CustomCategory(
      uuid: '',
      userId: '',
      name: name,
      iconName: IconHelper.iconDataToString(icon),
      colorValue: color.value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await _customCategoryRepository.addCustomCategory(
      customCategory,
    );
    result.when(
      success: (_) {
        emit(
          const CustomCategoryState.success('custom_category.created_success'),
        );
      },
      failure: (message) => emit(CustomCategoryState.error(message)),
    );
  }

  /// Cập nhật custom category
  Future<void> updateCustomCategory(CustomCategory customCategory) async {
    emit(const CustomCategoryState.loading());

    final result = await _customCategoryRepository.updateCustomCategory(
      customCategory,
    );
    result.when(
      success: (_) {
        emit(
          const CustomCategoryState.success('custom_category.updated_success'),
        );
      },
      failure: (message) => emit(CustomCategoryState.error(message)),
    );
  }

  /// Xóa custom category
  Future<void> deleteCustomCategory(String categoryId) async {
    emit(const CustomCategoryState.loading());

    final result = await _customCategoryRepository.deleteCustomCategory(
      categoryId,
    );
    result.when(
      success: (_) {
        emit(
          const CustomCategoryState.success('custom_category.deleted_success'),
        );
      },
      failure: (message) => emit(CustomCategoryState.error(message)),
    );
  }

  /// Khởi tạo categories mặc định
  Future<void> initializeDefaultCategories() async {
    emit(const CustomCategoryState.loading());

    final result =
        await _customCategoryRepository.initializeDefaultCategories();
    result.when(
      success: (_) {
        // Reload danh sách categories sau khi khởi tạo
        getAllCustomCategories();
      },
      failure: (message) => emit(CustomCategoryState.error(message)),
    );
  }
}
