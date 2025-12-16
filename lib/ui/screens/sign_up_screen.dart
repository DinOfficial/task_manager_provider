import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/data/utils/validation.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';
import 'package:task_manager_app/ui/widgets/show_snackbar_message.dart';
import 'log_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  final String name = '/sign-up-screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // show password function
  late var _showPassword = false;

  void _showOnTapPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  // all form key and controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  bool _isProgress = false;

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
                const SizedBox(height: 50),
                Text(
                  'Join With US',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextFormField(
                  controller: _emailTEController,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (value) => AllValidation().formValidation (value, 'Email is required')
                ),
                TextFormField(
                  controller: _firstNameTEController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(hintText: 'First Name'),
                  validator: (value) => AllValidation().formValidation (value, 'First Name is required')
                ),
                TextFormField(
                  controller: _lastNameTEController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(hintText: 'Last Name'),
                  validator: (value) => AllValidation().formValidation (value, 'Last Name is required')
                ),
                TextFormField(
                  controller: _mobileTEController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(hintText: 'Mobile'),
                  validator: (value) => AllValidation().formValidation (value, 'Mobile Number is required')
                ),
                TextFormField(
                  controller: _passwordTEController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: _showPassword ? false : true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: _showOnTapPassword,
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return " Password is required";
                    }
                    if (value!.length <= 5) {
                      return "Password must more than 6 characters";
                    }
                    return null;
                  },
                ),
                Visibility(
                  visible: !_isProgress,
                  replacement: CenteredCircularProgressIndicator(),
                  child: FilledButton(
                    onPressed: _onNextScreen,
                    style: FilledButton.styleFrom(),
                    child: Icon(Icons.arrow_circle_right_outlined, size: 30),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'have an account? ',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(color: Colors.green),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _onSignInScreen,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSignInScreen() {
    Navigator.pushNamed(context, SignInScreen().name);
  }

  void _onNextScreen() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _signUp();
  }

  Future<void> _signUp() async {
    _isProgress = true;
    setState(() {});

    Map<String, dynamic> responseBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
    };

    NetworkResponse response = await NetWorkCaller().postRequest(
      Urls.registration,
      body: responseBody,
    );

    _isProgress = false;
    setState(() {});

    if (response.isSuccess) {
      _emailTEController.clear();
      _firstNameTEController.clear();
      _lastNameTEController.clear();
      _mobileTEController.clear();
      _passwordTEController.clear();
      showSnackbarMessage(context, 'User created successfully');
      Navigator.pushNamedAndRemoveUntil(context, SignInScreen().name, (predicate)=>false);
    } else {
      showSnackbarMessage(context, response.errorMessage.toString(), true);
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
