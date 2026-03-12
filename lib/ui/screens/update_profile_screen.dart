import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
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
  bool _obscurePassword = true;
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
      appBar: TMAppBar(isUpDateProfile: true),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.edit_note_rounded,
                      size: 36,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Update Profile",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Keep your profile information up to date",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 28),
                  photo_picker_field(
                      onTap: _pickImage, selectedPhoto: _selectedImage),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email_outlined,
                          color: AppColors.textHint, size: 22),
                    ),
                    enabled: false,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            hintText: "First Name",
                            prefixIcon: Icon(Icons.person_outline_rounded,
                                color: AppColors.textHint, size: 22),
                          ),
                          validator: (String? value) {
                            if (value?.trim().isEmpty ?? true) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            hintText: "Last Name",
                            prefixIcon: Icon(Icons.person_outline_rounded,
                                color: AppColors.textHint, size: 22),
                          ),
                          validator: (String? value) {
                            if (value?.trim().isEmpty ?? true) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      hintText: "Mobile",
                      prefixIcon: Icon(Icons.phone_outlined,
                          color: AppColors.textHint, size: 22),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your mobile';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: "Password (Optional)",
                      prefixIcon: const Icon(Icons.lock_outline_rounded,
                          color: AppColors.textHint, size: 22),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textHint,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (String? value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length < 6) {
                        return 'Enter a password more then 6 letters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Visibility(
                    visible: _updateProfileInProgress == false,
                    replacement: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child:
                            CircularProgressIndicator(color: AppColors.primary),
                      ),
                    ),
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _onTapUpdateButton();
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_rounded, size: 20),
                          SizedBox(width: 8),
                          Text("Update Profile"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapUpdateButton() {
    _updateProfile();
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    setState(() {});

    final Map<String, dynamic> requestBody = {
      "email": _emailController.text,
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileController.text.trim(),
    };
    if (_passwordController.text.isNotEmpty) {
      requestBody["password"] = _passwordController.text;
    }

    String? encodedPhoto;

    if (_selectedImage != null) {
      List<int> bytes = await _selectedImage!.readAsBytes();
      encodedPhoto = jsonEncode(bytes);
      requestBody["photo"] = jsonEncode(bytes);
    }

    final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.updateProfileUrl, body: requestBody);

    _updateProfileInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _passwordController.clear();
      UserModel model = UserModel(
        id: AuthController.userModel!.id,
        email: _emailController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        mobile: _mobileController.text.trim(),
        photo: encodedPhoto ?? AuthController.userModel!.photo,
      );

      await AuthController.updateUserData(model);
      showSnackBarMessage(
          context, "Profile Update Successful", AppColors.statusCompleted);
    } else {
      showSnackBarMessage(
          context, response.errorMessage!, AppColors.statusCancelled);
    }
  }

  Future<void> _pickImage() async {
    XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _selectedImage = pickedImage;
      setState(() {});
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
