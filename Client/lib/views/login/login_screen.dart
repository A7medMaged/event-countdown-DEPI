import 'package:event_app/controllers/auth_cubit/auth_cubit.dart';
import 'package:event_app/core/helpers/theming/colors.dart';
import 'package:event_app/core/helpers/widgets/app_text_button.dart';
import 'package:event_app/core/helpers/widgets/app_text_form_field.dart';
import 'package:event_app/core/routing/routes.dart';
import 'package:event_app/controllers/auth_cubit/auth_state.dart';
import 'package:event_app/views/login/widget/do_not_have_accont.dart';
import 'package:event_app/views/login/widget/terms_condition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscureText = true;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: secondColor,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 32),
                Form(
                  key: formKey,
                  autovalidateMode: autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'E-mail',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: secondColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      AppTextFormField(
                        controller: _emailController,
                        hintText: 'Enter your e-mail',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.alternate_email,
                          color: white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid e-mail';
                          }
                        },
                      ),
                      SizedBox(height: 32),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: secondColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      AppTextFormField(
                        controller: _passwordController,
                        hintText: 'Enter your password',
                        keyboardType: TextInputType.visiblePassword,
                        isObscureText: isObscureText,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: white,
                        ),
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
                            size: 24,
                            color: secondColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid password';
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: GestureDetector(
                          onTap: () {
                            FirebaseAuth.instance.sendPasswordResetEmail(
                              email: _emailController.text.trim(),
                            );
                          },
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: secondColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 46),
                      BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is AuthSuccess) {
                            GoRouter.of(
                              context,
                            ).pushReplacement(AppRoutes.homeview);
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
                            buttonText: "Sign In",
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: secondColor,
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                try {
                                  context.read<AuthCubit>().login(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                                } on FirebaseAuthException catch (e) {
                                  // ignore: unused_local_variable
                                  String errorMessage;
                                  switch (e.code) {
                                    case 'invalid-email':
                                      errorMessage =
                                          'The email address is not valid.';
                                      break;
                                    case 'user-disabled':
                                      errorMessage =
                                          'The user account has been disabled.';
                                      break;
                                    case 'user-not-found':
                                      errorMessage =
                                          'No user found with this email.';
                                      break;
                                    case 'wrong-password':
                                      errorMessage = 'Incorrect password.';
                                      break;
                                    default:
                                      errorMessage =
                                          'An unknown error occurred.';
                                  }
                                } catch (e) {
                                  // ignore: avoid_print
                                  print(e.toString());
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
                      const SizedBox(height: 16),
                      const TermsAndConditionsText(),
                      const SizedBox(height: 16),
                      const Center(child: DontHaveAccountText()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> loginUser() async {
  //   // ignore: unused_local_variable
  //   UserCredential user =

  // }
}
