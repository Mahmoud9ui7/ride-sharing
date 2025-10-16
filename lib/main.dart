import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:practise/Screens/Auth/LoginScreen.dart';
import 'package:practise/Screens/Auth/RegisterScreen.dart';
import 'package:practise/Screens/Auth/components/email_verification_screen.dart';
import 'package:practise/Screens/Profile/Components/theme_controller.dart';
import 'package:practise/Screens/Splash/SplashScreen.dart';
import 'package:practise/Screens/componets/constants.dart';
import 'package:practise/Screens/home/homepage.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("🔥 Firebase Initialized");

  Get.put(ThemeController());

  await initializeNotifications();

  runApp(const MyApp());
}

// ==================== Notifications ====================
Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotification({
  String title = 'مرحبًا بك في التطبيق',
  String body = ' :) ما رأيك أن تسجل الدخول',
}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'login_channel',
    'Login Notifications',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
  );
}

// ==================== MyApp ====================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // التحقق من حالة تسجيل الدخول
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('================ User is signed out');
        showNotification();
      } else {
        print('================ User is signed in');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'تسجيل دخول',

          // Theme settings
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color.fromARGB(255, 214, 214, 212),
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
              backgroundColor: primaryColor,
              centerTitle: true,
              titleTextStyle: TextStyle(color: Colors.white),
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: themeController.themeMode.value,

          // Routes
          initialRoute: '/Splash',
          routes: {
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/Splash': (context) => SplashScreen(),
            '/verify-email': (context) => const EmailVerificationScreen(),
            '/home': (context) => HomeScreen(),
          },
        ));
  }
}
