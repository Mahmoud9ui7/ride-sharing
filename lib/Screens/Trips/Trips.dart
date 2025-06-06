import 'package:flutter/material.dart';
import '../../Models/ride_model.dart';
import 'widgets/ride_card.dart';

class AvailableTripsPage extends StatelessWidget {
  AvailableTripsPage({super.key});

  final List<Ride> rides = List.generate(
    20,
    (index) => Ride(
      driverName: ['أحمد', 'مروان', 'لانا', 'جود', 'هبة'][index % 5],
      destination: ['دمشق', 'حلب', 'حمص', 'اللاذقية', 'طرطوس'][index % 5],
      time: '${4 + (index % 8)}:${(index * 7) % 60} م',
      price: 5000 + (index * 700) % 8000, // بالليرة السورية
      rating: (4.5 + (index % 5) * 0.1).clamp(0, 5).toDouble(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرحلات المتوفرة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: rides.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: RideCard(ride: rides[index]),
          ),
        ),
      ),
    );
  }
}
