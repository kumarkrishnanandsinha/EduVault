import 'package:flutter/material.dart';

class MyUploadsScreen extends StatelessWidget {
  const MyUploadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Uploads"),
      ),
      body: const Center(
        child: Text(
          "No uploads yet.",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}