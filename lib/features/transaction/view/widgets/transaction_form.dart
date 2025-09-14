import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/enum/enum.dart';
import '../../../../core/extension/extension.dart';
import '../../../../core/models/custom_category_model.dart';
import '../../../../core/router/router.dart';
import '../../../../core/shared/shared.dart';
import '../../../../core/utils/alerts/alerts.dart';
import '../../../blocs/transaction_bloc/transaction_cubit.dart';
import '../../../blocs/custom_category_bloc/custom_category_cubit.dart';
import 'create_custom_category_dialog.dart';
import 'custom_category_item.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  @override
  void initState() {
    context.read<TransactionCubit>().init();

    // Load custom categories và load custom category cho editing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomCategoryCubit>().getAllCustomCategories();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = 16.0;
    const iconItemHeight = 35.0;

    // Lắng nghe khi custom categories được load để load custom category cho editing
    return BlocListener<CustomCategoryCubit, CustomCategoryState>(
      listener: (context, state) {
        debugPrint('CustomCategoryCubit state changed: $state');
        state.maybeWhen(
          loaded: (customCategories) {
            // Load custom category cho transaction đang edit
            debugPrint('Custom categories loaded: ${customCategories.length}');
            context.read<TransactionCubit>().loadCustomCategoryForEditing(
              customCategories,
            );
          },
          orElse: () {
            debugPrint('CustomCategoryCubit state: $state');
          },
        );
      },
      child: _buildForm(context, iconSize, iconItemHeight),
    );
  }

  Widget _buildForm(
    BuildContext context,
    double iconSize,
    double iconItemHeight,
  ) {
    const iconItemWidth = 35.0;
    const padding = EdgeInsets.symmetric(horizontal: 12, vertical: 15);
    final backgroundItem = context.colorScheme.surface;

    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (previous, current) => current is LoadTransaction,
      builder: (context, state) {
        final categorys = state.mapOrNull(
          loadTransaction: (state) => state.categorys,
        );

        final customCategory = state.mapOrNull(
          loadTransaction: (state) => state.customCategory,
        );

        final transactionCategory = state.mapOrNull(
          loadTransaction: (state) => state.transactionCategory,
        );

        final transactionDate = state.mapOrNull(
          loadTransaction: (state) => state.transactionDate,
        );

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildMoneyTextFeild(context),
            const SizedBox(height: 20),
            Column(
              children: [
                CustomItemButton(
                  text:
                      customCategory != null
                          ? customCategory.name
                          : categorys?.getLocalizedName() ??
                              'transaction.select_category'.tr(),
                  padding: padding,
                  iconSize: iconSize,
                  iconColor: Colors.white,
                  iconItemWidth: iconItemWidth,
                  iconItemHeight: iconItemHeight,
                  backgroundIcon:
                      customCategory?.color ??
                      categorys?.backgroundIcon ??
                      Colors.grey,
                  backgroundItem: backgroundItem,
                  icon:
                      customCategory?.icon ??
                      categorys?.icon ??
                      FontAwesomeIcons.ellipsis,
                  onPressed: () => _showModalSheetCategory(context),
                ),
                CustomItemButton(
                  text: transactionCategory!.getLocalizedName(),
                  padding: padding,
                  iconSize: iconSize,
                  iconColor: Colors.white,
                  iconItemWidth: iconItemWidth,
                  iconItemHeight: iconItemHeight,
                  backgroundIcon: transactionCategory.backgroundIcon,
                  backgroundItem: backgroundItem,
                  icon: transactionCategory.icon,
                  onPressed: () => _showModalSheetTransactionCategory(context),
                ),
                CustomItemButton(
                  text: transactionDate!.formattedDateOnly,
                  padding: padding,
                  iconSize: iconSize,
                  iconColor: context.colorScheme.surface,
                  iconItemWidth: iconItemWidth,
                  iconItemHeight: iconItemHeight,
                  backgroundIcon: context.colorScheme.outline,
                  backgroundItem: backgroundItem,
                  icon: FontAwesomeIcons.calendarDay,
                  onPressed: () => _showPickeDate(context, transactionDate),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _buildMoneyTextFeild(BuildContext context) {
    return Container(
      height: 70,
      width: context.screenWidth(0.65),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: context.colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 18),
          // const Text('\$', style: AppTextStyle.title2),
          Flexible(
            child: CustomTextFormField(
              fontSize: 30,
              maxLines: 1,
              hintText: 'transaction.amount_hint'.tr(),
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w800,
              keyboardType: TextInputType.number,
              contentPadding: const EdgeInsets.only(right: 15, left: 0),
              controller: context.read<TransactionCubit>().amountController,
              prefixText:
                  NumberFormat.compactSimpleCurrency(
                    locale: Intl.getCurrentLocale(),
                  ).currencySymbol,
            ),
          ),
        ],
      ),
    );
  }

  void _showModalSheetCategory(BuildContext context) {
    // Load custom categories khi mở modal
    context.read<CustomCategoryCubit>().getAllCustomCategories();

    Alerts.showSheet(
      context: context,
      child: BlocConsumer<CustomCategoryCubit, CustomCategoryState>(
        listener: (context, state) {
          state.maybeWhen(
            success: (message) {
              Alerts.showToastMsg(context, message.tr());
            },
            error: (message) {
              Alerts.showToastMsg(context, message);
            },
            orElse: () {},
          );
        },
        builder: (context, customCategoryState) {
          final customCategories = customCategoryState.maybeWhen(
            loaded: (categories) => categories,
            orElse: () => <CustomCategory>[],
          );

          return Expanded(
            child: Column(
              children: [
                // Header với nút tạo category mới
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'transaction.select_category'.tr(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: () async {
                          context.pop();
                          await showDialog(
                            context: context,
                            builder:
                                (context) => const CreateCustomCategoryDialog(),
                          );
                        },
                        icon: const Icon(Icons.add),
                        tooltip: 'custom_category.create_new'.tr(),
                      ),
                    ],
                  ),
                ),

                // Danh sách categories
                Expanded(
                  child: ListView(
                    children: [
                      // Custom Categories
                      if (customCategories.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            'custom_category.my_categories'.tr(),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...customCategories.map((customCategory) {
                          return CustomCategoryItem(
                            customCategory: customCategory,
                            onTap: () {
                              context
                                  .read<TransactionCubit>()
                                  .onCustomCategoryChanged(customCategory);
                              context.pop();
                            },
                          );
                        }).toList(),

                        const Divider(),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            'custom_category.default_categories'.tr(),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],

                      // Default Categories
                      ...categorys.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CustomItemButton(
                            text: category.getLocalizedName(),
                            icon: category.icon,
                            iconColor: Colors.white,
                            backgroundItem: Colors.transparent,
                            backgroundIcon: category.backgroundIcon,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            onPressed: () {
                              context
                                  .read<TransactionCubit>()
                                  .onCategorysChanged(category);
                              context.pop();
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showModalSheetTransactionCategory(BuildContext context) {
    Alerts.showSheet(
      context: context,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Column(
          children:
              Category.values.map((transactionCategory) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: CustomItemButton(
                    text: transactionCategory.getLocalizedName(),
                    iconColor: Colors.white,
                    icon: transactionCategory.icon,
                    backgroundIcon: transactionCategory.backgroundIcon,
                    backgroundItem: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    onPressed: () {
                      context
                          .read<TransactionCubit>()
                          .onTransactionCategoryChanged(transactionCategory);

                      context.pop();
                    },
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Future<DateTime?> _showPickeDate(BuildContext context, DateTime initialDate) {
    return Alerts.showPickeTransactionDate(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      onDateSelected: (DateTime dateTime) {
        context.read<TransactionCubit>().onTransactionDateChanged(dateTime);
      },
    );
  }
}
