import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/plant_service.dart';
import 'services/theme_service.dart';
import 'services/chatbot_service.dart';
import 'services/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/chatbot_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => PlantService()),
              ChangeNotifierProvider(create: (_) => ThemeService()),
              Provider(create: (_) => AuthService()),
              Provider(
                create: (_) => ChatbotService(
                  apiKey: 'AIzaSyB1s1nouKZ1AnDEbne9D2J4CvChnRDIeDw',
                ),
              ),
            ],
            child: Consumer<ThemeService>(
              builder: (context, themeService, child) {
                return MaterialApp(
                  title: 'Plant Care',
                  debugShowCheckedModeBanner: false,
                  theme: themeService.theme,
                  initialRoute: '/',
                  routes: {
                    '/': (context) => const SplashScreen(),
                    '/login': (context) => const LoginScreen(),
                    '/register': (context) => const RegisterScreen(),
                    '/home': (context) => const HomeScreen(),
                    '/settings': (context) => const SettingsScreen(),
                    '/chatbot': (context) => const ChatbotScreen(
                        apiKey: 'AIzaSyB1s1nouKZ1AnDEbne9D2J4CvChnRDIeDw'),
                  },
                );
              },
            ),
          );
        }
        // Show a loading indicator while Firebase initializes
        return const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
