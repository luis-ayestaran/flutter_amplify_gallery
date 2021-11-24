import 'dart:async';
import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_amplify/services/auth_credentials.dart';

enum AuthFlowStatus { login, signup, verification, session, }

class AuthState {
  final AuthFlowStatus authFlowStatus;

  AuthState({ required this.authFlowStatus });
}

class AuthService {
  final authStateController = StreamController<AuthState>();
  late AuthCredentials _credentials;

  void showSignup() {
    final state = AuthState( authFlowStatus: AuthFlowStatus.signup );
    authStateController.add( state );
  }

  void showLogin() {
    final state = AuthState( authFlowStatus: AuthFlowStatus.login );
    authStateController.add( state );
  }

  void loginWithCredentials( AuthCredentials credentials ) async {
    try {
      log( 'username: ${credentials.username}' 
        'password: ${credentials.password}'
      );

      log( 'Comienzo inicio de sesión' );

      final result = await Amplify.Auth.signIn(
        username: credentials.username,
        password: credentials.password
      );

      log( 'Fin de inicio de sesión' );

      if( result.isSignedIn ) {
        log( 'Inicio la sesión' );
        final state = AuthState( authFlowStatus: AuthFlowStatus.session );
        authStateController.add( state );
      } else {
        log( 'No se pudo iniciar sesión.' );
      }
    } on AuthException catch( authException ) {
      log( 'No se pudo iniciar sesión - ${authException.message}' );
    }
  }

  void signupWithCredentials( SignupCredentials credentials ) async {
    try {
      final userAttributes = { 'email' : credentials.email };

      log( 'email: ${credentials.email}' );

      final result = await Amplify.Auth.signUp(
        username: credentials.username,
        password: credentials.password,
        options: CognitoSignUpOptions( userAttributes: userAttributes ),
      );

      log( 'username: ${credentials.username}\n'
        'password: ${credentials.password}\n'
        'Signup complete: ${result.isSignUpComplete}'
      );

      /*if( result.isSignUpComplete ) {
        loginWithCredentials( credentials );
      } else {*/
        this._credentials = credentials;
        final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
        authStateController.add( state );
        log( 'Me muevo a la pantalla de verificación.' );
      //}

    } on AuthException catch( authException ) {
      log( 'Error al registrar el nuevo usuario \n'
        '${authException.message}\n'
        '${authException.recoverySuggestion}'
        '${authException.underlyingException}\n'
      );
    }
  }

  void verifyCode( String verificationCode ) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: _credentials.username,
        confirmationCode: verificationCode,
      );
      if( result.isSignUpComplete ) {
        loginWithCredentials( _credentials );
      } else {

      }
    } on AuthException catch( authException ) {
      print('No se pudo verificar el código - ${authException.message}');
      log( 'No se pudo verificar el código \n'
        '${authException.message}\n'
        '${authException.recoverySuggestion}'
        '${authException.underlyingException}\n'
      );
    }
  }

  void logout() async {
    try {
      await Amplify.Auth.signOut();
      showLogin();
    } on AuthException catch( authException ) {
      print( 'No se pudo cerrar la sesión - ${authException.message}' );
    }
  }

  void checkAuthStatus() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      log( '$session' );

      final state = AuthState( authFlowStatus: AuthFlowStatus.session );
      authStateController.add( state );
    } catch(_) {
      log( 'OCURRIÓ UN ERROR.\n$_' );
      final state = AuthState( authFlowStatus: AuthFlowStatus.login );
      authStateController.add( state );
    }
  }
}