import 'package:flutter/material.dart';
import 'package:practise/Screens/Auth/components/custom_button.dart';
import 'package:practise/Screens/Auth/components/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  void _sendResetLink() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });

      // Simulate sending process
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isSending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إعادة تعيين كلمة المرور'),),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                Text("نسيت كلمة المرور؟",
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                  "لا تقلق، فقط أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 30),
                CustomTextField(
                  controller: _emailController,
                  hintText: "البريد الإلكتروني",
                  icon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال البريد الإلكتروني';
                    } else if (!value.contains('@')) {
                      return 'البريد الإلكتروني غير صالح';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: _isSending ? "جاري الإرسال..." : "إرسال الرابط",
                  onPressed: _isSending ? null : _sendResetLink,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
