import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/Feature/Auth/Manager/auth_cubit.dart';
import 'package:userbarber/Feature/Auth/Manager/auth_state.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Fluttertoast.showToast(
              msg: "signUp Success".getString(context),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            context.go("/home");
          } else if (state is AuthError) {
            Fluttertoast.showToast(
              msg: "signUp failed".getString(context),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator( color: AppColors.accentyellow,));
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    "createAccount".getString(context),
                    style: AppTextStyles.subheading(isDark ? AppColors.darkText : AppColors.lightText),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  /// First Name
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: "firstName".getString(context),
                      labelStyle: AppTextStyles.body(
                          isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                      filled: true,
                      fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: AppTextStyles.body(isDark ? AppColors.darkText : AppColors.lightText),
                    validator: (val) => val!.isEmpty ? "firstNameError".getString(context) : null,
                  ),
                  const SizedBox(height: 16),

                  /// Last Name
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: "lastName".getString(context),
                      labelStyle: AppTextStyles.body(
                          isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                      filled: true,
                      fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: AppTextStyles.body(isDark ? AppColors.darkText : AppColors.lightText),
                    validator: (val) => val!.isEmpty ? "lastNameError".getString(context) : null,
                  ),
                  const SizedBox(height: 16),

                  /// Phone Number
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "phoneNumber".getString(context),
                      labelStyle: AppTextStyles.body(
                          isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                      filled: true,
                      fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: AppTextStyles.body(isDark ? AppColors.darkText : AppColors.lightText),
                  ),
                  const SizedBox(height: 16),

                  /// Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "email".getString(context),
                      labelStyle: AppTextStyles.body(
                          isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                      filled: true,
                      fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: AppTextStyles.body(isDark ? AppColors.darkText : AppColors.lightText),
                    validator: (val) => val!.isEmpty ? "emailError".getString(context) : null,
                  ),
                  const SizedBox(height: 16),

                  /// Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "password".getString(context),
                      labelStyle: AppTextStyles.body(
                          isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                      filled: true,
                      fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: AppTextStyles.body(isDark ? AppColors.darkText : AppColors.lightText),
                    validator: (val) => val!.length < 6 ? "passwordError".getString(context) : null,
                  ),
                  const SizedBox(height: 24),

                  /// Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentyellow,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().signUp(
                            email: _emailController.text,
                            password: _passwordController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            phoneNumber: int.tryParse(_phoneController.text),
                          );
                        }
                      },
                      child: Text(
                        "signUp".getString(context),
                        style: AppTextStyles.button(AppColors.primaryNavy),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Already have account
                  TextButton(
                    onPressed: () {
                      context.go('/signIn');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "alreadyHaveAccount".getString(context),
                          style: AppTextStyles.caption(
                              isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "signIn".getString(context),
                          style: AppTextStyles.caption(AppColors.accentyellow),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
