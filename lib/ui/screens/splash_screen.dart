import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_app/data/utils/auth_controller.dart';
import 'package:task_manager_app/ui/screens/log_in_screen.dart';
import 'package:task_manager_app/ui/screens/main_bottom_nav_holder_screen.dart';
import 'package:task_manager_app/ui/utils/asset_path.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  final String name = '/flash-screen';

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
   await AuthController.getUserData();
    if (await AuthController.isLoggedIn()) {
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, MainBottomNavHolderScreen().name);
    } else {
      Navigator.pushReplacementNamed(context, SignInScreen().name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: SvgPicture.asset(
            AssetPath.logoSVG,
            width: 240,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
