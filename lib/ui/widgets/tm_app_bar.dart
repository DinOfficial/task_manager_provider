import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager_app/data/utils/auth_controller.dart';
import 'package:task_manager_app/ui/screens/log_in_screen.dart';
import 'package:task_manager_app/ui/screens/profile_screen.dart';

class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TMAppBar({super.key});

  @override
  State<TMAppBar> createState() => _TMAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TMAppBarState extends State<TMAppBar> {
  @override
  Widget build(BuildContext context) {
    void onTapProfile() {
      if (ModalRoute.of(context)?.settings.name != ProfileScreen().name) {
        Navigator.pushNamed(context, ProfileScreen().name);
      }
    }

    final user = AuthController.user;

    // final profilePicture = AuthController.user.
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: onTapProfile,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: AuthController.user!.photo.isEmpty
                  ? Icon(Icons.person)
                  : Image.memory(base64Decode(AuthController.user!.photo,), width: 40, height: 40, fit: BoxFit.cover,),
            ),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user?.firsName} ${user?.lastName}',
                  style: textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                Text(
                  '${user?.email}',
                  style: textTheme.labelSmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            AuthController.clearUserData();
            Navigator.pushReplacementNamed(context, SignInScreen().name);
          },
          icon: Icon(Icons.logout, color: Colors.white),
        ),
      ],
    );
  }
}
