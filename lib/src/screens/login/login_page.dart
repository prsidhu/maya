import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maya/src/utils/auth.dart';
import 'package:maya/src/widgets/password_field.dart';
import 'package:maya/src/widgets/text_field.dart';
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
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _passwordValidation!.isNotEmpty ? null : onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.onSurface),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            ),
          ),
          child: Text(text),
        ));
  }

  Widget _title() {
    return Text(
      isLogin ? 'Sign In' : 'Create an account',
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }

  Widget _buildDivider() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 2,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Or login with',
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            Expanded(
              child: Container(
                height: 2,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ));
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
    try {
      await Auth().signInWithGoogle();
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      MayaTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        leadingIcon: Icons.email,
                      ),
                      const SizedBox(height: 16.0),
                      PasswordField(
                        controller: _passwordController,
                        labelText: 'Password',
                      ),
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildButton(
                          text: isLogin ? 'Sign In' : 'Create an account',
                          onPressed: isLogin ? signIn : signUp,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin
                              ? 'Create an account'
                              : 'Already have an account?',
                        ),
                      ),
                      _buildDivider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 64.0),
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            FontAwesomeIcons
                                .google, // Using FontAwesomeIcons for Google icon
                            color: Colors.white, // Icon color
                          ),
                          label: const Text(
                              ''), // No text, as you want only the icon
                          onPressed: () {
                            signInWithGoogle();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.red, // Background color - Google's red
                            shape:
                                const CircleBorder(), // Make the button circular
                            padding: const EdgeInsets.all(
                                20), // Padding to ensure the button is large enough to enclose the icon
                            minimumSize: const Size(
                                56, 56), // Set a minimum size for the button
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
