import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.email_outlined, size: 100, color: Colors.blueAccent),
                const SizedBox(height: 20),
                const Text(
                  'تحقق من بريدك الإلكتروني',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'لقد أرسلنا لك رابط تأكيد عبر بريدك الإلكتروني. الرجاء فتحه للمتابعة.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('افتح البريد الإلكتروني'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    // TODO: أضف فتح تطبيق البريد هنا
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // TODO: إعادة إرسال الرابط
                  },
                  child: const Text(
                    'لم يصلك البريد؟ أعد الإرسال',
                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
