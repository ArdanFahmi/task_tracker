import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:task_tracker/core/constants/app_colors.dart';
import 'package:task_tracker/core/error/failure.dart';
import 'package:task_tracker/core/widgets/custom_appbar.dart';
import 'package:task_tracker/core/widgets/custom_button.dart';
import 'package:task_tracker/core/widgets/custom_snackbar.dart';
import 'package:task_tracker/features/auth/data/models/request_register_data.dart';
import 'package:task_tracker/features/auth/presentation/screens/login_screen.dart';
import 'package:task_tracker/features/auth/providers/auth_provider.dart';
import 'package:task_tracker/features/home/presentation/screens/menu.dart';
import 'package:toastification/toastification.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const String routeName = 'register';
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();

  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  final _confirmPasswordController = TextEditingController();
  final _confirmPasswordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (prev, next) {
      next.whenOrNull(
        data: (session) {
          if (session != null) {
            Navigator.pushNamedAndRemoveUntil(context, Menu.routeName, (r) => false);
          } else if (prev is AsyncLoading) {
            showCustomSnackbar(
              "Check your email",
              "We've sent a confirmation link to your email.",
              ToastificationType.info,
            );
            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (r) => false);
          }
        },
        error: (err, _) {
          final msg = getThrowErrorMsg(err);
          showCustomSnackbar("Register failed", msg, ToastificationType.error);
        },
      );
    });

    return Scaffold(
      appBar: CustomAppbar(title: "TaskFlow", onBackPressed: () {}, enableBackPressed: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: Column(
            children: [
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.neutralColor),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join thousands of professionals organizing their workflow.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.darkSecondary),
              ),
              const SizedBox(height: 30),
              _buildRegisterForm(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    final authState = ref.watch(authProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Full Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            focusNode: _nameFocusNode,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.neutralColor),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              hintText: 'Full Name',
              hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.darkTertiary),
              prefixIcon: Padding(padding: const EdgeInsets.only(left: 10.0), child: Icon(SolarIconsOutline.user)),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.borderPrimary),
                borderRadius: BorderRadius.circular(4),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.error500),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              errorStyle: const TextStyle(color: AppColors.error500, fontSize: 12),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onTapOutside: (event) {
              _nameFocusNode.unfocus();
            },
          ),
          const SizedBox(height: 16),
          Text('Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.neutralColor),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              hintText: 'Email',
              hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.darkTertiary),
              prefixIcon: Padding(padding: const EdgeInsets.only(left: 10.0), child: Icon(SolarIconsOutline.letter)),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.borderPrimary),
                borderRadius: BorderRadius.circular(4),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.error500),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              errorStyle: const TextStyle(color: AppColors.error500, fontSize: 12),
            ),
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
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              hintText: 'Password min 6 characters',
              hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.darkTertiary),
              prefixIcon: Padding(padding: const EdgeInsets.only(left: 10.0), child: Icon(SolarIconsOutline.lock)),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  padding: null,
                  icon: Icon(_obscurePassword ? SolarIconsOutline.eye : SolarIconsOutline.eyeClosed),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.borderPrimary),
                borderRadius: BorderRadius.circular(4),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.error500),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              errorStyle: const TextStyle(color: AppColors.error500, fontSize: 12),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            onTapOutside: (event) {
              _passwordFocusNode.unfocus();
            },
          ),
          const SizedBox(height: 16),
          Text('Confirm Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            obscureText: _obscureConfirmPassword,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.neutralColor),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              hintText: 'Repeat password',
              hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.darkTertiary),
              prefixIcon: Padding(padding: const EdgeInsets.only(left: 10.0), child: Icon(SolarIconsOutline.lock)),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  padding: null,
                  icon: Icon(_obscureConfirmPassword ? SolarIconsOutline.eye : SolarIconsOutline.eyeClosed),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.borderPrimary),
                borderRadius: BorderRadius.circular(4),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.error500),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              errorStyle: const TextStyle(color: AppColors.error500, fontSize: 12),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            onTapOutside: (event) {
              _confirmPasswordFocusNode.unfocus();
            },
          ),
          const SizedBox(height: 24),
          CustomButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ref
                    .read(authProvider.notifier)
                    .register(
                      RequestRegisterData(
                        email: _emailController.text,
                        password: _passwordController.text,
                        name: _nameController.text,
                      ),
                    );
              }
            },
            title: "Register",
            btnColor: AppColors.primaryColor,
            colorTitle: AppColors.secondaryColor,
            paddingVerticalContent: 16,
            fontSize: 16,
            isLoading: authState.isLoading,
          ),
        ],
      ),
    );
  }
}
