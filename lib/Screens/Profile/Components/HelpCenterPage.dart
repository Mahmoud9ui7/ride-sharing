import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    debugPrint('App Version: ${info.version}+${info.buildNumber}');
    setState(() {
      _version = '${info.version}+${info.buildNumber}';
    });
  }

  void _openPrivacyPolicy() async {
    const url = 'https://example.com/privacy';
    try {
      await launch(
        url,
        customTabsOption: const CustomTabsOption(
          toolbarColor: Colors.blue,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
        ),
      );
    } catch (e) {
      debugPrint('تعذر فتح سياسة الخصوصية: $e');
    }
  }

  void _openTermsOfService() async {
    const url = 'https://example.com/terms';
    try {
      await launch(
        url,
        customTabsOption: const CustomTabsOption(
          toolbarColor: Colors.blue,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
        ),
      );
    } catch (e) {
      debugPrint('تعذر فتح شروط الاستخدام: $e');
    }
  }

  void _checkForUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري التحقق من وجود تحديثات...')),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز المساعدة'),
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مرحبًا بك في مركز المساعدة! 👋',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('إصدار التطبيق: $_version'),
              ],
            ),
          ),
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('الأسئلة الشائعة',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ExpansionTile(
                  title: Text('كيف يمكنني إنشاء حساب جديد؟'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('اضغط على "تسجيل" وأدخل معلوماتك.'),
                    )
                  ],
                ),
                ExpansionTile(
                  title: Text('هل يمكنني تغيير رقم الهاتف؟'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('نعم، من خلال الإعدادات > الحساب.'),
                    )
                  ],
                ),
              ],
            ),
          ),
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('روابط مهمة',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('سياسة الخصوصية'),
                  onTap: _openPrivacyPolicy,
                ),
                ListTile(
                  leading: const Icon(Icons.rule_folder_outlined),
                  title: const Text('شروط الاستخدام'),
                  onTap: _openTermsOfService,
                ),
              ],
            ),
          ),
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('دليل استخدام التطبيق',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.home_outlined),
                  title: Text('الصفحة الرئيسية - تصفح الطلبات والخدمات'),
                ),
                ListTile(
                  leading: Icon(Icons.person_outline),
                  title:
                      Text('الملف الشخصي - معلوماتك الشخصية وإعدادات الحساب'),
                ),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text('المساعدة - الدعم، التعليمات، الأسئلة الشائعة'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton.icon(
              onPressed: _checkForUpdates,
              icon: const Icon(Icons.system_update_alt),
              label: const Text('التحقق من وجود تحديث'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
