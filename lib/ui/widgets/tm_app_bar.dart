import 'package:flutter/material.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.green,
      title: Row(
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
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.logout, color: Colors.white,)),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
