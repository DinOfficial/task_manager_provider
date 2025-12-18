import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/ui/providers/login_provider.dart';
import 'package:task_manager_app/ui/screens/forgot_password_email_screen.dart';
import 'package:task_manager_app/ui/screens/main_bottom_nav_holder_screen.dart';
import 'package:task_manager_app/ui/screens/sign_up_screen.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';
import 'package:task_manager_app/ui/widgets/show_snackbar_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  final String name = '/sign-in-screen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: ScreenBackground(
          child: Form(
            key: _formKey,
            child: Consumer<LoginProvider>(
              builder: (context, loginProvider, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    const SizedBox(height: 100),
                    Text('Get Started With', style: Theme.of(context).textTheme.titleLarge),
                    TextFormField(
                      controller: _emailTEController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(hintText: 'Email'),
                      validator: (String? value) =>
                          (value?.isEmpty ?? true) ? 'Please enter valid email' : null,
                    ),
                    TextFormField(
                      controller: _passwordTEController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: !loginProvider.isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            loginProvider.togglePassword();
                          },
                          icon: Icon(
                            loginProvider.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (String? value) =>
                          (value?.isEmpty ?? true) ? 'Please enter your password' : null,
                    ),
                    Visibility(
                      visible: !loginProvider.getLoginInProgress,
                      replacement: CenteredCircularProgressIndicator(),
                      child: FilledButton(
                        onPressed: _onNextScreen,
                        style: FilledButton.styleFrom(),
                        child: Icon(Icons.arrow_circle_right_outlined, size: 30),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: _onForgotPasswordEmail,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(fontSize: 18, color: Colors.green),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Don\'t have an account? ',
                              style: TextStyle(color: Colors.grey, fontSize: 18),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(color: Colors.green),
                                  recognizer: TapGestureRecognizer()..onTap = _onSignUp,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }

  void _onForgotPasswordEmail() {
    Navigator.pushNamed(context, ForgotPasswordEmailScreen().name);
  }

  void _onSignUp() {
    Navigator.pushNamed(context, SignUpScreen().name);
  }

  void _onNextScreen() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _onTapSignIn();
  }

  Future<void> _onTapSignIn() async {
    final loginProvider = context.read<LoginProvider>();
    bool isSuccess = await loginProvider.signIn(
      _emailTEController.text.trim(),
      _passwordTEController.text,
    );

    if (isSuccess) {
      clearInputField();
      showSnackbarMessage(context, 'You are successfully login');
      Navigator.pushNamedAndRemoveUntil(context, MainBottomNavHolderScreen().name, (p)=>false);
    } else {
      showSnackbarMessage(context, loginProvider.errorMessage.toString(), true);
    }
  }

  void clearInputField() {
    _emailTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
