import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_app/ui/screens/splash_screen.dart';
import 'package:task_manager_app/ui/screens/forgot_password_email_screen.dart';
import 'package:task_manager_app/ui/screens/main_bottom_nav_holder_screen.dart';
import 'package:task_manager_app/ui/screens/otp_verify_screen.dart';
import 'package:task_manager_app/ui/screens/profile_screen.dart';
import 'package:task_manager_app/ui/screens/reset_password_screen.dart';
import 'package:task_manager_app/ui/screens/sign_up_screen.dart';

import 'ui/screens/log_in_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKay = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKay,
      debugShowCheckedModeBanner: false,
      title: 'Task Manager APP',
      theme: ThemeData(
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fixedSize: Size.fromWidth(double.maxFinite),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)
        ),
        scaffoldBackgroundColor: Colors.grey.shade100
      ),
      initialRoute: FlashScreen().name,
      routes: <String, WidgetBuilder>{
        FlashScreen().name: (_) => FlashScreen(),
        SignUpScreen().name: (_) => SignUpScreen(),
        SignInScreen().name: (_) => SignInScreen(),
        ForgotPasswordEmailScreen().name: (_) => ForgotPasswordEmailScreen(),
        OtpVerifyScreen().name: (_) => OtpVerifyScreen(),
        ResetPasswordScreen().name: (_) => ResetPasswordScreen(),
        MainBottomNavHolderScreen().name: (_) => MainBottomNavHolderScreen(),
        AddNewTaskScreen().name : (_) => AddNewTaskScreen(),
        ProfileScreen().name : (_) => ProfileScreen(),
      },
    );
  }
}
