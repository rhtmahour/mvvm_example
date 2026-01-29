import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mvvm/res/components/round_button.dart';
import 'package:mvvm/utils/utils.dart';
import 'package:mvvm/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    _obscurePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            height: size.height - kToolbarHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Logo / Icon
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: 48,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 24),

                /// Title
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                /// Subtitle
                Text(
                  'Login to continue',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 32),

                /// Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// Email
                      TextFormField(
                        controller: _emailController,
                        focusNode: emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onFieldSubmitted: (_) {
                          Utils.fieldFocusChange(
                            context,
                            emailFocusNode,
                            passwordFocusNode,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      /// Password
                      ValueListenableBuilder<bool>(
                        valueListenable: _obscurePassword,
                        builder: (context, value, _) {
                          return TextFormField(
                            controller: _passwordController,
                            focusNode: passwordFocusNode,
                            obscureText: value,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility,
                                ),
                                onPressed: () =>
                                    _obscurePassword.value = !value,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      /// Login Button
                      RoundButton(
                        title: 'Login',
                        loading: authViewModel.loading,
                        onPress: () {
                          if (_emailController.text.isEmpty) {
                            Utils.flushBarErrorMessage(
                              'Email is empty',
                              context,
                            );
                          } else if (_passwordController.text.isEmpty) {
                            Utils.flushBarErrorMessage(
                              'Password is empty',
                              context,
                            );
                          } else if (_passwordController.text.length < 6) {
                            Utils.flushBarErrorMessage(
                              'Password must be at least 6 characters',
                              context,
                            );
                          } else {
                            final data = {
                              'email': _emailController.text.trim(),
                              'password': _passwordController.text.trim(),
                            };
                            authViewModel.LoginApi(data, context);
                            if (kDebugMode) {
                              print('Api Hit');
                            }
                          }
                        },
                      ),
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
}
