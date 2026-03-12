import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class photo_picker_field extends StatelessWidget {
  const photo_picker_field({
    super.key,
    required this.onTap,
    this.selectedPhoto,
  });
  final VoidCallback onTap;
  final XFile? selectedPhoto;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200, width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 110,
              height: double.maxFinite,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13),
                  bottomLeft: Radius.circular(13),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_rounded,
                      color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Photo",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                selectedPhoto == null
                    ? "No photo selected"
                    : selectedPhoto!.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selectedPhoto == null
                      ? AppColors.textHint
                      : AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
            if (selectedPhoto != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(Icons.check_circle_rounded,
                    color: AppColors.statusCompleted, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
