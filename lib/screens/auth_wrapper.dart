import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'home/home_screen.dart';
import 'auth/email_verification_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        switch (authProvider.status) {
          case AuthStatus.uninitialized:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          case AuthStatus.authenticated:
            return const HomeScreen();

          case AuthStatus.emailNotVerified:
            return const EmailVerificationScreen();

          case AuthStatus.unauthenticated:
          case AuthStatus.authenticating:
          default:
            return const LoginScreen();
        }
      },
    );
  }
}
