import 'package:hive/hive.dart';

part 'custom_category_hive_model.g.dart';

@HiveType(typeId: 3)
class CustomCategoryHive extends HiveObject {
  @HiveField(0)
  String uuid;

  @HiveField(1)
  String? userId;

  @HiveField(2)
  String name;

  @HiveField(3)
  String iconName; // Tên icon từ FontAwesome

  @HiveField(4)
  int colorValue; // Màu sắc dưới dạng int

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime updatedAt;

  @HiveField(7)
  bool isDefault; // Đánh dấu category mặc định

  CustomCategoryHive({
    required this.uuid,
    required this.userId,
    required this.name,
    required this.iconName,
    required this.colorValue,
    required this.createdAt,
    required this.updatedAt,
    required this.isDefault,
  });
}
