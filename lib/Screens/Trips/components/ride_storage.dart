import 'dart:convert';

import 'package:practise/Models/ride_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RideStorage {
  static const String key = 'saved_rides';

  /// ✅ إضافة رحلة جديدة وتحديث التخزين
  static Future<void> saveRide(Ride ride) async {
    final rides = await getRides();
    rides.add(ride);
    await saveRides(rides); // 🟢 استخدم الدالة الموحّدة
  }

  /// ✅ استرجاع جميع الرحلات من التخزين
  static Future<List<Ride>> getRides() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return [];

    try {
      final List<dynamic> decoded = json.decode(jsonString);
      return decoded.map((item) => Ride.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  /// ✅ حذف الرحلات التي انتهى وقتها
  static Future<void> clearExpiredRides() async {
    final now = DateTime.now();
    final rides = await getRides();
    final validRides =
        rides.where((r) => r.departureDateTime.isAfter(now)).toList();
    await saveRides(validRides);
  }

  /// ✅ حذف رحلة حسب الفهرس
  static Future<void> deleteRideAt(int index) async {
    final rides = await getRides();
    if (index >= 0 && index < rides.length) {
      rides.removeAt(index);
      await saveRides(rides);
    }
  }

  /// ✅ حفظ جميع الرحلات دفعة واحدة
  static Future<void> saveRides(List<Ride> rides) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = rides.map((ride) => ride.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await prefs.setString(key, jsonString);
  }
}
