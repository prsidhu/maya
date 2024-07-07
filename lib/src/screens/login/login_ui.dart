import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morpheus/src/utils/auth.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({Key? key}) : super(key: key);

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  String? _errorMessage = '';
  bool isLogin = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget _buildTextField(
      {required TextEditingController controller,
      required String labelText,
      IconData? icon,
      bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
      obscureText: obscureText,
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
      ),
      child: Text(text),
    );
  }

  Future<void> signIn() async {
    try {
      await Auth().signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    } on FirebaseAuthException catch (_, e) {
      throw e;
    }
  }

  Future<void> signUp() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    } on FirebaseAuthException catch (_, e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildTextField(
            controller: _emailController,
            labelText: 'Email',
            icon: Icons.email,
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            controller: _passwordController,
            labelText: 'Password',
            icon: Icons.lock,
            obscureText: true,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 16.0),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ],
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton(
                  text: isLogin ? 'Sign In' : 'Create an account',
                  onPressed: isLogin ? signIn : signUp),
            ],
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isLogin = !isLogin;
              });
            },
            child: Text(
                isLogin ? 'Create an account' : 'Already have an account?'),
          ),
        ],
      ),
    );
  }
}
