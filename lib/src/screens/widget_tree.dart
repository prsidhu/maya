import 'package:flutter/material.dart';
import 'package:morpheus/src/screens/home/home_page.dart';
import 'package:morpheus/src/screens/login/login_page.dart';
import 'package:morpheus/src/utils/auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        }
        return const LoginPage();
      },
    );
  }
}
