import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/Feature/Auth/Manager/auth_cubit.dart';
import 'package:userbarber/Feature/Auth/Manager/auth_state.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class UserInfoHeader extends StatelessWidget {
  // A function used to make text sizes responsive based on screen dimensions
  final double Function(BuildContext, double) responsiveFontSize;

  const UserInfoHeader({
    super.key,
    required this.responsiveFontSize,
  });

  @override
  Widget build(BuildContext context) {
    // Detect if the current app theme is dark mode
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use BlocBuilder to rebuild the widget when AuthCubit state changes
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // ✅ Case 1: User is authenticated
        if (state is AuthAuthenticated) {
          final user = state.user;

          return Row(
            children: [
              // Display a circular avatar with the user's first letter
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.accentyellow,
                child: Text(
                  // Show the first letter of the user's first name in uppercase
                  user.firstName[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: responsiveFontSize(context, 22),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Display user's full name and email beside the avatar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User's full name
                    Text(
                      "${user.firstName} ${user.lastName}",
                      style: AppTextStyles.subheading(
                        isDark ? AppColors.darkText : AppColors.lightText,
                      ).copyWith(fontSize: responsiveFontSize(context, 18)),
                    ),
                    // User's email address
                    Text(
                      user.email,
                      style: AppTextStyles.body(
                        isDark ? AppColors.darkText : AppColors.lightText,
                      ).copyWith(fontSize: responsiveFontSize(context, 14)),
                    ),
                  ],
                ),
              ),
            ],
          );

          // ✅ Case 2: Authentication is still loading
        } else if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());

          // ✅ Case 3: No authenticated user (guest mode)
        } else {
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              "Guest",
              style: AppTextStyles.subheading(
                isDark ? AppColors.darkText : AppColors.lightText,
              ).copyWith(fontSize: responsiveFontSize(context, 18)),
            ),
            // Tapping the tile redirects guest users to the sign-in screen
            onTap: () => context.go('/signIn'),
          );
        }
      },
    );
  }
}
