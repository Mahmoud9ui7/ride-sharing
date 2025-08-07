import 'package:flutter/material.dart';
import 'package:practise/Models/ride_model.dart';
import 'package:practise/Screens/componets/constants.dart';

class RideCard extends StatelessWidget {
  final Ride ride;

  const RideCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: primaryColor,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(
                  ride.driverName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      ride.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, color: primaryColor),
                const SizedBox(width: 6),
                Text('الوجهة: ${ride.destination}'),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time, color: primaryColor),
                const SizedBox(width: 6),
                Text('الوقت: ${ride.time}'),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.attach_money, color: primaryColor),
                const SizedBox(width: 6),
                Text('السعر: ${ride.price} دينار سوري'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
