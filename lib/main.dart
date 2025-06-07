import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practise/Screens/Auth/LoginScreen.dart';
import 'package:practise/Screens/Auth/RegisterScreen.dart';
import 'package:practise/Screens/Booking/BookingTrip.dart';
import 'package:practise/Screens/Profile/Profile.dart';
import 'package:practise/Screens/Splash/SplashScreen.dart';
import 'package:practise/Screens/Trips/Trips.dart';
import 'package:practise/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
              color: primaryColor,
              centerTitle: true,
              titleTextStyle: TextStyle(color: TextColor))),
      initialRoute: '/Splash',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/Splash': (context) => SplashScreen0(),
        '/home': (context) => HomeScreen(), // أضفنا هذا السطر
      },
      locale: Locale('ar'),
      home: LoginScreen(),
    );
  }
}

// الشاشة الرئيسية التي تحتوي على BottomNavigationBar
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    Center(child: AvailableTripsPage()),
    Center(child: BookingPage()),
    Center(child: ProfilePage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'الرحلات'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book_online), label: 'حجز رحلة'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'البروفايل'),
        ],
      ),
    );
  }
}
