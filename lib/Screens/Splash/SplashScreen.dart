import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:practise/Screens/Auth/LoginScreen.dart';
import 'package:practise/main.dart';
import 'package:rive/rive.dart';

class SplashScreen0 extends StatefulWidget {
  @override
  _SplashScreen0State createState() => _SplashScreen0State();
}

class _SplashScreen0State extends State<SplashScreen0>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _subtitleController;
  late Animation<Offset> _titleOffsetAnimation;
  late Animation<double> _subtitleOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _subtitleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _titleOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOut,
    ));

    _subtitleOpacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _subtitleController,
      curve: Curves.easeIn,
    ));

    _titleController.forward();
    _subtitleController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 700),
            pageBuilder: (_, __, ___) =>
                FirebaseAuth.instance.currentUser == null
                    ? LoginScreen()
                    : HomeScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
          (context) => false);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            const RiveAnimation.asset(
              'assets/rive/car_interface.riv',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: flutter.LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.4),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _titleOffsetAnimation,
                    child: Text(
                      'RideX',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2.5,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.blueAccent.withOpacity(0.7),
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _subtitleOpacityAnimation,
                    child: const Text(
                      'معك في كل خطوة ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
