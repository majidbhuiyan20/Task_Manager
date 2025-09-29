import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class photo_picker_field extends StatelessWidget {
  const photo_picker_field({
    super.key, required this.onTap, this.selectedPhoto,
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
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: double.maxFinite,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              ),
              child: Text("Photo", style:TextStyle(color: Colors.white),),
            ),
            SizedBox(width: 12,),
            Container(
              child: Text(selectedPhoto==null ? "No Photo is Selected " : selectedPhoto!.name, maxLines: 1, overflow: TextOverflow.ellipsis,),
            )
          ],
        ),
      ),
    );
  }
}
