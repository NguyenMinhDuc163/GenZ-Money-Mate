import '../../../../core/models/category_group_model.dart';
import '../../../../core/utils/models/app_result.dart';

abstract class CategoryGroupBaseRepository {
  Future<AppResult<List<CategoryGroup>>> getAllCategoryGroups();
  Future<AppResult<void>> addCategoryGroup(CategoryGroup categoryGroup);
  Future<AppResult<void>> updateCategoryGroup(CategoryGroup categoryGroup);
  Future<AppResult<void>> deleteCategoryGroup(String groupId);
  Future<AppResult<CategoryGroup?>> getCategoryGroupById(String groupId);
  Future<AppResult<void>> initializeDefaultGroups();
}
