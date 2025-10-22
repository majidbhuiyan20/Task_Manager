import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/utils/asset_paths.dart';
import 'package:task_manager/ui/widgets/Screen_Background.dart';

import 'login_screen.dart';
import 'main_nav_bar_holder_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToLoginScreen();
  }
  void _moveToLoginScreen()async{
    await Future.delayed(const Duration(seconds: 3));
    final bool isLoggedIn = await AuthController.isUserAlreadyLoggedIn();
    if(isLoggedIn){
      await AuthController.getUserData();
      Navigator.pushReplacementNamed(context, MainNavBarHolderScreen.name);
    }
    else{
      Navigator.pushReplacementNamed(context, LoginScreen.name);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        ScreenBackground(
          child: Center(
              // child: SvgPicture.asset(AssetPaths.logoSvg, height: 60,),
              child: Image.asset(AssetPaths.logoPng),
            ),
        ),
    
      
    );
  }
}
