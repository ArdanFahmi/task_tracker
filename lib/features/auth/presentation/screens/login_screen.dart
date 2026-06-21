import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:task_tracker/core/constants/app_colors.dart';
import 'package:task_tracker/core/error/failure.dart';
import 'package:task_tracker/core/utils/input_decoration_helper.dart';
import 'package:task_tracker/core/widgets/custom_button.dart';
import 'package:task_tracker/core/widgets/custom_snackbar.dart';
import 'package:task_tracker/features/auth/presentation/screens/register_screen.dart';
import 'package:task_tracker/features/auth/providers/auth_provider.dart';
import 'package:task_tracker/features/home/presentation/screens/menu.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = 'login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (prev, next) {
      next.whenOrNull(
        data: (session) {
          if (session != null) {
            Navigator.pushNamedAndRemoveUntil(context, Menu.routeName, (r) => false);
          }
        },
        error: (err, _) {
          final msg = getThrowErrorMsg(err);
          showCustomSnackbar("Login failed", msg, ToastificationType.error);
        },
      );
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Image.asset("assets/icons/app_icon.png", height: 80),
              const SizedBox(height: 16),
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.neutralColor),
              ),
              const SizedBox(height: 8),
              const Text(
                'Log in to manage your daily tasks with ease.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.darkSecondary),
              ),
              const SizedBox(height: 30),
              _buildLoginForm(),
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.darkSecondary),
                  children: [
                    const TextSpan(text: "Don't have an account? "),
                    TextSpan(
                      text: "Register",
                      style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w700),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, RegisterScreen.routeName);
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    final authState = ref.watch(authProvider);

    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: AppColors.borderPrimary, width: 1),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.neutralColor),
              decoration: buildInputDecoration(hintText: "Email"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onTapOutside: (event) {
                _emailFocusNode.unfocus();
              },
            ),
            const SizedBox(height: 16),
            Text('Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              obscureText: _obscurePassword,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.neutralColor),
              decoration: buildInputDecoration(hintText: "Password").copyWith(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    padding: null,
                    icon: Icon(_obscurePassword ? SolarIconsOutline.eye : SolarIconsOutline.eyeClosed),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onTapOutside: (event) {
                _passwordFocusNode.unfocus();
              },
            ),
            const SizedBox(height: 24),
            CustomButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ref.read(authProvider.notifier).login(_emailController.text, _passwordController.text);
                }
              },
              title: "Login",
              btnColor: AppColors.primaryColor,
              colorTitle: AppColors.secondaryColor,
              paddingVerticalContent: 16,
              fontSize: 16,
              isLoading: authState.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
