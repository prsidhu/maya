import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:morpheus/src/utils/auth.dart';
import 'package:morpheus/src/widgets/password_field.dart';
import 'package:morpheus/src/widgets/text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  String? _errorMessage = '';
  String? _passwordValidation = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _validatePassword() {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _passwordValidation = 'Passwords do not match.';
      });
    } else if (_passwordValidation!.isNotEmpty) {
      setState(() {
        _passwordValidation = ''; // Clear error message if passwords match
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Add listener to confirm password controller
    _confirmPasswordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    // Remove listener to avoid memory leaks
    _confirmPasswordController.removeListener(_validatePassword);
    super.dispose();
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: _passwordValidation!.isNotEmpty ? null : onPressed,
      child: Text(text),
    );
  }

  Widget _title() {
    return Text(
      isLogin ? 'Sign In' : 'Create an account',
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }

  Future<void> signIn() async {
    try {
      await Auth().signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  Future<void> signUp() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MayaTextField(
              controller: _emailController,
              labelText: 'Email',
              leadingIcon: Icons.email,
            ),
            const SizedBox(height: 16.0),
            PasswordField(
                controller: _passwordController, labelText: 'Password'),
            if (!isLogin) ...[
              const SizedBox(height: 16.0),
              PasswordField(
                controller: _confirmPasswordController,
                labelText: 'Confirm password',
                onChanged: _validatePassword,
              ),
            ],
            if (_passwordValidation!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Text(
                _passwordValidation!,
                style: const TextStyle(color: Colors.red),
              )
            ],
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
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(
                  isLogin ? 'Create an account' : 'Already have an account?'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton.icon(
                icon: const Icon(
                  FontAwesomeIcons
                      .google, // Using FontAwesomeIcons for Google icon
                  color: Colors.white, // Icon color
                ),
                label: const Text(''), // No text, as you want only the icon
                onPressed: () {
                  signInWithGoogle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red, // Background color - Google's red
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Rounded corners
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
