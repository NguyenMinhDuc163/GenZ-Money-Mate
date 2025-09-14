import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/shared/shared.dart';
import '../../../../core/utils/alerts/alerts.dart';
import '../../../blocs/category_group_bloc/category_group_cubit.dart';

class CreateCategoryGroupDialog extends StatefulWidget {
  const CreateCategoryGroupDialog({super.key});

  @override
  State<CreateCategoryGroupDialog> createState() =>
      _CreateCategoryGroupDialogState();
}

class _CreateCategoryGroupDialogState extends State<CreateCategoryGroupDialog> {
  final TextEditingController _nameController = TextEditingController();
  IconData _selectedIcon = FontAwesomeIcons.folder;
  Color _selectedColor = Colors.blue;

  // Danh sách các icon phổ biến cho groups
  final List<IconData> _availableIcons = [
    FontAwesomeIcons.folder,
    FontAwesomeIcons.cartShopping,
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.film,
    FontAwesomeIcons.car,
    FontAwesomeIcons.heartPulse,
    FontAwesomeIcons.graduationCap,
    FontAwesomeIcons.house,
    FontAwesomeIcons.briefcase,
    FontAwesomeIcons.plane,
    FontAwesomeIcons.gamepad,
    FontAwesomeIcons.music,
    FontAwesomeIcons.book,
    FontAwesomeIcons.dumbbell,
    FontAwesomeIcons.palette,
    FontAwesomeIcons.camera,
    FontAwesomeIcons.gift,
    FontAwesomeIcons.users,
    FontAwesomeIcons.calendarDays,
    FontAwesomeIcons.chartPie,
    FontAwesomeIcons.creditCard,
    FontAwesomeIcons.bolt,
    FontAwesomeIcons.receipt,
    FontAwesomeIcons.rightLeft,
    FontAwesomeIcons.moneyBill1,
    FontAwesomeIcons.shirt,
    FontAwesomeIcons.faceSmile,
    FontAwesomeIcons.baby,
    FontAwesomeIcons.seedling,
    FontAwesomeIcons.ellipsis,
  ];

  // Danh sách các màu sắc
  final List<Color> _availableColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.cyan,
    Colors.teal,
    Colors.pink,
    Colors.brown,
    Colors.indigo,
    Colors.amber,
    Colors.deepPurple,
    Colors.lightGreen,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.blueGrey,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.yellowAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.cyanAccent,
    Colors.tealAccent,
    Colors.pinkAccent,
    Colors.brown,
    Colors.indigoAccent,
    Colors.amberAccent,
    Colors.deepPurpleAccent,
    Colors.lightGreenAccent,
    Colors.deepOrangeAccent,
    Colors.lightBlueAccent,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryGroupCubit, CategoryGroupState>(
      listener: (context, state) {
        state.maybeWhen(
          loading: () => Alerts.showLoaderDialog(context),
          success: (message) {
            Alerts.hideLoaderDialog(context);
            Alerts.showToastMsg(context, message.tr());
            Navigator.of(context).pop();
          },
          error: (message) {
            Alerts.hideLoaderDialog(context);
            Alerts.showToastMsg(context, message);
          },
          orElse: () {},
        );
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'category_group.create_new'.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Tên group
              CustomTextFormField(
                controller: _nameController,
                hintText: 'category_group.name_hint'.tr(),
                fontSize: 16,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.normal,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),

              // Chọn icon
              Text(
                'category_group.select_icon'.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Container(
                height: 100,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _availableIcons.length,
                  itemBuilder: (context, index) {
                    final icon = _availableIcons[index];
                    final isSelected = icon == _selectedIcon;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = icon;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? _selectedColor : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border:
                              isSelected
                                  ? Border.all(color: _selectedColor, width: 2)
                                  : null,
                        ),
                        child: Icon(
                          icon,
                          color: isSelected ? Colors.white : Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Chọn màu
              Text(
                'category_group.select_color'.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Container(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableColors.length,
                  itemBuilder: (context, index) {
                    final color = _availableColors[index];
                    final isSelected = color == _selectedColor;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border:
                              isSelected
                                  ? Border.all(color: Colors.black, width: 3)
                                  : null,
                        ),
                        child:
                            isSelected
                                ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
                                : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                      child: Text('common.cancel'.tr()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _createGroup,
                      child: Text('common.create'.tr()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createGroup() {
    if (_nameController.text.trim().isEmpty) {
      Alerts.showToastMsg(context, 'category_group.name_required'.tr());
      return;
    }

    context.read<CategoryGroupCubit>().addCategoryGroup(
      name: _nameController.text.trim(),
      icon: _selectedIcon,
      color: _selectedColor,
    );
  }
}
