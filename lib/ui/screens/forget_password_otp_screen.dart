import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/widgets/Screen_Background.dart';

class ForgetPasswordOtpScreen extends StatefulWidget {
  const ForgetPasswordOtpScreen({super.key});

  @override
  State<ForgetPasswordOtpScreen> createState() => _ForgetPasswordOtpScreenState();
}

class _ForgetPasswordOtpScreenState extends State<ForgetPasswordOtpScreen> {

  TextEditingController _otpController = TextEditingController();
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
                  Text("Enter Your OTP", style: Theme.of(context).textTheme.titleLarge,),
                  SizedBox(height: 4,),
                  Text("A 6 digit OTP has been sent to your email address",style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
                  SizedBox(height: 24,),
                  PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    controller: _otpController,
                    appContext: context,
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 30,),
                  FilledButton(
                    onPressed: _onTapVerifyOTPButton,
                    child:Text("Verify"),
                  ),
                  SizedBox(height: 30,),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Login",
                                style: TextStyle(color: Colors.green),
                                recognizer: TapGestureRecognizer()..onTap = (){
                                  _onTapLoginButton();
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

  void _onTapLoginButton(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> LoginScreen()),
        (predicate) => false
    );
  }
  void _onTapVerifyOTPButton(){
    Navigator.push(context, MaterialPageRoute(builder: (_)=> ResetPasswordScreen()));
  }


  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}
