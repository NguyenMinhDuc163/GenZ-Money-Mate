import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'category_group_hive_model.dart';
import '../utils/icon_helper.dart';

part 'category_group_model.freezed.dart';
part 'category_group_model.g.dart';

@freezed
class CategoryGroup with _$CategoryGroup {
  const factory CategoryGroup({
    required String? uuid,
    required String? userId,
    required String name,
    required String iconName, // Tên icon từ FontAwesome
    required int colorValue, // Màu sắc dưới dạng int
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDefault, // Đánh dấu group mặc định
    @Default(0.0) double spendingLimit, // Hạn mức chi tiêu (0 = vô hạn)
  }) = _CategoryGroup;

  factory CategoryGroup.fromJson(Map<String, dynamic> json) =>
      _$CategoryGroupFromJson(json);

  factory CategoryGroup.empty() {
    return CategoryGroup(
      uuid: '',
      userId: '',
      name: '',
      iconName: 'folder',
      colorValue: Colors.grey.value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      spendingLimit: 0.0,
    );
  }

  factory CategoryGroup.fromHiveModel(CategoryGroupHive categoryGroupHive) {
    return CategoryGroup(
      uuid: categoryGroupHive.uuid,
      userId: categoryGroupHive.userId,
      name: categoryGroupHive.name,
      iconName: categoryGroupHive.iconName,
      colorValue: categoryGroupHive.colorValue,
      createdAt: categoryGroupHive.createdAt,
      updatedAt: categoryGroupHive.updatedAt,
      isDefault: categoryGroupHive.isDefault,
      spendingLimit: categoryGroupHive.spendingLimit,
    );
  }

  /// Tạo CategoryGroup mặc định
  static CategoryGroup createDefault({
    required String name,
    required IconData icon,
    required Color color,
    String? userId,
    double spendingLimit = 0.0,
  }) {
    return CategoryGroup(
      uuid: '',
      userId: userId,
      name: name,
      iconName: IconHelper.iconDataToString(icon),
      colorValue: color.value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDefault: true,
      spendingLimit: spendingLimit,
    );
  }
}

extension CategoryGroupExtension on CategoryGroup {
  CategoryGroupHive toHiveModel() {
    return CategoryGroupHive(
      uuid: uuid!,
      userId: userId ?? '',
      name: name,
      iconName: iconName,
      colorValue: colorValue,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDefault: isDefault,
      spendingLimit: spendingLimit,
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

  /// Hiển thị tên đã được dịch
  String getLocalizedName() {
    // Nếu tên bắt đầu với "default_groups.", đó là key translation
    if (name.startsWith('default_groups.')) {
      return name.tr();
    }
    // Nếu không, trả về tên gốc (cho custom groups)
    return name;
  }
}
