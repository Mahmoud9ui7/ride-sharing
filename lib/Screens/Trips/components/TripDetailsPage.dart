import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practise/Models/ride_model.dart';
import 'package:practise/Screens/componets/constants.dart';

class TripDetailsPage extends StatefulWidget {
  final Ride ride;

  const TripDetailsPage({super.key, required this.ride});

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  late Timer _timer;
  late Duration remainingTime;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    remainingTime = widget.ride.departureDateTime.difference(DateTime.now());

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final newDuration =
          widget.ride.departureDateTime.difference(DateTime.now());

      if (newDuration.isNegative) {
        timer.cancel();
        setState(() {
          remainingTime = Duration.zero;
        });
      } else {
        setState(() {
          remainingTime = newDuration;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('yyyy-MM-dd – kk:mm').format(widget.ride.departureDateTime);

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الرحلة'),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 10,
            shadowColor: primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(Icons.directions_car,
                        size: 60, color: primaryColor),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(Icons.person, "السائق", widget.ride.driverName),
                  _buildInfoRow(Icons.location_on, "من", widget.ride.fromCity),
                  _buildInfoRow(Icons.flag, "الوجهة", widget.ride.destination),
                  _buildInfoRow(Icons.access_time, "الوقت", widget.ride.time),
                  _buildInfoRow(
                      Icons.attach_money, "السعر", "${widget.ride.price} ل.س"),
                  _buildInfoRow(
                      Icons.star, "التقييم", widget.ride.rating.toString()),
                  _buildInfoRow(
                      Icons.date_range, "تاريخ الانطلاق", formattedDate),
                  const SizedBox(height: 25),

                  // ✅ العداد العصري مع الأسابيع والأيام
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "العد التنازلي حتى الانطلاق",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        remainingTime.inSeconds > 0
                            ? Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                alignment: WrapAlignment.center,
                                children: _buildCountdownBoxes(remainingTime),
                              )
                            : Column(
                                children: [
                                  Icon(Icons.check_circle,
                                      color: Colors.green, size: 40),
                                  SizedBox(height: 8),
                                  Text(
                                    "! انطلقت الرحلة",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: primaryColor),
          const SizedBox(width: 10),
          Text("$label: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  List<Widget> _buildCountdownBoxes(Duration duration) {
    int totalDays = duration.inDays;
    int weeks = totalDays ~/ 7;
    int days = totalDays % 7;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    final units = <Map<String, dynamic>>[];

    if (weeks > 0) units.add({"value": weeks, "label": "أسابيع"});
    if (days > 0 || weeks > 0) units.add({"value": days, "label": "أيام"});
    units.add({"value": hours, "label": "ساعات"});
    units.add({"value": minutes, "label": "دقائق"});
    units.add({"value": seconds, "label": "ثواني"});

    return units
        .map((unit) => _buildTimeBox(
            unit["value"].toString().padLeft(2, '0'), unit["label"]))
        .toList();
  }

  Widget _buildTimeBox(String value, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        )
      ],
    );
  }
}
