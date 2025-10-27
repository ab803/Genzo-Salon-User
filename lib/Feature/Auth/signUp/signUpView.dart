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
      backgroundColor:
      isDark ? AppColors.darkBackground : AppColors.lightBackground,
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
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentyellow),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                //  Header
                CustomHeaderText(
                isDark: isDark,
                title: "createAccount".getString(context),
              ),

                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _firstNameController,
                    labelKey: "firstName",
                    validatorKey: "firstNameError",
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _lastNameController,
                    labelKey: "lastName",
                    validatorKey: "lastNameError",
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _phoneController,
                    labelKey: "phoneNumber",
                    keyboardType: TextInputType.phone,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    labelKey: "email",
                    validatorKey: "emailError",
                    keyboardType: TextInputType.emailAddress,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    labelKey: "password",
                    validatorKey: "passwordError",
                    obscureText: true,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: "signUp".getString(context),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthCubit>().signUp(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                          phoneNumber: int.tryParse(_phoneController.text),
                        );
                      }
                    },
                  )
                  ,
                  const SizedBox(height: 12),
              CustomHashText(
                isDark: isDark,
                prefixText: "alreadyHaveAccount".getString(context),
                actionText: "signIn".getString(context),
                route: '/signIn',
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
