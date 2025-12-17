import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/data/utils/validation.dart';
import 'package:task_manager_app/ui/providers/add_new_task_provider.dart';
import 'package:task_manager_app/ui/screens/main_bottom_nav_holder_screen.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';
import 'package:task_manager_app/ui/widgets/tm_app_bar.dart';
import '../widgets/show_snackbar_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  final String name = 'add-new-task';

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  bool _isloading = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          children: [
            const SizedBox(height: 50),
            Text(
              'Add New Task',
              style: Theme.of(context).textTheme.titleLarge,
            ).animate().moveX(duration: 700.ms),
            Form(
              key: _formkey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                spacing: 16,
                children: [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleTEController,
                    decoration: const InputDecoration(hintText: 'Title'),
                    validator: (value) => AllValidation().formValidation(value, 'Enter task title'),
                  ).animate().moveX(duration: 700.ms),
                  TextFormField(
                    maxLines: 5,
                    controller: _descriptionTEController,
                    decoration: const InputDecoration(hintText: 'Description'),
                    validator: (value) =>
                        AllValidation().formValidation(value, 'Enter task description'),
                  ).animate().moveX(duration: 700.ms),
                  const SizedBox(height: 8),
                  Consumer<AddNewTaskProvider>(
                    builder: (context, addNewTaskProvider, _) {
                      return Visibility(
                        visible: !addNewTaskProvider.getAddNewTaskInProgress,
                        replacement: CenteredCircularProgressIndicator().animate().moveX(
                          duration: 700.ms,
                        ),
                        child: FilledButton(
                          onPressed: _onNextScreen,
                          child: Icon(Icons.arrow_circle_right_outlined, size: 30),
                        ).animate().moveX(duration: 700.ms),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNextScreen() {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    _addTask();
  }

  Future<NetworkResponse?> _addTask() async {
    final bool isSuccess = await context.watch<AddNewTaskProvider>().addTask(
      _titleTEController.text.trim(),
      _descriptionTEController.text.trim(),
    );

    if (isSuccess) {
      clearData();
      showSnackbarMessage(context, 'New task created successfully');
      Navigator.pushNamedAndRemoveUntil(context, MainBottomNavHolderScreen().name, (p) => false);
    } else {
      showSnackbarMessage(
        context,
        context.watch<AddNewTaskProvider>().errorMessage.toString(),
        true,
      );
    }
    return null;
  }

  void clearData() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }
}
