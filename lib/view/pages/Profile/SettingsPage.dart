import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import '../../components/widgets/nav/CustomAppBar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(
        showBackButton : true,
        title: 'Settings',
      ),

      body: SettingsList(
          sections: [
            SettingsSection(
              title: Text('Common', style: TextStyle(
                fontSize: 28,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              )),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: Icon(Icons.language),
                  title: Text('Language'),
                  value: Text('English'),
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {},
                  initialValue: true,
                  leading: Icon(Icons.format_paint),
                  title: Text('Enable custom theme'),
                ),
              ],
            ),
          ],
      ),
    );
  }
  }




