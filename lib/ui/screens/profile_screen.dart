import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/data/models/user_model.dart';
import 'package:task_manager_app/data/utils/auth_controller.dart';
import 'package:task_manager_app/data/utils/validation.dart';
import 'package:task_manager_app/ui/providers/profile_provider.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/show_snackbar_message.dart';
import 'package:task_manager_app/ui/widgets/tm_app_bar.dart';
import '../widgets/screen_background.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  final String name = 'profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final UserModel user = AuthController.user!;
    _emailTEController.text = user.email;
    _firstNameTEController.text = user.firsName;
    _lastNameTEController.text = user.lastName;
    _mobileTEController.text = user.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: ScreenBackground(
          child: Form(
            key: _globalKey,
            child: Consumer<ProfileUpdateProvider>(
              builder: (context, profileUpdateProvider, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Text('Update Profile', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        profileUpdateProvider.imagePicker();
                      }, // Call the image picker function on tap
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Photos',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: Text(
                                profileUpdateProvider.pickedImage != null
                                    ? profileUpdateProvider.pickedImage!.name
                                    : 'Select Image',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailTEController,
                      decoration: InputDecoration(hintText: 'Email'),
                      enabled: false,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _firstNameTEController,
                      decoration: InputDecoration(hintText: 'First Name'),
                      validator: (value) =>
                          AllValidation().formValidation(value, 'First name required'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _lastNameTEController,
                      decoration: InputDecoration(hintText: 'Last Name'),
                      validator: (value) =>
                          AllValidation().formValidation(value, 'Last name required'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _mobileTEController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Mobile'),
                      validator: (value) =>
                          AllValidation().formValidation(value, 'Mobile number required'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordTEController,
                      obscureText: !profileUpdateProvider.isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: profileUpdateProvider.togglePassword,
                          icon: Icon(
                            profileUpdateProvider.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) ;
                        if (_passwordTEController.text.isNotEmpty &&
                            _passwordTEController.text.length < 5) {
                          return 'Please enter password at least 6 character';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    Visibility(
                      visible: !profileUpdateProvider.getProfileUpdateInProgress,
                      replacement: CenteredCircularProgressIndicator(),
                      child: FilledButton(
                        onPressed: _onSubmitButton,
                        style: FilledButton.styleFrom(),
                        child: Icon(Icons.arrow_circle_right_outlined, size: 30),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmitButton() {
    if (_globalKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    final email = _emailTEController.text.trim();
    final firstName = _firstNameTEController.text.trim();
    final lastName = _lastNameTEController.text.trim();
    final mobile = _mobileTEController.text.trim();
    final password = _passwordTEController.text.trim();
    final updateProfile = context.read<ProfileUpdateProvider>();
    final isSuccess = await updateProfile.profileUpdate(
      email,
      firstName,
      lastName,
      mobile,
      password,
    );
    if (isSuccess) {
      if (mounted) {
        showSnackbarMessage(context, 'Profile updated successfully');
      }
    } else {
      if (mounted) {
        showSnackbarMessage(context, updateProfile.errorMessage.toString(), true);
      }
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
