import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';

class SignUpButton extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignUpButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.emailController,
    required this.passwordController,
  }) : _formKey = formKey;

  void _showMessage(BuildContext context, String message, {bool isError = true}) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 4),
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(12),
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
      animationDuration: const Duration(milliseconds: 500),
    ).show(context);
  }

  Future<void> _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        Navigator.pop(context);

        _showMessage(context, 'تم إنشاء الحساب بنجاح ✅', isError: false);

        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushNamedAndRemoveUntil(context, '/home', (context) => false);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        String errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = 'كلمة المرور ضعيفة جدًا.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'البريد الإلكتروني مستخدم بالفعل.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'البريد الإلكتروني غير صالح.';
        } else {
          errorMessage = 'حدث خطأ أثناء إنشاء الحساب.';
        }

        _showMessage(context, errorMessage);
      } catch (e) {
        Navigator.pop(context);
        _showMessage(context, 'خطأ غير متوقع: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _signUp(context),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'تسجيل',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
