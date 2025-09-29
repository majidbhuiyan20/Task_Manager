import 'package:flutter/material.dart';

import '../screens/update_profile_screen.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key, this.isUpDateProfile, this.isAddNewTaskScreen,
  });
  final bool? isUpDateProfile;
  final bool? isAddNewTaskScreen;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: (isUpDateProfile ?? false) || (isAddNewTaskScreen ?? false)
          ? const BackButton(color: Colors.white)
          : null,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      title: GestureDetector(
        onTap: (){
          if(isUpDateProfile ?? false)
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
                Text("Majid Bhuiyan", style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
                Text("majid@gmail.com", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
              ],
            ),
          ],
        
        ),
      ),
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.logout, color: Colors.white,)),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
