import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/screens/cancel_task_list_screen.dart';
import 'package:task_manager_app/ui/screens/completed_task_list_screen.dart';
import 'package:task_manager_app/ui/screens/new_task_list_screen.dart';
import 'package:task_manager_app/ui/screens/progress_task_list.dart';
import '../widgets/tm_app_bar.dart';

class MainBottomNavHolderScreen extends StatefulWidget {
  const MainBottomNavHolderScreen({super.key});

  final String name = 'main-bottom-nav-holder';

  @override
  State<MainBottomNavHolderScreen> createState() =>
      _MainBottomNavHolderScreenState();
}

class _MainBottomNavHolderScreenState extends State<MainBottomNavHolderScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    NewTaskListScreen(),
    ProgressTaskListScreen(),
    CancelTaskListScreen(),
    CompletedTaskListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body:_screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.green,
        animationDuration: Duration(milliseconds: 700),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.white,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.new_label,
              color: _selectedIndex == 0 ? Colors.white : Colors.black,
            ),
            label: 'New',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.access_time_rounded,
              color: _selectedIndex == 1 ? Colors.white : Colors.black,
            ),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.cancel_outlined,
              color: _selectedIndex == 2 ? Colors.white : Colors.black,
            ),
            label: 'Cancelled',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.done,
              color: _selectedIndex == 3 ? Colors.white : Colors.black,
            ),
            label: 'Completed',
          ),
        ],
      ),
    );
  }
}
