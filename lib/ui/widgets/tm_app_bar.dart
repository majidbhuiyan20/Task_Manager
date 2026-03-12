import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

import '../screens/update_profile_screen.dart';

class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
    this.isUpDateProfile,
    this.isAddNewTaskScreen,
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
    final profilePhoto = AuthController.userModel!.photo;
    return AppBar(
      leading: (widget.isUpDateProfile ?? false) ||
              (widget.isAddNewTaskScreen ?? false)
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              style: IconButton.styleFrom(foregroundColor: Colors.white),
            )
          : null,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
      ),
      automaticallyImplyLeading: false,
      title: GestureDetector(
        onTap: () {
          if (widget.isUpDateProfile ?? false) return;
          Navigator.pushNamed(context, UpdateProfileScreen.name);
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: profilePhoto.isNotEmpty
                    ? ClipOval(
                        child: Image.memory(
                          jsonDecode(profilePhoto),
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.person_rounded,
                        color: Colors.white, size: 22),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userModel!.fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    AuthController.userModel!.email,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 22),
            tooltip: 'Sign Out',
          ),
        ),
      ],
    );
  }

  Future<void> signOut() async {
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.name, (predicate) => false);
  }
}
