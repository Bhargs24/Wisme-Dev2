import 'package:flutter/material.dart';

void main() {
  runApp(const SimpleTestApp());
}

class SimpleTestApp extends StatelessWidget {
  const SimpleTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wisme Test',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wisme App - Basic Test'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Wisme App is Loading...',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('If you see this, basic Flutter setup works!'),
            ],
          ),
        ),
      ),
    );
  }
}
