import 'package:flutter/material.dart';
import 'package:practise/Screens/componets/constants.dart';
import 'package:practise/Screens/componets/widgets.dart';

class BookingPage extends StatefulWidget {
  BookingPage({
    super.key,
  });
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _passengerCountController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now(); // ← الوقت التلقائي الحالي
  }

  final _formKey = GlobalKey<FormState>();

  String? _fromCity;
  String? _toCity;
  DateTime? _selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "حجز رحلة",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // الصورة أعلى الحقول
              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.4),
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
              buildPassengerCountField(controller: _passengerCountController),
              SizedBox(height: 16),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  label: Text(
                    "تأكيد الحجز",
                    style: TextStyle(
                        color: TextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_fromCity == _toCity) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "⚠️ لا يمكن اختيار نفس المدينة للانطلاق والوصول")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "✅ تمت , سيتم إرسال إشعار لك في حال توفر الرحلة")),
                        );
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
