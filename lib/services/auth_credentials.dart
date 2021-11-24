abstract class AuthCredentials {
  final String username;
  final String password;

  AuthCredentials({required this.username, required this.password});
}

class LoginCredentials extends AuthCredentials {
  LoginCredentials({required String username, required String password})
      : super(username: username, password: password);
}

class SignupCredentials extends AuthCredentials {
  final String email;

  SignupCredentials({required String username, required String password, required this.email})
      : super(username: username, password: password);
}