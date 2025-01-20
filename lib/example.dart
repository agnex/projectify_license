import 'package:flutter/material.dart';
import 'package:projectify_license/projectify_license.dart';

class MyApp extends StatelessWidget {
  final ProjectifyAnimation animationHandler = ProjectifyAnimation();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Projectify Animations')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            animationHandler.serveAnimation(
              animationName: 'example_animation',
              fallbackWidget: Icon(Icons.error, color: Colors.red, size: 48),
            ),
            SizedBox(height: 20),
            PText(
              'Powered by Poppins',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
