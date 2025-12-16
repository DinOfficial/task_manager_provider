import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/user_model.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/auth_controller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
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
  bool _isPasswordVisible = false;

  void _togglePassword() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  bool _signInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: ScreenBackground(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                const SizedBox(height: 100),
                Text(
                  'Get Started With',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextFormField(
                  controller: _emailTEController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (String? value) => (value?.isEmpty ?? true)
                      ? 'Please enter valid email'
                      : null,
                ),
                TextFormField(
                  controller: _passwordTEController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: _togglePassword,
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (String? value) => (value?.isEmpty ?? true)
                      ? 'Please enter your password'
                      : null,
                ),
                Visibility(
                  visible: !_signInProgress,
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
                              recognizer: TapGestureRecognizer()
                                ..onTap = _onSignUp,
                            ),
                          ],
                        ),
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

  void _onTapSignIn() async {
    _signInProgress = true;
    setState(() {});

    Map<String, dynamic> responseBody = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text,
    };

    NetworkResponse response = await NetWorkCaller().postRequest(
      Urls.signIn,
      body: responseBody,
    );

    _signInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      UserModel userModel = await UserModel.fromJson(response.body['data']);
      String accessToken = response.body['token'];
      await AuthController.saveUserToken(accessToken, userModel);
      clearInputField();
      showSnackbarMessage(context, 'You are successfully login');
      Navigator.pushReplacementNamed(context, MainBottomNavHolderScreen().name);
    } else {
      showSnackbarMessage(context, response.errorMessage.toString(), true);
    }
  }
  void clearInputField(){
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
