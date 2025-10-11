import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/Feature/Auth/Manager/auth_cubit.dart';
import 'package:userbarber/Feature/Auth/Manager/auth_state.dart';
import 'package:userbarber/Feature/Localization/Locales.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:userbarber/Feature/ValueNotifier.dart';

class AppSettingsDrawer extends StatefulWidget {
  const AppSettingsDrawer({super.key});

  @override
  State<AppSettingsDrawer> createState() => _AppSettingsDrawerState();
}

class _AppSettingsDrawerState extends State<AppSettingsDrawer> {
  late bool isDarkMode;
  String selectedLanguage = 'En';
  final List<String> languages = ['En', 'ع'];
  late FlutterLocalization localization;

  double responsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    return baseSize * (screenWidth / 375); // base on 375px width
  }

  @override
  void initState() {
    super.initState();
    localization = FlutterLocalization.instance;
    isDarkMode = themeNotifier.value == ThemeMode.dark;
    selectedLanguage =
    localization.currentLocale?.languageCode == 'ar' ? 'ع' : 'En';

    context.read<AuthCubit>().loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor:
      isDark ? AppColors.darkBackground : AppColors.lightBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 User Info Header
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    final user = state.user;
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.accentyellow,
                          child: Text(
                            user.firstName[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: responsiveFontSize(context, 22),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${user.firstName} ${user.lastName}",
                                style: AppTextStyles.subheading(
                                  isDark
                                      ? AppColors.darkText
                                      : AppColors.lightText,
                                ).copyWith(
                                  fontSize: responsiveFontSize(context, 18),
                                ),
                              ),
                              Text(
                                user.email,
                                style: AppTextStyles.body(
                                  isDark
                                      ? AppColors.darkText
                                      : AppColors.lightText,
                                ).copyWith(
                                  fontSize: responsiveFontSize(context, 14),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  } else if (state is AuthLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                        "Guest",
                        style: AppTextStyles.subheading(
                          isDark ? AppColors.darkText : AppColors.lightText,
                        ).copyWith(
                          fontSize: responsiveFontSize(context, 18),
                        ),
                      ),
                      onTap: () => context.go('/signIn'),
                    );
                  }
                },
              ),

              const Divider(height: 30, thickness: 1),

              // 🔤 Language selection
              Card(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'language'.getString(context),
                        style: AppTextStyles.subheading(
                          isDark ? AppColors.darkText : AppColors.lightText,
                        ).copyWith(
                          fontSize: responsiveFontSize(context, 18),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedLanguage,
                        style: AppTextStyles.body(
                          isDark ? AppColors.darkText : AppColors.lightText,
                        ).copyWith(
                          fontSize: responsiveFontSize(context, 14),
                        ),
                        dropdownColor:
                        isDark ? AppColors.darkCard : AppColors.lightCard,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                          isDark ? AppColors.darkCard : AppColors.lightCard,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: languages
                            .map(
                              (lang) => DropdownMenuItem(
                            value: lang,
                            child: Text(
                              lang,
                              style: AppTextStyles.body(
                                isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                              ).copyWith(
                                fontSize: responsiveFontSize(context, 14),
                              ),
                            ),
                          ),
                        )
                            .toList(),
                        onChanged: (value) async {
                          if (value == null) return;
                          setState(() => selectedLanguage = value);

                          if (value == 'En') {
                            localization.translate('en');
                            await saveLocale('en');
                          } else {
                            localization.translate('ar');
                            await saveLocale('ar');
                          }
                        },
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.primaryNavy,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🌙 Dark Mode toggle
              Card(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16),
                  activeColor: AppColors.accentyellow,
                  title: Text(
                    "darkMode".getString(context),
                    style: AppTextStyles.body(
                      isDark ? AppColors.darkText : AppColors.lightText,
                    ).copyWith(
                      fontSize: responsiveFontSize(context, 14),
                    ),
                  ),
                  value: isDarkMode,
                  onChanged: (value) async {
                    setState(() => isDarkMode = value);
                    themeNotifier.value =
                    value ? ThemeMode.dark : ThemeMode.light;
                    await saveTheme(value);
                  },
                ),
              ),

              const Spacer(),

              // ℹ️ About App
              ListTile(
                leading: Icon(Icons.info_outline,
                    color:
                    isDark ? AppColors.darkText : AppColors.primaryNavy),
                title: Text(
                  'aboutUs'.getString(context),
                  style: AppTextStyles.body(
                    isDark ? AppColors.darkText : AppColors.lightText,
                  ).copyWith(
                    fontSize: responsiveFontSize(context, 14),
                  ),
                ),
                onTap: () {
                  // TODO: Show About page or dialog
                },
              ),

              // 🚪 Logout
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'logout'.getString(context),
                  style: AppTextStyles.body(Colors.red).copyWith(
                    fontSize: responsiveFontSize(context, 14),
                  ),
                ),
                onTap: () async {
                  await context.read<AuthCubit>().signOut();
                  context.go('/signIn');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
