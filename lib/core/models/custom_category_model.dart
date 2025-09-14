import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

import 'custom_category_hive_model.dart';
import '../utils/icon_helper.dart';

part 'custom_category_model.freezed.dart';
part 'custom_category_model.g.dart';

@freezed
class CustomCategory with _$CustomCategory {
  const factory CustomCategory({
    required String? uuid,
    required String? userId,
    required String name,
    required String iconName, // Tên icon từ FontAwesome
    required int colorValue, // Màu sắc dưới dạng int
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDefault, // Đánh dấu category mặc định
    @Default('')
    String groupId, // ID của CategoryGroup mà category này thuộc về
  }) = _CustomCategory;

  factory CustomCategory.fromJson(Map<String, dynamic> json) =>
      _$CustomCategoryFromJson(json);

  factory CustomCategory.empty() {
    return CustomCategory(
      uuid: '',
      userId: '',
      name: '',
      iconName: 'ellipsis',
      colorValue: Colors.grey.value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory CustomCategory.fromHiveModel(CustomCategoryHive customCategoryHive) {
    return CustomCategory(
      uuid: customCategoryHive.uuid,
      userId: customCategoryHive.userId,
      name: customCategoryHive.name,
      iconName: customCategoryHive.iconName,
      colorValue: customCategoryHive.colorValue,
      createdAt: customCategoryHive.createdAt,
      updatedAt: customCategoryHive.updatedAt,
      isDefault: customCategoryHive.isDefault,
      groupId: customCategoryHive.groupId ?? '',
    );
  }
}

extension CustomCategoryExtension on CustomCategory {
  CustomCategoryHive toHiveModel() {
    return CustomCategoryHive(
      uuid: uuid!,
      userId: userId ?? '',
      name: name,
      iconName: iconName,
      colorValue: colorValue,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDefault: isDefault,
      groupId: groupId,
    );
  }

  /// Chuyển đổi iconName thành IconData
  IconData get icon {
    return IconHelper.stringToIconData(iconName);
  }

  /// Chuyển đổi colorValue thành Color
  Color get color {
    return Color(colorValue);
  }

  /// Tạo CustomCategory từ Categorys enum (để chuyển đổi categories mặc định)
  static CustomCategory fromDefaultCategory({
    required String name,
    required IconData icon,
    required Color color,
    String? userId,
    String? groupId,
  }) {
    return CustomCategory(
      uuid: '',
      userId: userId,
      name: name,
      iconName: IconHelper.iconDataToString(icon),
      colorValue: color.value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDefault: true,
      groupId: groupId ?? '',
    );
  }
}
