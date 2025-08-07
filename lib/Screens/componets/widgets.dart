import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<String> syrianCities = [
  'دمشق',
  'حلب',
  'حمص',
  'حماة',
  'اللاذقية',
  'طرطوس',
  'السويداء',
  'دير الزور',
  'الرقة',
  'الحسكة'
];

Widget buildDropdownField({
  required String label,
  required IconData icon,
  required String? value,
  required void Function(String?) onChanged,
}) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueGrey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
    items: syrianCities.map((city) {
      return DropdownMenuItem(value: city, child: Text(city));
    }).toList(),
    value: value,
    onChanged: onChanged,
    validator: (val) => val == null ? 'يرجى اختيار $label' : null,
  );
}

Widget buildDateTimeField({
  required BuildContext context,
  required DateTime? selectedDateTime,
  required Function(DateTime) onDateTimePicked,
}) {
  final dateTimeFormat = DateFormat('yyyy-MM-dd – HH:mm');
  return TextFormField(
    readOnly: true,
    controller: TextEditingController(
      text: selectedDateTime != null
          ? dateTimeFormat.format(selectedDateTime)
          : '',
    ),
    decoration: InputDecoration(
      labelText: "التاريخ والوقت",
      prefixIcon: Icon(Icons.access_time, color: Colors.blueGrey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
    onTap: () async {
      final now = DateTime.now();
      final date = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: now.add(Duration(days: 30)),
      );
      if (date != null) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          final selected = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          onDateTimePicked(selected);
        }
      }
    },
    validator: (val) {
      if (selectedDateTime == null) return 'يرجى اختيار التاريخ والوقت';
      final now = DateTime.now();
      final maxDate = now.add(Duration(days: 30));
      if (selectedDateTime.isBefore(now) || selectedDateTime.isAfter(maxDate)) {
        return 'اختر تاريخاً بين اليوم وشهر للأمام';
      }
      return null;
    },
  );
}

Widget buildPriceField({
  required TextEditingController controller,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: "السعر لكل راكب (\$)",
      prefixIcon: Icon(Icons.attach_money, color: Colors.blueGrey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
    validator: (val) {
      if (val == null || val.isEmpty) return 'يرجى إدخال السعر';
      final price = double.tryParse(val);
      if (price == null || price < 1 || price > 15) {
        return 'السعر يجب أن يكون بين 1 و 15 دولار';
      }
      return null;
    },
  );
}

Widget buildPassengerCountField({
  required TextEditingController controller,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: "عدد الركاب",
      prefixIcon: Icon(Icons.person, color: Colors.blueGrey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
    validator: (val) {
      if (val == null || val.isEmpty) return 'يرجى إدخال عدد الركاب';
      final count = int.tryParse(val);
      if (count == null || count < 1 || count > 20) {
        return 'عدد الركاب يجب أن يكون بين 1 و 20';
      }
      return null;
    },
  );
}
