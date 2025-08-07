import 'package:flutter/material.dart';
import 'package:practise/Screens/home/homepage.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تحقق من البريد'),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (contex) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(
                    Icons.cancel,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.email_outlined,
                    size: 100, color: Colors.blueAccent),
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
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'لم يصلك البريد؟ أعد الإرسال',
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold),
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
