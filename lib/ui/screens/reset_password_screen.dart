import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/data/utils/validation.dart';
import 'package:task_manager_app/ui/screens/log_in_screen.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';
import 'package:task_manager_app/ui/widgets/show_snackbar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  final String name = '/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _setPassowrdInProgress = false;
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _showPassword = false;

  void _toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: ScreenBackground(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              // spacing: 10,
              children: [
                const SizedBox(height: 100),
                Text(
                  'Set Password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  'Minimum password length 8 characters with letter and number combination',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: !_showPassword,
                  controller: _passwordTEController,
                  decoration: InputDecoration(
                    hintText: 'New Password',
                  ),
                  validator: (value) => AllValidation().formValidation(
                    value,
                    'Enter new password',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  obscureText: !_showPassword,
                  controller: _confirmPasswordTEController,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      onPressed: _toggleShowPassword,
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty ) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordTEController.text) {
                      return 'Password do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: !_setPassowrdInProgress,
                  replacement: CenteredCircularProgressIndicator(),
                  child: FilledButton(
                    onPressed: _onNextScreen,
                    style: FilledButton.styleFrom(),
                    child: Icon(Icons.arrow_circle_right_outlined, size: 30),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'have an account? ',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(color: Colors.green),
                          recognizer: TapGestureRecognizer()..onTap = _signIn,
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

  void _signIn() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen().name,
      (p) => false,
    );
  }

  void _onNextScreen() {
    if (_formKey.currentState!.validate()) {
      _resetPassword();
    }
  }

  Future<void> _resetPassword() async {
    _setPassowrdInProgress = true;
    setState(() {});

    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final email = arguments['email'];
    final otp = arguments['otp'];

    print('Email from previous screen: $email');
    print('OTP from previous screen: $otp');

    Map<String, dynamic> responseBody = {
      "email": email,
      "OTP": otp,
      "password": _confirmPasswordTEController.text,
    };

    final NetworkResponse response = await NetWorkCaller().postRequest(
      Urls.recoveryResetPassword,
      body: responseBody,
    );


    _setPassowrdInProgress = false;
    setState(() {});



    if (response.isSuccess && response.body['status'] == 'success') {
      showSnackbarMessage(context, response.body['status'] ?? 'Password reset successful !');
      Navigator.pushNamedAndRemoveUntil(
        context,
        SignInScreen().name,
        (p) => false,
      );
    } else {
      showSnackbarMessage(context, response.errorMessage ?? 'Password reset failed', true);
    }
  }
}
