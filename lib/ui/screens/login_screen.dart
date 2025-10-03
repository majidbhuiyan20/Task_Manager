import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/model/user_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/forget_password.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/widgets/Screen_Background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import 'main_nav_bar_holder_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String name = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loginInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80,),
                  Text("Get Started With", style: Theme.of(context).textTheme.titleLarge,),
                  SizedBox(height: 24,),
              
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                    ),
                    validator: (String? value) {
                      String inputText = value ?? '';
                      if (EmailValidator.validate(inputText) == false) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                    ),
                    validator: (String? value) {
                      if ((value?.length ?? 0) < 6) {
                        return 'Enter a password more than 6 letter';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30,),
                  Visibility(
                    visible: _loginInProgress == false,
                    replacement: Center(child: CircularProgressIndicator(),),
                    child: FilledButton(
                      onPressed: _onTapLoginButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(onPressed: () {
                          _onTapForgetPasswordButton();
                        }, child: Text("Forgot Password?", style: TextStyle(color: Colors.green),)),
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(color: Colors.green),
                                recognizer: TapGestureRecognizer()..onTap = (){
                                  _onTapSignUpButton();
                                },
          
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
          
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignUpButton(){
    Navigator.pushNamed(context, SignUpScreen.name);
  }

  void _onTapForgetPasswordButton(){
    Navigator.pushNamed(context, ForgetPassword.name);
  }
void _onTapLoginButton(){
    if(_formKey.currentState!.validate()){
    _login();
  }
}
Future<void> _login()async{
    _loginInProgress = true;
    setState(() {

    });
    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "password" : _passwordController.text,
    };
    final ApiResponse response = await ApiCaller.postRequest(url: Urls.loginUrl, body: requestBody);

    if(response.isSuccess && response.responseData['status']=='success'){
      UserModel model = UserModel.fromJson(response.responseData['data']);
      String accessToken = response.responseData['token'];
      await AuthController.saveUserData(model, accessToken);
      showSnackBarMessage(context, "Login Successful", Colors.green);
      Navigator.pushNamedAndRemoveUntil(context, MainNavBarHolderScreen.name, (predicate)=> false);
    }
    else{
      _loginInProgress = false;
      setState(() {
      });
      final message = response.responseData['data'];
      showSnackBarMessage(context, message ?? response.errorMessage!, Colors.red);
    }


}


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
