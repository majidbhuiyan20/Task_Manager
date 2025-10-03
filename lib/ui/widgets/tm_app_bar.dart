import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';

import '../screens/update_profile_screen.dart';

class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key, this.isUpDateProfile, this.isAddNewTaskScreen,
  });
  final bool? isUpDateProfile;
  final bool? isAddNewTaskScreen;

  @override
  State<TMAppBar> createState() => _TMAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TMAppBarState extends State<TMAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: (widget.isUpDateProfile ?? false) || (widget.isAddNewTaskScreen ?? false)
          ? const BackButton(color: Colors.white)
          : null,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      title: GestureDetector(
        onTap: (){
          if(widget.isUpDateProfile ?? false)
            {
              return;
            }
          Navigator.pushNamed(context, UpdateProfileScreen.name);
        },
        child: Row(
          spacing: 8,
          children: [
            CircleAvatar(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AuthController.userModel!.fullName ?? " ", style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
                Text(AuthController.userModel!.email ?? " ", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
              ],
            ),
          ],
        
        ),
      ),
      actions: [
        IconButton(onPressed:signOut, icon: Icon(Icons.logout, color: Colors.white,)),
      ],
    );
  }
  Future<void> signOut()async{
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.name, (predicate)=>false );
  }
}
