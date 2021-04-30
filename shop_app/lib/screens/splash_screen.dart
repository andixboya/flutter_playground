import 'package:flutter/material.dart';

// 277) screen shown while loading when it attempts to auto login!
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
