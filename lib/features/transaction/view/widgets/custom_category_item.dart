import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/custom_category_model.dart';
import '../../../blocs/custom_category_bloc/custom_category_cubit.dart';

class CustomCategoryItem extends StatelessWidget {
  final CustomCategory customCategory;
  final VoidCallback onTap;
  final bool isSelected;

  const CustomCategoryItem({
    super.key,
    required this.customCategory,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showDeleteConfirmation(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? customCategory.color.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border:
              isSelected
                  ? Border.all(color: customCategory.color, width: 2)
                  : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: customCategory.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(customCategory.icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                customCategory.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: customCategory.color, size: 20),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('custom_category.delete_confirm_title'.tr()),
            content: Text('custom_category.delete_confirm'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('custom_category.cancel'.tr()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteCategory(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('custom_category.delete'.tr()),
              ),
            ],
          ),
    );
  }

  void _deleteCategory(BuildContext context) {
    context.read<CustomCategoryCubit>().deleteCustomCategory(
      customCategory.uuid!,
    );
  }
}
