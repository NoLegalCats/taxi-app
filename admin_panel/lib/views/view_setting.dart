import 'package:admin_panel/app_config.dart';
import 'package:flutter/material.dart';

class ViewSetting extends StatelessWidget {
  const ViewSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        actions: [
          IconButton(
            onPressed: () {
              AppConfig.exit();
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}
