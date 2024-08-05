import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maya/src/config/events.dart';
import 'package:maya/src/screens/home/home_page.dart';
import 'package:maya/src/utils/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1.0;
  String _errorMessage = '';
  bool _isLoggedIn = true;
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  void _checkAuthState() {
    Auth().authStateChanges.listen((User? user) {
      if (user != null) {
        _navigateToHome();
      } else {
        setState(() {
          _isLoggedIn = false;
        });
      }
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      await Auth().signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? '';
      });
      Events().googleLoginError(e.message ?? e.code);
    }
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _opacity = 0.0;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 500),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/maya_glitter.png',
                        width: 200.0, fit: BoxFit.cover),
                    Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Image.asset('assets/images/maya_text.png',
                            width: 200.0, fit: BoxFit.cover)),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32.0, horizontal: 24.0),
                        child: ShaderMask(
                          shaderCallback: (bounds) => RadialGradient(
                            center: Alignment.center,
                            radius: 1.0,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ], // Define your gradient colors here
                            tileMode: TileMode.mirror,
                          ).createShader(bounds),
                          blendMode: BlendMode
                              .srcIn, // This blend mode applies the shader to the text color
                          child: Text(
                            'Stroboscopic light therapies',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                        )),
                    const SizedBox(height: 84.0),
                    if (!_isLoggedIn)
                      ElevatedButton(
                        onPressed: signInWithGoogle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 48.0),
                        ),
                        child: Text('Sign in with Google',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                )),
                      ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
