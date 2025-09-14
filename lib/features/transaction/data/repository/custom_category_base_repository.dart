import '../../../../core/models/custom_category_model.dart';
import '../../../../core/utils/models/app_result.dart';

abstract class CustomCategoryBaseRepository {
  /// Lấy tất cả custom categories của user
  Future<AppResult<List<CustomCategory>>> getAllCustomCategories();

  /// Thêm custom category mới
  Future<AppResult<void>> addCustomCategory(CustomCategory customCategory);

  /// Cập nhật custom category
  Future<AppResult<void>> updateCustomCategory(CustomCategory customCategory);

  /// Xóa custom category
  Future<AppResult<void>> deleteCustomCategory(String categoryId);

  /// Lấy custom category theo ID
  Future<AppResult<CustomCategory?>> getCustomCategoryById(String categoryId);

  /// Khởi tạo các categories mặc định từ enum Categorys
  Future<AppResult<void>> initializeDefaultCategories();
}
