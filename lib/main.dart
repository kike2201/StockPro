
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const StockProApp());
}

class StockProApp extends StatelessWidget {
  const StockProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF17324D),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),

      // Control de acceso mediante Firebase Authentication
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'Error al verificar la sesión de Firebase.',
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            return const HomePage();
          }

          return const LoginPage();
        },
      ),
    );
  }
}
