import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../../core/enum/enum.dart';
import '../../../../core/extension/extension.dart';
import '../../../../core/models/transaction_model.dart';
import '../../../../core/models/custom_category_model.dart';
import '../../../../core/models/category_group_model.dart';
import '../../../../core/service/currency_service.dart';
import '../../transaction/data/repository/transaction_base_repository.dart';

part 'transaction_cubit.freezed.dart';
part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionBaseRepository _transactionRepository;

  TransactionCubit({required TransactionBaseRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(const TransactionState.initial());

  Transaction _transaction = Transaction.empty();
  set transaction(Transaction value) => _transaction = value;

  bool _isEditing = false;
  set isEditing(bool value) => _isEditing = value;

  final TextEditingController _amountController = TextEditingController();
  TextEditingController get amountController => _amountController;

  // Thêm biến để lưu custom category được chọn
  CustomCategory? _selectedCustomCategory;

  // Thêm biến để lưu category group được chọn
  CategoryGroup? _selectedCategoryGroup;

  void init() {
    if (_isEditing) {
      _amountController.text = _transaction.amount.toCurrencyString();
      // Custom category và group sẽ được load từ UI khi đã sẵn sàng
      _selectedCustomCategory = null;
      _selectedCategoryGroup = null;
    } else {
      _amountController.clear();
      _transaction = Transaction.empty();
      _selectedCustomCategory = null;
      _selectedCategoryGroup = null;
    }
    emit(_buildState());
  }

  void onCategorysChanged(Categorys categorys) {
    _transaction = _transaction.copyWith(
      categorysIndex: categorys.index,
      customCategoryId: '', // Reset custom category khi chọn default category
    );
    _selectedCustomCategory = null;
    emit(_buildState());
  }

  void onCustomCategoryChanged(CustomCategory customCategory) {
    _selectedCustomCategory = customCategory;
    _transaction = _transaction.copyWith(
      categorysIndex: -1, // Đánh dấu là custom category
      customCategoryId: customCategory.uuid!,
      groupId: customCategory.groupId, // Lưu groupId từ custom category
    );
    emit(_buildState());
  }

  void onCategoryGroupChanged(CategoryGroup categoryGroup) {
    _selectedCategoryGroup = categoryGroup;
    _transaction = _transaction.copyWith(groupId: categoryGroup.uuid!);
    emit(_buildState());
  }

  /// Load custom category khi edit transaction
  void loadCustomCategoryForEditing(List<CustomCategory> customCategories) {
    debugPrint('loadCustomCategoryForEditing called');
    debugPrint('_isEditing: $_isEditing');
    debugPrint(
      '_transaction.customCategoryId: ${_transaction.customCategoryId}',
    );
    debugPrint('customCategories.length: ${customCategories.length}');

    if (_isEditing && _transaction.customCategoryId.isNotEmpty) {
      try {
        _selectedCustomCategory = customCategories.firstWhere(
          (cat) => cat.uuid == _transaction.customCategoryId,
        );
        debugPrint('Found custom category: ${_selectedCustomCategory?.name}');
        emit(_buildState());
      } catch (e) {
        // Nếu không tìm thấy custom category, set null
        debugPrint('Custom category not found: $e');
        _selectedCustomCategory = null;
        emit(_buildState());
      }
    }
  }

  void onTransactionCategoryChanged(Category category) {
    _transaction = _transaction.copyWith(category: category);
    emit(_buildState());
  }

  void onTransactionDateChanged(DateTime date) {
    _transaction = _transaction.copyWith(date: date);
    emit(_buildState());
  }

  void addOrUpdateTransaction() {
    debugPrint(_transaction.toString());

    emit(const TransactionState.loading());

    final amount =
        _amountController.text.isNotEmpty
            ? _amountController.text.toUnFormattedString().toDouble()
            : null;

    // Lấy loại tiền hiện tại dựa trên locale
    final currentLocale = Intl.getCurrentLocale();
    final currentCurrencyType = CurrencyService.getCurrencyType(currentLocale);
    final currentCurrencyString = CurrencyService.getCurrencyName(
      currentCurrencyType,
    );

    final transactionUpdated = _transaction.copyWith(
      amount: amount ?? 0.0,
      originalCurrency: currentCurrencyString, // Lưu loại tiền gốc
      customCategoryId:
          _selectedCustomCategory?.uuid ?? '', // Lưu custom category ID
      groupId:
          _selectedCategoryGroup?.uuid ??
          _selectedCustomCategory?.groupId ??
          '', // Lưu group ID
    );

    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      try {
        if (_isEditing) {
          _transactionRepository.updateTransaction(transactionUpdated);
          emit(const TransactionState.success('transaction.updated_success'));
        } else {
          _transactionRepository.addTransaction(transactionUpdated);
          emit(const TransactionState.success('transaction.added_success'));
        }
      } catch (error) {
        debugPrint('error: $error');
        emit(TransactionState.error(error.toString()));
      }
    });
  }

  void deleteTransaction(String transactionId) async {
    emit(const TransactionState.loading());

    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      try {
        _transactionRepository.deleteTransaction(transactionId);
        emit(const TransactionState.success('transaction.deleted_success'));
      } catch (error) {
        debugPrint('error: $error');
        emit(TransactionState.error(error.toString()));
      }
    });
  }

  TransactionState _buildState() {
    debugPrint('_buildState called');
    debugPrint('_selectedCustomCategory: ${_selectedCustomCategory?.name}');
    debugPrint(
      '_selectedCategoryGroup: ${_selectedCategoryGroup?.getLocalizedName()}',
    );
    debugPrint(
      '_transaction.customCategoryId: ${_transaction.customCategoryId}',
    );
    debugPrint('_transaction.groupId: ${_transaction.groupId}');
    debugPrint('_transaction.categorysIndex: ${_transaction.categorysIndex}');

    return TransactionState.loadTransaction(
      categorys:
          _selectedCustomCategory != null
              ? null // Không sử dụng default category khi có custom category
              : Categorys.fromIndex(_transaction.categorysIndex),
      customCategory: _selectedCustomCategory,
      categoryGroup: _selectedCategoryGroup,
      transactionCategory: _transaction.category,
      transactionDate: _transaction.date,
    );
  }

  @override
  Future<void> close() {
    _isEditing = false;
    _amountController.dispose();
    return super.close();
  }
}
