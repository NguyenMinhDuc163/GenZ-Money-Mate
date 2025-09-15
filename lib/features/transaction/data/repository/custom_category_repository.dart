import 'dart:async';

import 'package:auth_user/auth_user.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:db_hive_client/db_hive_client.dart';

import '../../../../core/enum/categorys.dart';
import '../../../../core/helper/helper.dart';
import '../../../../core/models/custom_category_hive_model.dart';
import '../../../../core/models/custom_category_model.dart';
import '../../../../core/utils/models/app_result.dart';
import 'custom_category_base_repository.dart';

class CustomCategoryRepository implements CustomCategoryBaseRepository {
  final DbFirestoreClientBase _dbFirestoreClient;
  final DbHiveClientBase _dbHiveClient;
  final AuthUserBase _authUser;

  CustomCategoryRepository({
    required DbFirestoreClientBase dbFirestoreClient,
    required AuthUserBase authUser,
    required DbHiveClientBase dbHiveClient,
  }) : _dbFirestoreClient = dbFirestoreClient,
       _dbHiveClient = dbHiveClient,
       _authUser = authUser;

  /// The [isUserLoggedIn] method is used to check if the user is logged in.
  bool get isUserLoggedIn => _authUser.currentUser != null;

  @override
  Future<AppResult<List<CustomCategory>>> getAllCustomCategories() async {
    try {
      if (!isUserLoggedIn) {
        // Lấy từ Hive local storage
        final hiveCategories = await _dbHiveClient.getAll<CustomCategoryHive>(
          boxName: 'custom_categories',
        );

        final categories =
            hiveCategories.map(CustomCategory.fromHiveModel).toList();

        return AppResult.success(categories);
      } else {
        // Lấy từ Firestore
        final result = await _dbFirestoreClient.getQuery<CustomCategory>(
          collectionPath: 'custom_categories',
          field: 'userId',
          isEqualTo: _authUser.currentUser!.uid,
          mapper:
              (data, documentId) =>
                  CustomCategory.fromJson(data as Map<String, dynamic>),
        );

        return AppResult.success(result);
      }
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> addCustomCategory(
    CustomCategory customCategory,
  ) async {
    try {
      final generUUID = Helper.generateUUID();
      final categoryWithId = customCategory.copyWith(
        uuid: generUUID,
        userId: _authUser.currentUser?.uid,
      );

      if (!isUserLoggedIn) {
        await _dbHiveClient.add<CustomCategoryHive>(
          boxName: 'custom_categories',
          modelId: generUUID,
          modelHive: categoryWithId.toHiveModel(),
        );
      } else {
        await _dbFirestoreClient.setDocument(
          collectionPath: 'custom_categories',
          merge: false,
          documentId: generUUID,
          data: categoryWithId.toJson(),
        );
      }

      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> updateCustomCategory(
    CustomCategory customCategory,
  ) async {
    try {
      final updatedCategory = customCategory.copyWith(
        updatedAt: DateTime.now(),
      );

      if (!isUserLoggedIn) {
        await _dbHiveClient.update<CustomCategoryHive>(
          boxName: 'custom_categories',
          modelId: customCategory.uuid!,
          modelHive: updatedCategory.toHiveModel(),
        );
      } else {
        await _dbFirestoreClient.updateDocument(
          collectionPath: 'custom_categories/${customCategory.uuid}',
          data: updatedCategory.toJson(),
        );
      }

      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> deleteCustomCategory(String categoryId) async {
    try {
      if (!isUserLoggedIn) {
        await _dbHiveClient.delete<CustomCategoryHive>(
          boxName: 'custom_categories',
          modelId: categoryId,
        );
      } else {
        await _dbFirestoreClient.deleteDocument(
          collectionPath: 'custom_categories/$categoryId',
        );
      }

      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<CustomCategory?>> getCustomCategoryById(
    String categoryId,
  ) async {
    try {
      if (!isUserLoggedIn) {
        final hiveCategory = await _dbHiveClient.getById<CustomCategoryHive>(
          boxName: 'custom_categories',
          modelId: categoryId,
        );

        return AppResult.success(CustomCategory.fromHiveModel(hiveCategory));
      } else {
        final category = await _dbFirestoreClient.getDocument<CustomCategory>(
          collectionPath: 'custom_categories',
          documentId: categoryId,
          objectMapper:
              (data, documentId) =>
                  CustomCategory.fromJson(data as Map<String, dynamic>),
        );

        return AppResult.success(category);
      }
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> initializeDefaultCategories() async {
    try {
      // Kiểm tra xem đã có categories mặc định chưa
      final existingCategories = await getAllCustomCategories();

      bool hasExistingCategories = false;
      existingCategories.when(
        success: (categories) {
          if (categories.isNotEmpty) {
            hasExistingCategories = true;
          }
        },
        failure: (message) {
          // Continue to initialize default categories
        },
      );

      if (hasExistingCategories) {
        // Đã có categories, không cần khởi tạo lại
        return const AppResult.success(null);
      }

      // Tạo categories mặc định từ enum Categorys
      for (final category in Categorys.values) {
        final customCategory = CustomCategoryExtension.fromDefaultCategory(
          name: category.name,
          icon: category.icon,
          color: category.backgroundIcon,
          userId: _authUser.currentUser?.uid,
        );

        await addCustomCategory(customCategory);
      }

      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }
}
