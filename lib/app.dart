import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
      ThemeData(
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
        home: SplashScreen(),
    );
  }
}
