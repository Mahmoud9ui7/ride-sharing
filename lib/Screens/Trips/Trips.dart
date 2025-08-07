import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practise/Screens/Adding/AddTrip.dart';
import 'package:practise/Screens/Trips/components/TripDetailsPage.dart';
import 'package:practise/Screens/Trips/components/ride_storage.dart';
import 'package:practise/Screens/componets/constants.dart';
import 'package:practise/Screens/componets/navigateWithFade.dart';

import '../../Models/ride_model.dart';
import 'widgets/ride_card.dart';

class AvailableTripsPage extends StatefulWidget {
  const AvailableTripsPage({super.key});

  @override
  State<AvailableTripsPage> createState() => _AvailableTripsPageState();
}

class _AvailableTripsPageState extends State<AvailableTripsPage> {
  List<Ride> _rides = [];
  final DateFormat _timeFormatter = DateFormat("hh:mm a");

  @override
  void initState() {
    super.initState();
    _loadRides();
  }

  Future<void> _loadRides() async {
    await RideStorage.clearExpiredRides();
    final data = await RideStorage.getRides();

    final now = DateTime.now();

    data.sort((a, b) {
      final dateTimeA = _combineDateWithTime(now, a.time);
      final dateTimeB = _combineDateWithTime(now, b.time);
      return dateTimeB.compareTo(dateTimeA); // ترتيب تنازلي
    });

    setState(() {
      _rides = data;
    });
  }

  DateTime _combineDateWithTime(DateTime date, String timeStr) {
    final parsedTime = _timeFormatter.parse(timeStr);
    return DateTime(
      date.year,
      date.month,
      date.day,
      parsedTime.hour,
      parsedTime.minute,
    );
  }

  Future<void> _deleteRide(int index) async {
    setState(() {
      _rides.removeAt(index); // حذف من القائمة
    });
    await RideStorage.saveRides(_rides); // حفظ القائمة المعدّلة

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حذف الرحلة')),
    );
  }

  Future<void> _navigateToAddTrip() async {
    AnimationPush(context, AddTripPage());
    await _loadRides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(title: const Text('الرحلات المتوفرة')),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTrip,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, size: 30, color: TextColor),
      ),
      body: _rides.isEmpty
          ? const Center(
              child: Text(
                "لا توجد رحلات حالياً",
                style: TextStyle(fontSize: 18),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadRides,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  itemCount: _rides.length,
                  itemBuilder: (context, index) {
                    final ride = _rides[index];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) => _deleteRide(index),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TripDetailsPage(ride: ride),
                            ),
                          );
                        },
                        child: RideCard(ride: ride),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
