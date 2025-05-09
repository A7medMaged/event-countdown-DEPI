import 'package:events_dashboard/core/helpers/theming/colors.dart';
import 'package:events_dashboard/core/helpers/widgets/app_text_button.dart';
import 'package:events_dashboard/core/helpers/widgets/app_text_form_field.dart';
import 'package:events_dashboard/core/routing/routes.dart';
import 'package:events_dashboard/controllers/user_cubit/user_cubit.dart';
import 'package:events_dashboard/controllers/user_cubit/user_state.dart';
import 'package:events_dashboard/views/signup/ui/widgets/back_to_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isObscureText = true;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 36,
                        color: secondColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'We wish you a good day, please fill in the form to create an account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 24,
                            color: secondColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextFormField(
                          controller: nameController,
                          hintText: 'Enter your name',
                          suffixIcon: const Icon(Icons.person_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 24,
                            color: secondColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          hintText: 'Enter your phone number',
                          suffixIcon: const Icon(Icons.phone_outlined),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'E-mail',
                          style: TextStyle(
                            fontSize: 24,
                            color: secondColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextFormField(
                          controller: emailController,
                          hintText: 'Enter your e-mail',
                          suffixIcon: const Icon(Icons.email_outlined),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid email';
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 24,
                            color: secondColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextFormField(
                          controller: passwordController,
                          hintText: 'Enter your password',
                          isObscureText: isObscureText,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isObscureText = !isObscureText;
                              });
                            },
                            child: Icon(
                              isObscureText
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid password';
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is AuthSuccess) {
                              GoRouter.of(context).go(AppRoutes.loginScreen);
                            } else if (state is AuthFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.error)),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return AppTextButton(
                              buttonText: "Sign Up",
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: secondColor,
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().register(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    name: nameController.text.trim(),
                                    phone: phoneController.text.trim(),
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        const Center(child: BackToLoginScreen()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
