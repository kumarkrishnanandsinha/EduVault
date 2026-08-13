import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main_screen.dart';

import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

class EduVaultApp extends StatelessWidget {
  const EduVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "EduVault",
      theme: AppTheme.lightTheme,

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasData) {
            return const MainScreen();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}