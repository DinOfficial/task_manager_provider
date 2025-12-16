import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/data/utils/validation.dart';
import 'package:task_manager_app/ui/screens/log_in_screen.dart';
import 'package:task_manager_app/ui/screens/reset_password_screen.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';
import 'package:task_manager_app/ui/widgets/show_snackbar_message.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  final String name = '/otp-verify';

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  bool _otpVerifyInProgress = false;
  final TextEditingController _optTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  'PIN Verification',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  'A 6 digit verification code will sent to your email address',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 10),
                PinCodeTextField(
                  controller: _optTEController,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveColor: Colors.blue,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,
                  autoDismissKeyboard: true,
                  backgroundColor: Colors.transparent,
                  appContext: context,
                  validator: (value) =>
                      AllValidation().formValidation(value, 'Enter your OTP '),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: !_otpVerifyInProgress,
                  replacement: CenteredCircularProgressIndicator(),
                  child: FilledButton(
                    onPressed: _onNextPage,
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

  void _onNextPage() {
    if (_formKey.currentState!.validate()) {
      _otpVerify();
    }
  }

  Future<void> _otpVerify() async {
    _otpVerifyInProgress = true;
    setState(() {});

    final email = ModalRoute.of(context)!.settings.arguments.toString();
    final otp = _optTEController.text.trim();

    // String resetPasswordArguments(String email, String otp){
    //   return (email,otp);
    // }

    final NetworkResponse response = await NetWorkCaller().getRequest(
      Urls.emailVerifyOTP(email, otp),
    );
    _otpVerifyInProgress = false;
    setState(() {});
    if (response.isSuccess && response.body['status'] == 'success') {
      showSnackbarMessage(context, 'OTP Verification successful !');
      Navigator.pushNamed(
        context,
        ResetPasswordScreen().name,
        arguments: {
          'email' : email,
          'otp' : otp
        },
      );
    } else {
      showSnackbarMessage(
        context,
        response.body['data'] ?? 'OTP verification failed',
      );
    }
  }
}
