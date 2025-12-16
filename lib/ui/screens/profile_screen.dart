import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app/data/models/user_model.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/auth_controller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/data/utils/validation.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/show_snackbar_message.dart';
import 'package:task_manager_app/ui/widgets/tm_app_bar.dart';
import '../widgets/screen_background.dart';
import 'package:flutter/foundation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  final String name = 'profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool _updateProfileInProgress = false;

  final ImagePicker imagePicker = ImagePicker();
  XFile? pickedImage;

  Future<void> _imagePicker()async{
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
      pickedImage = image;
      setState(() {});
    }
  }

  bool _isShowPassword = false;
  void _onTapPasswordShow() {
    setState(() {
      _isShowPassword =! _isShowPassword;
    });
  }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                const SizedBox(height: 30),
                Text(
                  'Update Profile',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge,
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: _imagePicker, // Call the image picker function on tap
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
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            pickedImage != null
                                ? pickedImage!.name
                                : 'Select Image',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _emailTEController,
                  decoration: InputDecoration(hintText: 'Email'),
                  enabled: false,
                ),
                TextFormField(
                  controller: _firstNameTEController,
                  decoration: InputDecoration(hintText: 'First Name'),
                  validator: (value) => AllValidation().formValidation(value, 'First name required'),
                ),
                TextFormField(
                  controller: _lastNameTEController,
                  decoration: InputDecoration(hintText: 'Last Name'),
                  validator: (value) => AllValidation().formValidation(value, 'Last name required'),
                ),
                TextFormField(
                  controller: _mobileTEController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Mobile'),
                  validator: (value) => AllValidation().formValidation(value, 'Mobile number required'),
                ),
                TextFormField(
                  controller: _passwordTEController,
                  obscureText: !_isShowPassword ,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: _onTapPasswordShow,
                      icon: Icon(
                        _isShowPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),

                  validator: (String? value){
                    if(value?.isEmpty ?? true);
                    if(_passwordTEController.text.isNotEmpty && _passwordTEController.text.length < 5){
                      return 'Please enter password at least 6 character';
                    }
                  },
                ),
                Visibility(
                  visible: !_updateProfileInProgress,
                  replacement: CenteredCircularProgressIndicator(),
                  child: FilledButton(
                    onPressed: _onSubmitButton,
                    style: FilledButton.styleFrom(),
                    child: Icon(Icons.arrow_circle_right_outlined, size: 30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmitButton(){
    if(_globalKey.currentState!.validate()){
      _updateProfile();
    }
  }

  Future<void> _updateProfile()async{

    _updateProfileInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody ={
      "email":_emailTEController.text,
      "firstName":_firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile":_mobileTEController.text.trim(),
    };

    if(_passwordTEController.text.isNotEmpty){
      requestBody['password'] = _passwordTEController.text;
    }

    if(pickedImage != null){
      Uint8List imageByte = await pickedImage!.readAsBytes();
      requestBody['photo'] = base64Encode(imageByte);
    }

    final NetworkResponse response = await NetWorkCaller().postRequest(Urls.updateProfile, body: requestBody);

    _updateProfileInProgress = false;
    setState(() {});

    if(response.isSuccess){
      requestBody['_id'] = AuthController.user!.id;
     await AuthController.updateUserData(UserModel.fromJson(requestBody));
      showSnackbarMessage(context, 'Profile updated successfully');

    }else{
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
