import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practise/Models/ride_model.dart';
import 'package:practise/Screens/Trips/components/ride_storage.dart';
import 'package:practise/Screens/componets/constants.dart';

import '../componets/widgets.dart';

class AddTripPage extends StatefulWidget {
  const AddTripPage({super.key});

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final _formKey = GlobalKey<FormState>();

  String? _fromCity;
  String? _toCity;
  DateTime? _selectedDateTime = DateTime.now();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _passengerCountController =
      TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    _passengerCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "إضافة رحلة",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/app_icon1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              buildDropdownField(
                label: "مكان الانطلاق",
                icon: Icons.location_on,
                value: _fromCity,
                onChanged: (value) => setState(() => _fromCity = value),
              ),
              SizedBox(height: 16),
              buildDropdownField(
                label: "مكان الوصول",
                icon: Icons.flag,
                value: _toCity,
                onChanged: (value) => setState(() => _toCity = value),
              ),
              SizedBox(height: 16),
              buildDateTimeField(
                context: context,
                selectedDateTime: _selectedDateTime,
                onDateTimePicked: (dt) =>
                    setState(() => _selectedDateTime = dt),
              ),
              SizedBox(height: 16),
              buildPriceField(controller: _priceController),
              SizedBox(height: 16),
              buildPassengerCountField(controller: _passengerCountController),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  label: Text(
                    "تأكيد الإضافة",
                    style: TextStyle(
                        color: TextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_fromCity == _toCity) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("⚠️ لا يمكن اختيار نفس المدينة")),
                        );
                      } else {
                        Ride newRide = Ride(
                          driverName: "أنت",
                          fromCity: _fromCity!,
                          destination: _toCity!,
                          time:
                              DateFormat('hh:mm a').format(_selectedDateTime!),
                          price: double.tryParse(_priceController.text) ?? 0,
                          rating: 5.0,
                          departureDateTime: _selectedDateTime!,
                        );

                        await RideStorage.saveRide(newRide);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("✅تمت إضافة الرحلة")),
                        );
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttuncolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
