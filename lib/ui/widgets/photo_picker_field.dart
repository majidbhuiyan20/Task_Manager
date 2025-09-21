import 'package:flutter/material.dart';

class photo_picker_field extends StatelessWidget {
  const photo_picker_field({
    super.key, required this.onTap,
  });
  final VoidCallback onTap;

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
                color: Colors.grey,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              ),
              child: Text("Photo", style:TextStyle(color: Colors.white),),
            ),
            SizedBox(width: 12,),
            Container(
              child: Text("No Photo is Selected "),
            )
          ],
        ),
      ),
    );
  }
}
