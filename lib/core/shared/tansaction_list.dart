import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              : BlocBuilder<CategoryGroupCubit, CategoryGroupState>(
                builder: (context, groupState) {
                  final categoryGroups = groupState.maybeWhen(
                    loaded: (groups) => groups,
                    orElse: () => <CategoryGroup>[],
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
                      final List<Transaction> ungroupedTransactions = [];

                      for (final transaction in widget.allTransactions) {
                        if (transaction.groupId.isNotEmpty) {
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
                        } else {
                          ungroupedTransactions.add(transaction);
                        }
                      }

                      return ListView(
                        children: [
                          // Hiển thị transactions theo nhóm
                          ...groupedTransactions.entries.map((entry) {
                            final groupId = entry.key;
                            final transactions = entry.value;
                            final group = categoryGroups.firstWhere(
                              (g) => g.uuid == groupId,
                              orElse: () => CategoryGroup.empty(),
                            );

                            return _buildGroupSection(
                              context,
                              group,
                              transactions,
                              customCategories,
                            );
                          }).toList(),

                          // Hiển thị transactions không có nhóm
                          if (ungroupedTransactions.isNotEmpty)
                            _buildUngroupedSection(
                              context,
                              ungroupedTransactions,
                              customCategories,
                            ),
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
    final isExpanded = _expandedGroups[groupId] ?? true; // Mặc định mở

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
          title: Text(
            group.name,
            style: AppTextStyle.subtitle.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
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

  Widget _buildUngroupedSection(
    BuildContext context,
    List<Transaction> transactions,
    List<CustomCategory> customCategories,
  ) {
    const ungroupedId = 'ungrouped';
    final isExpanded = _expandedGroups[ungroupedId] ?? true; // Mặc định mở

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () => _showDeleteUngroupedDialog(context, transactions),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          key: const ValueKey(ungroupedId),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedGroups[ungroupedId] = expanded;
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
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FontAwesomeIcons.ellipsis,
              size: 14,
              color: Colors.white,
            ),
          ),
          title: Text(
            'transaction.ungrouped'.tr(),
            style: AppTextStyle.subtitle.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
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
            // Danh sách transactions không có nhóm với padding thụt vào
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
            : defaultCategory?.getLocalizedName() ?? 'Khác';
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

  void _showDeleteUngroupedDialog(
    BuildContext context,
    List<Transaction> transactions,
  ) {
    Alerts.showAlertDialog(
      context: context,
      title: 'Xóa tất cả giao dịch không có nhóm',
      message:
          'Bạn có chắc chắn muốn xóa tất cả ${transactions.length} giao dịch không có nhóm? Hành động này không thể hoàn tác.',
      onOk: () {
        _deleteUngroupedTransactions(context, transactions);
      },
      onCancel: () {},
    );
  }

  void _deleteUngroupedTransactions(
    BuildContext context,
    List<Transaction> transactions,
  ) async {
    try {
      // Xóa tất cả transactions không có nhóm
      for (final transaction in transactions) {
        context.read<TransactionCubit>().deleteTransaction(transaction.uuid!);
      }

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã xóa ${transactions.length} giao dịch không có nhóm',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi xóa giao dịch: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteGroupDialog(
    BuildContext context,
    CategoryGroup group,
    List<Transaction> transactions,
  ) {
    Alerts.showAlertDialog(
      context: context,
      title: 'Xóa nhóm "${group.name}"',
      message:
          'Bạn có chắc chắn muốn xóa nhóm này và tất cả ${transactions.length} giao dịch bên trong? Hành động này không thể hoàn tác.',
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
      // Xóa tất cả transactions trong nhóm
      for (final transaction in transactions) {
        context.read<TransactionCubit>().deleteTransaction(transaction.uuid!);
      }

      // Xóa nhóm
      context.read<CategoryGroupCubit>().deleteCategoryGroup(group.uuid!);

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã xóa nhóm "${group.name}" và ${transactions.length} giao dịch',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
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
      message: 'Are you sure you want to delete this transaction?',
      onOk: () {
        debugPrint('transaction.uuid: ${transaction.uuid}');
        context.read<TransactionCubit>().deleteTransaction(transaction.uuid!);
      },
      onCancel: () => {},
    );
  }
}
