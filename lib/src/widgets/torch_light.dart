import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:torch_light/torch_light.dart';

class TorchLightWidget extends StatefulWidget {
  const TorchLightWidget({super.key});

  @override
  TorchLightWidgetState createState() => TorchLightWidgetState();
}

class TorchLightWidgetState extends State<TorchLightWidget> {
  late bool isAvailable = false;
  late bool isTorchOn = false;

  @override
  void initState() {
    super.initState();
    initTorch();
  }

  Future<void> initTorch() async {
    try {
      isAvailable = await TorchLight.isTorchAvailable();
      if (isAvailable) {
        await disableTorch();
        isTorchOn = false;
      }
      setState(() {});
    } on Exception catch (e, stackTrace) {
      // Handle error
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stackTrace,
        library: 'torch light library',
        context: ErrorDescription('while checking torch availability'),
      ));
    }
  }

  Future<void> enableTorch() async {
    // Enable torch and manage all kind of errors
    try {
      print('Toggle torch');
      await TorchLight.enableTorch();
    } on EnableTorchExistentUserException catch (e) {
      // The camera is in use
    } on EnableTorchNotAvailableException catch (e) {
      // Torch was not detected
    } on EnableTorchException catch (e) {
      // Torch could not be enabled due to another error
    }
  }

  Future<void> disableTorch() async {
    try {
      await TorchLight.disableTorch();
    } on DisableTorchExistentUserException catch (e) {
      // The camera is in use
    } on DisableTorchNotAvailableException catch (e) {
      // Torch was not detected
    } on DisableTorchException catch (e) {
      // Torch could not be disabled due to another error
    }
  }

  Future<void> toggleTorch() async {
    if (isTorchOn) {
      await disableTorch();
    } else {
      await enableTorch();
    }
    isTorchOn = !isTorchOn;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Torch light'),
              const SizedBox(height: 20),
              Text(
                isAvailable ? 'Torch is available' : 'Torch is not available',
                style: TextStyle(
                    color: isAvailable ? Colors.green : Colors.red,
                    fontWeight: FontWeight.normal,
                    fontSize: 16),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                  onPressed: isAvailable
                      ? () async {
                          await toggleTorch();
                        }
                      : null,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: isAvailable ? Colors.blue : Colors.grey),
                  ),
                  child: const Text('Toggle Torch'))
            ],
          )),
    );
  }
}
