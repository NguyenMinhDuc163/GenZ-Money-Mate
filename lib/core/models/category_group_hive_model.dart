import 'package:hive/hive.dart';

part 'category_group_hive_model.g.dart';

@HiveType(typeId: 4)
class CategoryGroupHive extends HiveObject {
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
  bool isDefault; // Đánh dấu group mặc định

  @HiveField(8)
  double spendingLimit; // Hạn mức chi tiêu (0 = vô hạn)

  CategoryGroupHive({
    required this.uuid,
    required this.userId,
    required this.name,
    required this.iconName,
    required this.colorValue,
    required this.createdAt,
    required this.updatedAt,
    required this.isDefault,
    required this.spendingLimit,
  });
}
