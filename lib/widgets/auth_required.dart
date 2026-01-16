import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_controller.dart';
import '../screens/auth/login_screen.dart';

/// Widget wrapper that requires authentication
/// Redirects to login screen if user is not authenticated
class AuthRequired extends StatelessWidget {
  final Widget child;

  const AuthRequired({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    if (!authController.isAuthenticated) {
      // Not authenticated - redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Authenticated - show the child widget
    return child;
  }
}
