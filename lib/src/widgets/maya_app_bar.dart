import 'package:flutter/material.dart';

class MayaAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading:
            Image.asset('assets/images/maya_glitter.png', fit: BoxFit.fitWidth),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/maya_text.png', // Replace with your image path
              height: 36.0, // Adjust the height as needed
            ),
          ],
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
