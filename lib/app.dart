import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/screens/forget_password.dart';
import 'package:task_manager/ui/screens/forget_password_otp_screen.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //colorScheme: ,
        inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            )
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 16),
            fixedSize: Size.fromWidth(double.maxFinite),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      initialRoute: SplashScreen.name,
      routes: {
          SplashScreen.name: (_) => SplashScreen(),
        LoginScreen.name: (_) => LoginScreen(),
        ForgetPassword.name:(_)=> ForgetPassword(),
        ResetPasswordScreen.name:(_)=> ResetPasswordScreen(),
        SignUpScreen.name: (_) =>SignUpScreen(),
        MainNavBarHolderScreen.name:(_)=> MainNavBarHolderScreen(),
        UpdateProfileScreen.name:(_)=> UpdateProfileScreen(),
        AddNewTaskScreen.name:(_)=> AddNewTaskScreen(),
        ForgetPasswordOtpScreen.name: (_)=> ForgetPasswordOtpScreen(),

        },
    );
  }
}
