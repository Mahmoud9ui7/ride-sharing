import 'dart:convert';

import 'package:practise/Models/ride_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
 

class RideStorage {
  static const String key = 'saved_rides';

  static Future<void> saveRide(Ride ride) async {
    final prefs = await SharedPreferences.getInstance();
    final rides = await getRides();
    rides.add(ride);
    final encoded = rides.map((r) => json.encode(r.toJson())).toList();
    await prefs.setStringList(key, encoded);
  }

  static Future<List<Ride>> getRides() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(key) ?? [];
    return encoded.map((e) => Ride.fromJson(json.decode(e))).toList();
  }

  static Future<void> clearExpiredRides() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final rides = await getRides();
    final validRides = rides.where((r) => r.departureDateTime.isAfter(now)).toList();
    final encoded = validRides.map((r) => json.encode(r.toJson())).toList();
    await prefs.setStringList(key, encoded);
  }
}
