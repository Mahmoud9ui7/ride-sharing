import 'package:flutter/material.dart';
import 'package:practise/Screens/Adding/AddTrip.dart';
import 'package:practise/Screens/Trips/TripDetailsPage.dart';
import 'package:practise/Screens/Trips/ride_storage.dart';
import 'package:practise/constants.dart';

import '../../Models/ride_model.dart';
import 'widgets/ride_card.dart';

class AvailableTripsPage extends StatefulWidget {
  const AvailableTripsPage({super.key});

  @override
  State<AvailableTripsPage> createState() => _AvailableTripsPageState();
}

class _AvailableTripsPageState extends State<AvailableTripsPage> {
  List<Ride> rides = [];

  @override
  void initState() {
    super.initState();
    loadRides();
  }

  Future<void> loadRides() async {
    await RideStorage.clearExpiredRides(); // حذف المنتهية
    final data = await RideStorage.getRides();
    setState(() => rides = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTripPage()),
          );
          loadRides();
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, size: 30, color: TextColor),
      ),
      appBar: AppBar(title: const Text('الرحلات المتوفرة')),
      body: rides.isEmpty
          ? const Center(child: Text("لا توجد رحلات حالياً"))
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: rides.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TripDetailsPage(ride: rides[index]),
                      ),
                    );
                  },
                  child: RideCard(ride: rides[index]),
                ),
              ),
            ),
    );
  }
}
