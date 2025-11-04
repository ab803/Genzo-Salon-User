import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/Feature/Auth/Manager/auth_cubit.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class DrawerActionList extends StatelessWidget {
  final bool isDark;
  final double Function(BuildContext, double) responsiveFontSize;

  const DrawerActionList({
    super.key,
    required this.isDark,
    required this.responsiveFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.info_outline,
            color: isDark ? AppColors.darkText : AppColors.primaryNavy,
          ),
          title: Text(
            'aboutUs'.getString(context),
            style: AppTextStyles.body(
              isDark ? AppColors.darkText : AppColors.lightText,
            ).copyWith(fontSize: responsiveFontSize(context, 14)),
          ),
          onTap: () {
            // TODO: Add About dialog or page
          },
        ),
        // to  Logout from account
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: Text(
            'logout'.getString(context),
            style: AppTextStyles.body(Colors.red)
                .copyWith(fontSize: responsiveFontSize(context, 14)),
          ),
          onTap: () async {
            await context.read<AuthCubit>().signOut();
            context.go('/signIn');
          },
        ),
      ],
    );
  }
}
