import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/widgets/Screen_Background.dart';

import 'forget_password_otp_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});
  static const String name = '/forget-password';

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80,),
                  Text("Enter Your Email Address", style: Theme.of(context).textTheme.titleLarge,),
                  SizedBox(height: 4,),
                  Text("A 6 digit OTP will be sent to your email address",style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
                  SizedBox(height: 24,),
              
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                    )
                  ),

                  SizedBox(height: 30,),
                  FilledButton(
                    onPressed: _onTapNextButton,
                    child: Icon(Icons.arrow_circle_right_outlined),
                  ),
                  SizedBox(height: 30,),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
  void _onTapNextButton(){
    Navigator.pushNamed(context, ForgetPasswordOtpScreen.name);
  }


  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
