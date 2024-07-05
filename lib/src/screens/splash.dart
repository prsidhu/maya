import 'package:flutter/material.dart';
import 'package:morpheus/src/widgets/text/logo_text.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/maya_logo.png',
                      width: 200.0, fit: BoxFit.cover),
                  Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: LogoText(
                        textStyle: Theme.of(context).textTheme.headlineLarge,
                        alignment: MainAxisAlignment.center,
                      )),
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
                          'Psychedelic light therapies for sleep & meditation',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                      )),
                ],
              ),
            )),
      ),
    );
  }
}
