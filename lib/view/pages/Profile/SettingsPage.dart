import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import '../../components/widgets/nav/CustomAppBar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: true,
        title: 'Settings',
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(
              'Common',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Language'),
                value: Text('English'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  setState(() {
                    _isDarkTheme = value;
                  });
                },
                initialValue: _isDarkTheme,
                leading: Icon(Icons.dark_mode),
                title: Text('Enable Dark Theme'),
              ),
            ],
          ),
          SettingsSection(
            title: Text(
              'Account',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.person),
                title: Text('Profile Settings'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.lock),
                title: Text('Privacy Settings'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.security),
                title: Text('Security Settings'),
              ),
            ],
          ),
          SettingsSection(
            title: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                onToggle: (value) {
                },
                initialValue: true,
                leading: Icon(Icons.notifications),
                title: Text('Push Notifications'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: false,
                leading: Icon(Icons.email),
                title: Text('Email Notifications'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
