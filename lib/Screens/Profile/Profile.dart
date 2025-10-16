import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practise/Screens/Auth/LoginScreen.dart';
import 'package:practise/Screens/Profile/Components/HelpCenterPage.dart';
import 'package:practise/Screens/Profile/Components/Profile.dart';
import 'package:practise/Screens/Profile/Components/theme_settings_page.dart';
import 'package:practise/Screens/componets/constants.dart';
import 'package:practise/Screens/componets/navigateWithFade.dart';
import 'package:practise/people/persons_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'غير مسجل';
  String userEmail = 'غير مسجل';
  String userPhone = 'لا يوجد';

  File? _image;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String? displayName = currentUser!.displayName;
      String? email = currentUser!.email;

      setState(() {
        userName = displayName ?? 'بدون اسم';
        userEmail = _obscureEmail(email ?? 'غير مسجل');
      });
    }
  }

  String _obscureEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    String name = parts[0];
    String domain = parts[1];
    if (name.length <= 3) {
      return '$name***@$domain';
    } else {
      return '${name.substring(0, 3)}****@$domain';
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      bool confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تأكيد'),
          content: const Text('هل تريد استخدام هذه الصورة؟'),
          actions: [
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text('نعم'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );

      if (confirm == true) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  void _editProfileDialog() {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يجب تسجيل الدخول لتعديل الملف الشخصي")),
      );
      return;
    }

    nameController.text = userName;
    emailController.text = userEmail;
    phoneController.text = userPhone;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('تعديل الملف الشخصي'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'الاسم',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                userName = nameController.text;
                userPhone = phoneController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : const AssetImage('assets/images/app_icon1.png')
                          as ImageProvider,
                ),
                Positioned(
                    child: IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: () {
                    if (currentUser == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("يجب تسجيل الدخول لتغيير الصورة")),
                      );
                      return;
                    }

                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo),
                            title: const Text("اختيار صورة"),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text("حذف الصورة"),
                            onTap: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('تأكيد'),
                                  content: const Text(
                                      'هل أنت متأكد أنك تريد حذف الصورة؟'),
                                  actions: [
                                    TextButton(
                                      child: const Text('إلغاء'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: const Text('نعم'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _removeImage();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ))
              ],
            ),
            const SizedBox(height: 10),
            Text(userName,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(userEmail, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _editProfileDialog,
              icon: const Icon(Icons.edit, color: TextColor),
              label: const Text('تعديل الملف الشخصي',
                  style: TextStyle(color: TextColor)),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttuncolor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),
            buildSectionTitle('معلومات'),
            buildInfoTile(Icons.phone, 'رقم الهاتف', userPhone, () {
              _editProfileDialog();
            }),
            buildInfoTile(Icons.star, 'التقييم', '4.9 (120 رحلة)', () {}),
            buildInfoTile(
                Icons.car_rental, 'المركبة', 'تويوتا بريوس - أبيض', () {}),
            buildInfoTile(
                Icons.credit_card, 'طريقة الدفع', 'Visa **** 1234', () {}),
            const SizedBox(height: 30),
            buildSectionTitle('الإعدادات'),
            buildTile(Icons.dark_mode, 'الوضع الليلي', () {
              AnimationPush(context, ThemeSettingsPage());
            }),
            buildTile(Icons.lock, 'تغيير كلمة المرور', () {}),
            buildTile(Icons.language, 'اللغة', () {}),
            buildTile(Icons.people, 'people', () {
              AnimationPush(context, PersonsPage());
            }),
            const SizedBox(height: 30),
            buildSectionTitle('الدعم'),
            buildTile(Icons.help_outline, 'مركز المساعدة', () {
              AnimationPush(context, HelpCenterPage());
            }),
            buildTile(Icons.policy, 'سياسة الخصوصية', () {
              AnimationPush(context, LicensePage());
            }),
            FirebaseAuth.instance.currentUser != null
                ? buildTile(Icons.logout, 'تسجيل الخروج', () async {
                    await FirebaseAuth.instance.signOut();
                    AmimationPushReplacement(context, LoginScreen());
                  })
                : buildTile(Icons.login, 'تسجيل الدخول', () {
                    AmimationPushReplacement(context, LoginScreen());
                  }),
          ],
        ),
      ),
    );
  }
}
