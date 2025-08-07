import 'package:flutter/material.dart';
import 'package:practise/Screens/Booking/BookingTrip.dart';
import 'package:practise/Screens/Profile/Profile.dart';
import 'package:practise/Screens/Trips/Trips.dart';
import 'package:practise/Screens/componets/constants.dart';

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
