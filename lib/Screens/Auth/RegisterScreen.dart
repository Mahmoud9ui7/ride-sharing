import 'package:flutter/material.dart';
import 'package:practise/Screens/Auth/LoginScreen.dart';
import 'package:practise/Screens/Auth/components/SignUpComponent.dart';
import 'package:practise/Screens/componets/constants.dart';
import 'package:practise/Screens/componets/navigateWithFade.dart';
import 'package:practise/Screens/home/homepage.dart';
import 'package:rive/rive.dart'; // أضف هذا في pubspec.yaml

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const RiveAnimation.asset(
            'assets/rive/animated_login_character.riv', // ضع ملف .rive هنا في مجلد assets
            fit: BoxFit.cover,
          ),
          Container(
              color: Colors.white
                  .withOpacity(0.85)), // خلفية شبه شفافة لسهولة القراءة
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add_alt,
                          // size: 80, color: Theme.of(context).primaryColor),
                          size: 80,
                          color: primaryColor),
                      SizedBox(height: 24),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'الرجاء إدخال البريد الإلكتروني';
                          if (!value.contains('@'))
                            return 'بريد إلكتروني غير صالح';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'الرجاء إدخال كلمة المرور';
                          if (value.length < 6)
                            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value != passwordController.text)
                            return 'كلمتا المرور غير متطابقتين';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'تأكيد كلمة المرور',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: SignUpButton(
                          formKey: _formKey,
                          emailController: emailController,
                          passwordController: passwordController,
                        ),
                      ),
                      SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          AmimationPop(context, LoginScreen());
                        },
                        child: Text(' لديك حساب مسبقا ؟ تسجيل الدخول'),
                      ),
                      TextButton(
                        onPressed: () {
                          AmimationpushAndRemoveUntil(context, HomeScreen());
                        },
                        child: Text(' الاستمرار بدون حساب'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
