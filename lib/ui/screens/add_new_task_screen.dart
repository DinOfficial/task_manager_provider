import 'package:flutter/material.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/data/utils/validation.dart';
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
            Text('Add New Task', style: Theme.of(context).textTheme.titleLarge),
            Form(
              key: _formkey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                spacing: 16,
                children: [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleTEController,
                    decoration: const InputDecoration(
                        hintText: 'Title',
                    ),
                    validator: (value) =>AllValidation().formValidation(value, 'Enter task title'),


            ),
                  TextFormField(
                    maxLines: 5,
                    controller: _descriptionTEController,
                    decoration: const InputDecoration(
                        hintText: 'Description',
                    ),
                    validator: (value) =>AllValidation().formValidation(value, 'Enter task description'),
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: !_isloading,
                    replacement: CenteredCircularProgressIndicator(),
                    child: FilledButton(
                      onPressed: _onNextScreen,
                      child: Icon(Icons.arrow_circle_right_outlined, size: 30),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _onNextScreen(){
    if (!_formkey.currentState!.validate()) {
      return;
    }
    _addTask();
  }
  Future<NetworkResponse?> _addTask() async{
    _isloading = true;
    setState(() {});

    Map<String, dynamic> responseBody ={
      "title":_titleTEController.text,
      "description": _descriptionTEController.text,
      "status":"New"
    };

    NetworkResponse response = await NetWorkCaller().postRequest(
      Urls.createTask,
      body: responseBody,
    );

    _isloading = false;
    setState(() {});

    if (response.isSuccess) {
      _titleTEController.clear();
      _descriptionTEController.clear();
      showSnackbarMessage(context, 'New task created successfully');
      Navigator.pushNamedAndRemoveUntil(context, MainBottomNavHolderScreen().name, (p)=>false);
    } else {
      showSnackbarMessage(context, response.errorMessage.toString(), true);
    }
  }

}
