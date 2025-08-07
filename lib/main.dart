import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practise/Screens/Auth/LoginScreen.dart';
import 'package:practise/Screens/Auth/RegisterScreen.dart';
import 'package:practise/Screens/Auth/components/email_verification_screen.dart';
import 'package:practise/Screens/Splash/SplashScreen.dart';
import 'package:practise/Screens/componets/constants.dart';
import 'package:practise/Screens/home/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("🔥 Firebase Initialized");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('==========================User is currently signed out!');
      } else {
        print('==========================User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تسجيل دخول',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 214, 214, 212),
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
              color: primaryColor,
              centerTitle: true,
              titleTextStyle: TextStyle(color: TextColor))),
      initialRoute: '/Splash',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/Splash': (context) => SplashScreen(),
        '/verify-email': (context) => EmailVerificationScreen(),
        '/home': (context) => HomeScreen(),
      },
      locale: Locale('ar'),
      home: LoginScreen(),
    );
  }
}
