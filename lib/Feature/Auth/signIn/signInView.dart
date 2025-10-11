import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/Feature/Auth/Manager/auth_cubit.dart';
import 'package:userbarber/Feature/Auth/Manager/auth_state.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if dark mode is enabled
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              Fluttertoast.showToast(
                msg: "sign in failed".getString(context),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } else if (state is AuthAuthenticated) {
              Fluttertoast.showToast(
                msg: "sign in success".getString(context),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              context.go('/home'); // Navigate to home
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "welcome".getString(context),
                          style: AppTextStyles.heading(
                              isDark ? AppColors.darkText : AppColors.primaryNavy),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "signInToContinue".getString(context),
                          style: AppTextStyles.subheading(
                              isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                        ),
                        const SizedBox(height: 40),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              color: isDark ? AppColors.darkText : AppColors.lightText),
                          decoration: InputDecoration(
                            labelText: "email".getString(context),
                            labelStyle: TextStyle(
                                color: isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                            filled: true,
                            fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            prefixIcon: Icon(Icons.email,
                                color: isDark ? AppColors.darkSecondaryText : AppColors.primaryNavy),
                          ),
                          validator: (value) =>
                          value!.isEmpty ? "email".getString(context) : null,
                        ),
                        const SizedBox(height: 20),

                        // Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(
                              color: isDark ? AppColors.darkText : AppColors.lightText),
                          decoration: InputDecoration(
                            labelText: "password".getString(context),
                            labelStyle: TextStyle(
                                color: isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                            filled: true,
                            fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            prefixIcon: Icon(Icons.lock,
                                color: isDark ? AppColors.darkSecondaryText : AppColors.primaryNavy),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: isDark
                                    ? AppColors.darkSecondaryText
                                    : AppColors.lightSecondaryText,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) =>
                          value!.isEmpty ? "password".getString(context) : null,
                        ),

                        const SizedBox(height: 10),


                        const SizedBox(height: 20),

                        // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              AppColors.accentyellow ,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: state is AuthLoading ? null : _signIn,
                            child: state is AuthLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                              "signIn".getString(context),
                              style: AppTextStyles.button(Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Sign Up redirect
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "dontHaveAccount".getString(context),
                              style: AppTextStyles.body(
                                  isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go('/signUp');
                              },
                              child: Text(
                                "signUp".getString(context),
                                style: AppTextStyles.button(AppColors.accentyellow),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
