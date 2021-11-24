import 'package:flutter/material.dart';
import 'package:flutter_amplify/services/analytics_events.dart';
import 'package:flutter_amplify/services/analytics_service.dart';
import 'package:flutter_amplify/services/auth_credentials.dart';

class LoginScreen extends StatefulWidget {
  final ValueChanged<LoginCredentials> didProvideCredentials;
  final VoidCallback shouldShowSignup;

  LoginScreen({Key? key, required this.didProvideCredentials, required this.shouldShowSignup}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric( horizontal: 40, ),
        child: Stack(
          children: [
            _logInForm(),
            Container(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                child: Text( '¿Aún no tienes una cuenta? Regístrate' ),
                onPressed: widget.shouldShowSignup,
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _logInForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            icon: Icon( Icons.mail ),
            labelText: 'Nombre de usuario',
          ),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            icon: Icon( Icons.lock_open ),
            labelText: 'Contraseña',
          ),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),
        ElevatedButton(
          onPressed: _logIn,
          child: Text( 'Inicia sesión' ),
        ),
      ],
    );
  }

  void _logIn() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    print( 'username $username' );
    print( 'password $password' );
    final credentials = LoginCredentials(
      username: username, 
      password: password
    );

    widget.didProvideCredentials( credentials );
    AnalyticsService.log( LoginEvent() );
  }
}