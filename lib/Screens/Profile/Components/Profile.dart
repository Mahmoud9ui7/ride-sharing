import 'package:flutter/material.dart';
import 'package:practise/constants.dart';

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    ),
  );
}

Widget buildInfoTile(
    IconData icon, String title, String subtitle, VoidCallback OnTap) {
  return InkWell(
    onTap: OnTap,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: buttuncolor),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    ),
  );
}

Widget buildTile(IconData icon, String title, VoidCallback onTap) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 6),
    child: ListTile(
      leading: Icon(icon, color: buttuncolor),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    ),
  );
}

Widget buildEmptyTile(IconData icon, String title) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 6),
    child: ListTile(
      leading: Icon(icon, color: buttuncolor),
      title: Text(title),
    ),
  );
}

void editPhoneNumber(BuildContext context, String currentNumber) {
  final TextEditingController controller =
      TextEditingController(text: currentNumber);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('تعديل رقم الهاتف'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'رقم الهاتف الجديد',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            child: Text('إلغاء'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text('حفظ'),
            onPressed: () {
              String newNumber = controller.text;
              // قم هنا بحفظ الرقم الجديد (مثلاً بتحديث الحالة أو الإرسال للسيرفر)
              print('رقم الهاتف الجديد: $newNumber');
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  void editPhoneNumber(BuildContext context, String currentPhone) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تعديل رقم الهاتف غير متاح حاليًا'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
