import 'package:flutter/material.dart';
import 'package:flutter_amplify/services/analytics_events.dart';
import 'package:flutter_amplify/services/analytics_service.dart';

class VerificationScreen extends StatefulWidget {
  final ValueChanged<String> didProvideVerificationCode;

  VerificationScreen({Key? key, required this.didProvideVerificationCode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _verificationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 40),
        child: _verificationForm(),
      ),
    );
  }

  Widget _verificationForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Verification Code TextField
        TextField(
          controller: _verificationCodeController,
          decoration: InputDecoration(
              icon: Icon(Icons.confirmation_number),
              labelText: 'Verification code'),
        ),

        // Verify Button
        ElevatedButton(
            onPressed: _verify,
            child: Text('Verify'),
        ),
      ],
    );
  }

  void _verify() {
    final verificationCode = _verificationCodeController.text.trim();
    widget.didProvideVerificationCode(verificationCode);
    AnalyticsService.log( VerificationEvent() );
  }
}