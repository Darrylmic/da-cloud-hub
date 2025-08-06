import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Da Cloud Hub'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Welcome to Da Cloud Hub!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
