import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/Screen_Background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80,),
                Text("Get Started With", style: Theme.of(context).textTheme.titleLarge,),
                SizedBox(height: 24,),
            
                TextField(
                  decoration: InputDecoration(
                    hintText: "Email",
                  )
                ),
                SizedBox(height: 8,),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                ),
                SizedBox(height: 30,),
                FilledButton(
                  onPressed: () {},
                  child: Icon(Icons.arrow_circle_right_outlined),
                ),
                SizedBox(height: 30,),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: () {}, child: Text("Forgot Password?", style: TextStyle(color: Colors.green),)),
                      RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(color: Colors.green),
                              recognizer: TapGestureRecognizer()..onTap = (){},

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
    );
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
