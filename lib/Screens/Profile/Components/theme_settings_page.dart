import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme_controller.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController controller = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('Dark Mode Settings')),
      body: Obx(() {
        ThemeMode selected = controller.themeMode.value;
        return Column(
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('On'),
              value: ThemeMode.dark,
              groupValue: selected,
              onChanged: (value) => controller.setTheme(value!),
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Off'),
              value: ThemeMode.light,
              groupValue: selected,
              onChanged: (value) => controller.setTheme(value!),
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Follow System'),
              value: ThemeMode.system,
              groupValue: selected,
              onChanged: (value) => controller.setTheme(value!),
            ),
          ],
        );
      }),
    );
  }
}
