import 'dart:async';

import 'package:auth_user/auth_user.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:db_hive_client/db_hive_client.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helper/helper.dart';
import '../../../../core/models/category_group_hive_model.dart';
import '../../../../core/models/category_group_model.dart';
import '../../../../core/utils/models/app_result.dart';
import 'category_group_base_repository.dart';

class CategoryGroupRepository implements CategoryGroupBaseRepository {
  final DbFirestoreClientBase _dbFirestoreClient;
  final DbHiveClientBase _dbHiveClient;
  final AuthUserBase _authUser;

  CategoryGroupRepository({
    required DbFirestoreClientBase dbFirestoreClient,
    required AuthUserBase authUser,
    required DbHiveClientBase dbHiveClient,
  }) : _dbFirestoreClient = dbFirestoreClient,
       _dbHiveClient = dbHiveClient,
       _authUser = authUser;

  /// The [isUserLoggedIn] method is used to check if the user is logged in.
  bool get isUserLoggedIn => _authUser.currentUser != null;

  @override
  Future<AppResult<List<CategoryGroup>>> getAllCategoryGroups() async {
    try {
      if (!isUserLoggedIn) {
        // Lấy từ Hive local storage
        final hiveGroups = await _dbHiveClient.getAll<CategoryGroupHive>(
          boxName: 'category_groups',
        );

        final groups = hiveGroups.map(CategoryGroup.fromHiveModel).toList();

        return AppResult.success(groups);
      } else {
        // Lấy từ Firestore
        final result = await _dbFirestoreClient.getQuery<CategoryGroup>(
          collectionPath: 'category_groups',
          field: 'userId',
          isEqualTo: _authUser.currentUser!.uid,
          mapper:
              (data, documentId) =>
                  CategoryGroup.fromJson(data as Map<String, dynamic>),
        );

        return AppResult.success(result);
      }
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> addCategoryGroup(CategoryGroup categoryGroup) async {
    try {
      // Debug log
      print(
        'CategoryGroupRepository: Adding group with spending limit: ${categoryGroup.spendingLimit}',
      );

      final generUUID = Helper.generateUUID();
      final groupWithId = categoryGroup.copyWith(
        uuid: generUUID,
        userId: _authUser.currentUser?.uid,
      );

      // Debug log
      print('CategoryGroupRepository: Group with ID: $groupWithId');

      if (!isUserLoggedIn) {
        await _dbHiveClient.add<CategoryGroupHive>(
          boxName: 'category_groups',
          modelId: generUUID,
          modelHive: groupWithId.toHiveModel(),
        );
      } else {
        await _dbFirestoreClient.setDocument(
          collectionPath: 'category_groups',
          merge: false,
          documentId: generUUID,
          data: groupWithId.toJson(),
        );
      }

      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> updateCategoryGroup(
    CategoryGroup categoryGroup,
  ) async {
    try {
      final updatedGroup = categoryGroup.copyWith(updatedAt: DateTime.now());

      if (!isUserLoggedIn) {
        await _dbHiveClient.update<CategoryGroupHive>(
          boxName: 'category_groups',
          modelId: categoryGroup.uuid!,
          modelHive: updatedGroup.toHiveModel(),
        );
      } else {
        await _dbFirestoreClient.updateDocument(
          collectionPath: 'category_groups/${categoryGroup.uuid}',
          data: updatedGroup.toJson(),
        );
      }

      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> deleteCategoryGroup(String groupId) async {
    try {
      if (!isUserLoggedIn) {
        await _dbHiveClient.delete<CategoryGroupHive>(
          boxName: 'category_groups',
          modelId: groupId,
        );
      } else {
        await _dbFirestoreClient.deleteDocument(
          collectionPath: 'category_groups/$groupId',
        );
      }

      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<CategoryGroup?>> getCategoryGroupById(String groupId) async {
    try {
      if (!isUserLoggedIn) {
        final hiveGroup = await _dbHiveClient.getById<CategoryGroupHive>(
          boxName: 'category_groups',
          modelId: groupId,
        );

        return AppResult.success(CategoryGroup.fromHiveModel(hiveGroup));
      } else {
        final group = await _dbFirestoreClient.getDocument<CategoryGroup>(
          collectionPath: 'category_groups',
          documentId: groupId,
          objectMapper:
              (data, documentId) =>
                  CategoryGroup.fromJson(data as Map<String, dynamic>),
        );

        return AppResult.success(group);
      }
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> initializeDefaultGroups() async {
    try {
      // Kiểm tra xem đã có groups mặc định chưa
      final existingGroups = await getAllCategoryGroups();

      bool hasExistingGroups = false;
      existingGroups.when(
        success: (groups) {
          if (groups.isNotEmpty) {
            hasExistingGroups = true;
          }
        },
        failure: (message) {
          // Continue to initialize default groups
        },
      );

      if (hasExistingGroups) {
        // Đã có groups, không cần khởi tạo lại
        return const AppResult.success(null);
      }

      // Tạo groups mặc định
      final defaultGroups = [
        CategoryGroup.createDefault(
          name: 'default_groups.shopping',
          icon: FontAwesomeIcons.cartShopping,
          color: Colors.blue,
          userId: _authUser.currentUser?.uid,
        ),
        CategoryGroup.createDefault(
          name: 'default_groups.food',
          icon: FontAwesomeIcons.utensils,
          color: Colors.orange,
          userId: _authUser.currentUser?.uid,
        ),
        CategoryGroup.createDefault(
          name: 'default_groups.entertainment',
          icon: FontAwesomeIcons.film,
          color: Colors.purple,
          userId: _authUser.currentUser?.uid,
        ),
        CategoryGroup.createDefault(
          name: 'default_groups.transport',
          icon: FontAwesomeIcons.car,
          color: Colors.green,
          userId: _authUser.currentUser?.uid,
        ),
        CategoryGroup.createDefault(
          name: 'default_groups.health',
          icon: FontAwesomeIcons.heartPulse,
          color: Colors.red,
          userId: _authUser.currentUser?.uid,
        ),
        CategoryGroup.createDefault(
          name: 'default_groups.education',
          icon: FontAwesomeIcons.graduationCap,
          color: Colors.indigo,
          userId: _authUser.currentUser?.uid,
        ),
        CategoryGroup.createDefault(
          name: 'default_groups.others',
          icon: FontAwesomeIcons.ellipsis,
          color: Colors.grey,
          userId: _authUser.currentUser?.uid,
        ),
      ];

      for (final group in defaultGroups) {
        await addCategoryGroup(group);
      }

      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }
}
