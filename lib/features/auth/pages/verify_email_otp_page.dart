import 'package:flutter/material.dart';

class VerifyEmailOtpPage extends StatelessWidget {
  const VerifyEmailOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: const Center(
        child: Text('This feature is handled via email link now.'),
      ),
    );
  }
}
