import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/widgets/Screen_Background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../../data/model/user_model.dart';
import '../../data/services/api_caller.dart';
import '../widgets/photo_picker_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  bool _updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();
    UserModel user = AuthController.userModel!;
    _emailController.text = user.email;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _mobileController.text = user.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(isUpDateProfile: true,),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32,),
                  Text("Update Profile", style: Theme.of(context).textTheme.titleLarge,),
                  SizedBox(height: 24,),
                  photo_picker_field(onTap: _pickImage),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "Email"),
                    enabled: false,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(hintText: "First Name"),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(hintText: "Last Name"),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(hintText: "Mobile"),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your mobile';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Password (Optional)"),
                    validator: (String? value){
                      if(value != null && value.isNotEmpty && value.length <6){
                        return 'Enter a password more then 6 letters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Visibility(
                      visible: _updateProfileInProgress == false,
                      replacement: CircularProgressIndicator(),
                      child: FilledButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            _onTapUpdateButton();
                          }
                        },
                        child: Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                  ),
        
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapUpdateButton(){
      if(_formKey.currentState!.validate()){
          _updateProfile();
      }
  }

  Future<void> _updateProfile() async{
      _updateProfileInProgress = true;
      setState(() {});

      final Map<String, dynamic> requestBody = {
        "email": _emailController.text,
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "mobile": _mobileController.text.trim(),
      };
      if(_passwordController.text.isNotEmpty){
        requestBody["password"] = _passwordController.text;
      }

      if (_selectedImage != null) {
        Uint8List bytes = await _selectedImage!.readAsBytes();
        String base64Image = base64Encode(bytes);
        requestBody["photo"] = base64Image;
      }


      final ApiResponse response = await ApiCaller.postRequest(url: Urls.updateProfileUrl, body: requestBody);

      _updateProfileInProgress = false;
      setState(() {});
      if(response.isSuccess){
        _passwordController.clear();
        showSnackBarMessage(context, "Profile Update Successful", Colors.green);
      }
      else{
        showSnackBarMessage(context, response.errorMessage!, Colors.red);

      }
  }

  Future<void> _pickImage() async{
   XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
   if(pickedImage != null){
    _selectedImage = pickedImage;
    setState(() {

    });
    print(pickedImage.path);
   }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }
}

