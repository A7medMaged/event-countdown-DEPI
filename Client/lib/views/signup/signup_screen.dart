import 'package:event_app/controllers/auth_cubit/auth_cubit.dart';
import 'package:event_app/core/helpers/theming/colors.dart';
import 'package:event_app/core/helpers/widgets/app_text_button.dart';
import 'package:event_app/core/helpers/widgets/app_text_form_field.dart';
import 'package:event_app/core/routing/routes.dart';
import 'package:event_app/controllers/auth_cubit/auth_state.dart';
import 'package:event_app/views/signup/widgets/back_to_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isObscureText1 = true;
  bool isObscureText2 = true;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                    autovalidateMode: autovalidateMode,
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
                          keyboardType: TextInputType.name,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.user,
                            color: white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
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
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Enter your e-mail',
                          prefixIcon: const Icon(
                            FontAwesomeIcons.envelope,
                            color: white,
                          ),
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
                          keyboardType: TextInputType.visiblePassword,
                          isObscureText: isObscureText1,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isObscureText1 = !isObscureText1;
                              });
                            },
                            child: Icon(
                              isObscureText1
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              color: white,
                            ),
                          ),
                          prefixIcon: const Icon(
                            FontAwesomeIcons.key,
                            color: white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid password';
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontSize: 24,
                            color: secondColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppTextFormField(
                          controller: confirmPasswordController,
                          hintText: 'Re-enter your password',
                          keyboardType: TextInputType.visiblePassword,
                          isObscureText: isObscureText2,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isObscureText2 = !isObscureText2;
                              });
                            },
                            child: Icon(
                              isObscureText2
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              color: white,
                            ),
                          ),
                          prefixIcon: const Icon(
                            FontAwesomeIcons.key,
                            color: white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please re-enter your password';
                            } else if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is AuthSuccess) {
                              GoRouter.of(context).go(AppRoutes.loginScreen);
                            } else if (state is AuthFailure) {
                              toastification.show(
                                context: context,
                                title: Text(state.error),
                                type: ToastificationType.error,
                                style: ToastificationStyle.flat,
                                autoCloseDuration: const Duration(seconds: 5),
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
                                  );
                                  if (state is! AuthFailure) {
                                    toastification.show(
                                      context: context,
                                      title: const Text('Success!'),
                                      description: const Text(
                                        'Account created successfully!',
                                      ),
                                      type: ToastificationType.success,
                                      style: ToastificationStyle.minimal,
                                      autoCloseDuration: const Duration(
                                        seconds: 5,
                                      ),
                                    );
                                  }
                                } else {
                                  setState(() {
                                    autovalidateMode =
                                        AutovalidateMode.onUserInteraction;
                                  });
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
