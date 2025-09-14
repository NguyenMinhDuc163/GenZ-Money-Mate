import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/enum/enum.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/router/router.dart';
import '../../../../core/shared/shared.dart';
import '../../../blocs/main_bloc/main_cubit.dart';
import 'widgets.dart';

class HeaderAppBarProfile extends StatelessWidget {
  const HeaderAppBarProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ProfileIcon(),
        Row(
          children: [
            CustomIconBottom(
              icon: FontAwesomeIcons.trophy,
              onPressed: () => context.pushNamed(RoutesName.ranking),
            ),
            const SizedBox(width: 10),
            CustomIconBottom(
              icon: FontAwesomeIcons.rotateLeft,
              onPressed: () {
                context.read<MainCubit>().getAll(TypeShow.limit).then((_) {
                  context.read<MainCubit>().getTotals();
                });
              },
            ),
            const SizedBox(width: 10),
            CustomIconBottom(
              icon: FontAwesomeIcons.gear,
              onPressed: () => context.pushNamed(RoutesName.settings),
            ),
          ],
        ),
      ],
    );
  }
}
