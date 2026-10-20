import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  // Local state strictly for temporary UI concerns
  bool _isPasswordObscured = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailTextController.addListener(_validateInputs);
    _passwordTextController.addListener(_validateInputs);
  }

  void _validateInputs() {
    final authCubit = context.read<AuthCubit>();
    final emailError = authCubit.validateEmail(_emailTextController.text);
    final passwordError = authCubit.validatePassword(
      _passwordTextController.text,
    );

    final isInputValid = emailError == null && passwordError == null;
    if (isInputValid != _isFormValid) {
      setState(() {
        _isFormValid = isInputValid;
      });
    }
  }

  @override
  void dispose() {
    _emailTextController.removeListener(_validateInputs);
    _passwordTextController.removeListener(_validateInputs);
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLoginSubmit() {
    if (_isFormValid && (_loginFormKey.currentState?.validate() ?? false)) {
      FocusScope.of(context).unfocus();
      context.read<AuthCubit>().login(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text,
      );
    }
  }

  void _fillDemoCredentials() {
    _emailTextController.text = AppConstants.demoEmail;
    _passwordTextController.text = AppConstants.demoPassword;
    _validateInputs();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Form(
      key: _loginFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _emailTextController,
            focusNode: _emailFocusNode,
            labelText: 'Email Address',
            hintText: 'e.g. ${AppConstants.demoEmail}',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            validator: authCubit.validateEmail,
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _passwordTextController,
            focusNode: _passwordFocusNode,
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Icons.lock_outline,
            obscureText: _isPasswordObscured,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLoginSubmit(),
            validator: authCubit.validatePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordObscured = !_isPasswordObscured;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              final isAuthenticationLoading = authState is AuthLoading;

              return AppButton(
                text: 'Sign In',
                isLoading: isAuthenticationLoading,
                icon: Icons.login_rounded,
                onPressed: (_isFormValid && !isAuthenticationLoading)
                    ? _handleLoginSubmit
                    : null,
              );
            },
          ),
          const SizedBox(height: 24),
          // Demo Credentials Helper Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 15,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Demo Credentials',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: _fillDemoCredentials,
                      child: const Text(
                        'Auto Fill',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Email: ${AppConstants.demoEmail}\nPassword: ${AppConstants.demoPassword}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    height: 1.35,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
