import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_amplify/services/analytics_events.dart';
import 'package:flutter_amplify/services/analytics_service.dart';
import 'package:flutter_amplify/services/auth_credentials.dart';

class SignupScreen extends StatefulWidget {
  final ValueChanged<SignupCredentials> didProvideCredentials;
  final VoidCallback shouldShowLogin;

  SignupScreen({Key? key, required this.didProvideCredentials, required this.shouldShowLogin}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 40),
          child: Stack(children: [
            _signUpForm(),

            Container(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                  onPressed: widget.shouldShowLogin,
                  child: Text('¿Ya tienes una cuenta? Inicia sesión')),
            )
          ],
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration( icon: Icon( Icons.person ), labelText: 'Nombre de usuario', ),
        ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration( icon: Icon( Icons.mail ), labelText: 'Correo electrónico', ),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration( icon: Icon( Icons.lock_open ), labelText: 'Contraseña', ),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),
        ElevatedButton(
          onPressed: _signUp,
          child: Text( 'Regístrate' ),
        ),
      ],
    );
  }

  void _signUp() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final credentials = SignupCredentials(
      username: username,
      password: password,
      email: email
    );

    widget.didProvideCredentials( credentials );
    AnalyticsService.log( SignupEvent() );
  }
}