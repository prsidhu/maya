import 'package:flutter/material.dart';

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 20); // Start from the top left corner

    // Create a curve from left to right
    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0); // Move to the top right corner
    path.close(); // Close the path to the starting point
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
