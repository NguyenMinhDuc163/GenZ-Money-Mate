import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../service/currency_service.dart';

import '../../features/blocs/transaction_bloc/transaction_cubit.dart';
import '../../features/blocs/custom_category_bloc/custom_category_cubit.dart';
import '../../features/blocs/category_group_bloc/category_group_cubit.dart';
import '../enum/enum.dart';
import '../extension/extension.dart';
import '../models/transaction_model.dart';
import '../models/custom_category_model.dart';
import '../models/category_group_model.dart';
import '../router/app_route.dart';
import '../router/router.dart';
import '../styles/app_text_style.dart';
import '../utils/alerts/alerts.dart';
import 'custom_item_button.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({
    Key? key,
    required this.allTransactions,
    this.isViewOnly = false,
  }) : super(key: key);

  final List<Transaction> allTransactions;
  final bool isViewOnly;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  // Map để theo dõi trạng thái mở/đóng của các nhóm
  final Map<String, bool> _expandedGroups = {};

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          widget.allTransactions.isEmpty
              ? Center(
                child: Text(
                  'home.no_transactions'.tr(),
                  style: AppTextStyle.subtitle.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
              )
              : BlocConsumer<CategoryGroupCubit, CategoryGroupState>(
                listener: (context, state) {
                  print('CategoryGroupCubit state changed: $state');
                },
                builder: (context, groupState) {
                  print('CategoryGroupCubit builder called: $groupState');
                  final categoryGroups = groupState.maybeWhen(
                    loaded: (groups) {
                      print('Loaded ${groups.length} category groups');
                      return groups;
                    },
                    orElse: () {
                      print('CategoryGroupCubit state: $groupState');
                      return <CategoryGroup>[];
                    },
                  );

                  return BlocBuilder<CustomCategoryCubit, CustomCategoryState>(
                    builder: (context, customCategoryState) {
                      final customCategories = customCategoryState.maybeWhen(
                        loaded: (categories) => categories,
                        orElse: () => <CustomCategory>[],
                      );

                      // Nhóm transactions theo groupId
                      final Map<String, List<Transaction>> groupedTransactions =
                          {};

                      for (final transaction in widget.allTransactions) {
                        if (transaction.groupId.isNotEmpty) {
                          // Kiểm tra xem nhóm có tồn tại không
                          final groupExists = categoryGroups.any(
                            (g) => g.uuid == transaction.groupId,
                          );

                          if (groupExists) {
                            // Nhóm tồn tại, thêm vào grouped
                            if (groupedTransactions.containsKey(
                              transaction.groupId,
                            )) {
                              groupedTransactions[transaction.groupId]!.add(
                                transaction,
                              );
                            } else {
                              groupedTransactions[transaction.groupId] = [
                                transaction,
                              ];
                            }
                          }
                          // Nếu nhóm không tồn tại, bỏ qua transaction này (không hiển thị)
                        }
                        // Nếu transaction không có groupId, bỏ qua (không hiển thị)
                      }

                      return ListView(
                        children: [
                          // Hiển thị transactions theo nhóm
                          ...groupedTransactions.entries.map((entry) {
                            final groupId = entry.key;
                            final transactions = entry.value;
                            final group = categoryGroups.firstWhere(
                              (g) => g.uuid == groupId,
                            );

                            return _buildGroupSection(
                              context,
                              group,
                              transactions,
                              customCategories,
                            );
                          }).toList(),

                          // Không hiển thị transactions không có nhóm nữa
                        ],
                      );
                    },
                  );
                },
              ),
    );
  }

  Widget _buildGroupSection(
    BuildContext context,
    CategoryGroup group,
    List<Transaction> transactions,
    List<CustomCategory> customCategories,
  ) {
    final groupId = group.uuid ?? '';
    final isExpanded = _expandedGroups[groupId] ?? false; // Mặc định đóng

    // Debug log
    print(
      'Building group section: ${group.getLocalizedName()}, spendingLimit: ${group.spendingLimit}',
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () => _showDeleteGroupDialog(context, group, transactions),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          key: ValueKey(groupId),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedGroups[groupId] = expanded;
            });
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 8),
          shape: const RoundedRectangleBorder(),
          collapsedShape: const RoundedRectangleBorder(),
          collapsedBackgroundColor: Colors.transparent,
          leading: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: group.color,
              shape: BoxShape.circle,
            ),
            child: Icon(group.icon, size: 14, color: Colors.white),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  group.getLocalizedName(),
                  style: AppTextStyle.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
              if (group.spendingLimit > 0) ...[
                const SizedBox(width: 8),
                _buildSpendingLimitIndicator(context, group, transactions),
              ],
            ],
          ),
          subtitle: Text(
            '${transactions.length} ${'transaction.items'.tr()}',
            style: AppTextStyle.caption.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          trailing: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: context.colorScheme.outline,
          ),
          children: [
            // Danh sách transactions trong nhóm với padding thụt vào
            ...transactions.map((transaction) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 32,
                  right: 16,
                  top: 2,
                  bottom: 2,
                ),
                child: _buildTransactionItem(
                  context,
                  transaction,
                  customCategories,
                  isSmall: true, // Thêm tham số để làm nhỏ transaction
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  CustomItemButton _buildTransactionItem(
    BuildContext context,
    Transaction transaction,
    List<CustomCategory> customCategories, {
    bool isSmall = false,
  }) {
    // Kiểm tra xem có custom category không
    CustomCategory? customCategory;
    Categorys? defaultCategory;

    if (transaction.customCategoryId.isNotEmpty) {
      // Tìm custom category
      customCategory = customCategories.firstWhere(
        (cat) => cat.uuid == transaction.customCategoryId,
        orElse: () => CustomCategory.empty(),
      );
    } else {
      // Sử dụng default category
      defaultCategory = Categorys.fromIndex(transaction.categorysIndex);
    }

    // Xác định thông tin hiển thị
    final displayName =
        customCategory != null
            ? customCategory.name
            : defaultCategory?.getLocalizedName() ??
                'transaction_list.others'.tr();
    final displayIcon =
        customCategory != null
            ? customCategory.icon
            : defaultCategory?.icon ?? FontAwesomeIcons.ellipsis;
    final displayColor =
        customCategory != null
            ? customCategory.color
            : defaultCategory?.backgroundIcon ?? Colors.grey;

    return CustomItemButton(
      text: displayName,
      icon: displayIcon,
      iconColor: Colors.white,
      backgroundItem: context.colorScheme.surface,
      backgroundIcon: displayColor,
      iconSize: isSmall ? 12.0 : null, // Giảm kích thước icon khi isSmall
      onLongPress:
          () =>
              widget.isViewOnly ? null : _showModalSheet(context, transaction),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            transaction.toHiveModel().displayAmount,
            style: (isSmall ? AppTextStyle.caption : AppTextStyle.subtitle)
                .copyWith(
                  color:
                      transaction.category == Category.expense
                          ? Colors.redAccent
                          : Colors.greenAccent,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            transaction.date.formatDynamicDate,
            style: AppTextStyle.caption.copyWith(
              color: context.colorScheme.outline,
              fontWeight: FontWeight.w400,
              fontSize:
                  isSmall ? 10.0 : null, // Giảm kích thước font khi isSmall
            ),
          ),
        ],
      ),
    );
  }

  CurrencyType _getCurrencyTypeFromString(String currencyString) {
    switch (currencyString.toUpperCase()) {
      case 'VND':
        return CurrencyType.vnd;
      case 'CNY':
        return CurrencyType.cny;
      case 'USD':
      default:
        return CurrencyType.usd;
    }
  }

  Widget _buildSpendingLimitIndicator(
    BuildContext context,
    CategoryGroup group,
    List<Transaction> transactions,
  ) {
    // Tính tổng chi tiêu trong nhóm (chỉ tính expense)
    // Cần convert về loại tiền hiện tại để tính toán chính xác
    final locale = Intl.getCurrentLocale();
    final currentCurrencyType = CurrencyService.getCurrencyType(locale);

    double totalSpent = 0.0;
    for (final transaction in transactions) {
      if (transaction.category == Category.expense) {
        // Convert amount về loại tiền hiện tại
        final originalCurrencyType = _getCurrencyTypeFromString(
          transaction.originalCurrency,
        );
        final convertedAmount = CurrencyService.convertCurrency(
          amount: transaction.amount,
          fromCurrency: originalCurrencyType,
          toCurrency: currentCurrencyType,
        );
        totalSpent += convertedAmount;
      }
    }

    // Convert spending limit về loại tiền hiện tại (giả sử spending limit được lưu bằng VND)
    final spendingLimitInCurrentCurrency = CurrencyService.convertCurrency(
      amount: group.spendingLimit,
      fromCurrency: CurrencyType.vnd, // Giả sử spending limit được lưu bằng VND
      toCurrency: currentCurrencyType,
    );

    final remaining = spendingLimitInCurrentCurrency - totalSpent;
    final isOverLimit = remaining < 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            isOverLimit
                ? Colors.red.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverLimit ? Colors.red : Colors.green,
          width: 1,
        ),
      ),
      child: Text(
        '${CurrencyService.formatCurrency(amount: remaining, currencyType: currentCurrencyType, showSymbol: true)}',
        style: AppTextStyle.caption.copyWith(
          color: isOverLimit ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showDeleteGroupDialog(
    BuildContext context,
    CategoryGroup group,
    List<Transaction> transactions,
  ) {
    Alerts.showAlertDialog(
      context: context,
      title: 'category_group.delete_with_transactions_title'.tr(),
      message: 'category_group.delete_with_transactions_confirm'.tr(
        namedArgs: {'count': transactions.length.toString()},
      ),
      onOk: () {
        _deleteGroupAndTransactions(context, group, transactions);
      },
      onCancel: () {},
    );
  }

  void _deleteGroupAndTransactions(
    BuildContext context,
    CategoryGroup group,
    List<Transaction> transactions,
  ) async {
    try {
      print(
        'Deleting group: ${group.getLocalizedName()} with ${transactions.length} transactions',
      );

      // Xóa tất cả transactions trong nhóm trước
      for (final transaction in transactions) {
        print('Deleting transaction: ${transaction.uuid}');
        context.read<TransactionCubit>().deleteTransaction(transaction.uuid!);
      }

      // Sau đó xóa nhóm
      print('Deleting group: ${group.uuid}');
      context.read<CategoryGroupCubit>().deleteCategoryGroup(group.uuid!);

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã xóa nhóm "${group.getLocalizedName()}" và ${transactions.length} giao dịch',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error deleting group: $e');
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi xóa nhóm: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showModalSheet(BuildContext context, Transaction transaction) {
    return Alerts.showSheet(
      context: context,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomItemButton(
                text: 'common.edit'.tr(),
                icon: FontAwesomeIcons.penToSquare,
                iconColor: Colors.white,
                backgroundIcon: Colors.blueAccent,
                backgroundItem: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                onPressed: () => _onPressedEdit(context, transaction),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomItemButton(
                text: 'common.delete'.tr(),
                icon: FontAwesomeIcons.trashCan,
                iconColor: Colors.white,
                backgroundIcon: Colors.redAccent,
                backgroundItem: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                onPressed: () => _onPressedDelete(context, transaction),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressedEdit(BuildContext context, Transaction transaction) {
    context.pop();
    context.read<TransactionCubit>().isEditing = true;
    context.read<TransactionCubit>().transaction = transaction;
    context
        .read<TransactionCubit>()
        .init(); // Gọi init() sau khi set transaction
    context.pushNamed(RoutesName.transaction);
  }

  void _onPressedDelete(BuildContext context, Transaction transaction) {
    context.pop();
    Alerts.showAlertDialog(
      context: context,
      title: 'transaction.delete_title'.tr(),
      message: 'transaction.delete_confirm'.tr(),
      onOk: () {
        debugPrint('transaction.uuid: ${transaction.uuid}');
        context.read<TransactionCubit>().deleteTransaction(transaction.uuid!);
      },
      onCancel: () => {},
    );
  }
}
