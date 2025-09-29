import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/ui/widgets/Screen_Background.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32,),
                  Text("Update Profile", style: Theme.of(context).textTheme.titleLarge,),
                  SizedBox(height: 24,),
                  photo_picker_field(onTap: (){
                    _pickImage();
                  },),
                  SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "Email"),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(hintText: "First Name"),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(hintText: "Last Name"),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _mobileController,
                    decoration: InputDecoration(hintText: "Mobile"),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Password"),
                  ),
                  SizedBox(height: 30),
                  FilledButton(
                    onPressed: () {},
                    child: Icon(Icons.arrow_circle_right_outlined),
                  ),
        
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

