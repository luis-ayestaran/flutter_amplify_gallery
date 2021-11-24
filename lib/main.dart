import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify/amplifyconfiguration.dart';
import 'package:flutter_amplify/screens/camera/camera_flow.dart';
import 'package:flutter_amplify/screens/login_screen.dart';
import 'package:flutter_amplify/screens/signup_screen.dart';
import 'package:flutter_amplify/screens/verification_screen.dart';
import 'package:flutter_amplify/services/auth_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _amplify = Amplify;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery App',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      home: StreamBuilder<AuthState>(
        stream: _authService.authStateController.stream,
        //initialData: AuthState( authFlowStatus: AuthFlowStatus.login ),
        builder: (context, snapshot) {
          if( snapshot.hasData ) {
            return Navigator(
              pages: [
                if( snapshot.data!.authFlowStatus == AuthFlowStatus.login )
                  MaterialPage( child: LoginScreen(
                    didProvideCredentials: _authService.loginWithCredentials,
                    shouldShowSignup: _authService.showSignup, 
                  ), ),
                
                if( snapshot.data!.authFlowStatus == AuthFlowStatus.signup )
                  MaterialPage( child: SignupScreen(
                    didProvideCredentials: _authService.signupWithCredentials,
                    shouldShowLogin: _authService.showLogin,
                  ), ),

                if( snapshot.data!.authFlowStatus == AuthFlowStatus.verification )
                  MaterialPage( child: VerificationScreen(
                    didProvideVerificationCode: _authService.verifyCode,
                  ), ),

                if( snapshot.data!.authFlowStatus == AuthFlowStatus.session )
                  MaterialPage(child: CameraFlow(
                    shouldLogout: _authService.logout,
                  ), ),
              ],
              onPopPage: (route, result) => route.didPop(result),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  void _configureAmplify() async {

    _amplify.addPlugins([
      AmplifyAuthCognito(),
      AmplifyStorageS3(),
      AmplifyAnalyticsPinpoint(),
    ],);
    try {
      await _amplify.configure(amplifyconfig);
      _authService.checkAuthStatus();
      print('Successfully configured Amplify 🎉');
    } catch (e) {
      print('Could not configure Amplify ☠️');
    }
  }
}