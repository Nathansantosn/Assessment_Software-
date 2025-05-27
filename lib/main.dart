import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assessment_software/screens/auth/login_screen.dart';
import 'package:assessment_software/screens/auth/register_screen.dart';
import 'package:assessment_software/screens/home/tester_home.dart';
import 'package:assessment_software/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: MaterialApp(
        title: 'Assessment Software',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          cardTheme: CardThemeData(
            elevation: 4,
            margin: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const TesterHomeScreen(),
        },
        home: Consumer<AuthService>(
          builder: (context, auth, child) {
            if (auth.isLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return auth.currentUser == null
                ? const LoginScreen()
                : const TesterHomeScreen();
          },
        ),
      ),
    );
  }
}
