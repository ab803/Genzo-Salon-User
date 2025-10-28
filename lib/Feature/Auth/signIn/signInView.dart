import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/Feature/Auth/Manager/auth_cubit.dart';
import 'package:userbarber/Feature/Auth/Manager/auth_state.dart';
import 'package:userbarber/Feature/Auth/widgets/CustomButton.dart';
import 'package:userbarber/Feature/Auth/widgets/CustomHashText%20.dart';
import 'package:userbarber/Feature/Auth/widgets/CustomTextField.dart';
import 'package:userbarber/Feature/Auth/widgets/HeaderText.dart';
import 'package:userbarber/core/Styles/Styles.dart';


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
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
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
                        CustomHeaderText(
                          isDark: isDark,
                          title: "signInToContinue".getString(context),
                        ),
                        const SizedBox(height: 40),
                        // Email
                        CustomTextField(
                          controller: _emailController,
                          labelKey: "email",
                          validatorKey: "email",
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 20),

                        // Password
                        CustomTextField(
                          controller: _passwordController,
                          labelKey: "password",
                          validatorKey: "password",
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock,
                          suffixIcon: _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onSuffixTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          isDark: isDark,
                        ),

                        const SizedBox(height: 30),

                        // Sign In Button
                        CustomButton(
                          text: "signIn".getString(context),
                          isLoading: state is AuthLoading,
                          onPressed: _signIn,
                          textColor: AppColors.primaryNavy,
                          backgroundColor: AppColors.accentyellow,
                        ),

                        const SizedBox(height: 20),

                        // Sign Up redirect
                        CustomHashText(
                          isDark: isDark,
                          prefixText: "dontHaveAccount".getString(context),
                          actionText: "signUp".getString(context),
                          route: '/signUp',
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
