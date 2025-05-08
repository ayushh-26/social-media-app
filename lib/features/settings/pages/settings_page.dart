/*


Settings Page
- Dark mode
- blocked users
- account settings


*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/responsive/constrained_scaffold.dart';
import 'package:social_media_app/themes/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // theme cubit
    final themeCubit = context.watch<ThemeCubit>();

    // is dark mode
    bool isDarkMode = themeCubit.isDarkMode;

    // SCAFFOLD
    return ConstrainedScaffold(
      appBar: AppBar(title: const Text("Settings")), // AppBar
      body: Column(
        children: [
          // dark mode tile
          ListTile(
            title: const Text("Dark Mode"),
            trailing: CupertinoSwitch(
              value: isDarkMode,
              onChanged: (value) {
                themeCubit.toggleTheme();
              },
            ), // CupertinoSwitch
          ), // ListTile
        ],
      ), // Column
    ); // Scaffold
  }
}
