import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'pin_setup_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isPinSwitchChanging = false;

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Biometric Authentication'),
            value: authVM.useBiometric,
            onChanged: (bool value) {
              authVM.setUseBiometric(value);
            },
          ),
          SwitchListTile(
            title: const Text('Enable PIN Authentication'),
            value: authVM.usePin,
            onChanged: (bool value) async {
              if (_isPinSwitchChanging) return;
              _isPinSwitchChanging = true;

              if (value) {
                final pin = await showDialog<String?>(
                  context: context,
                  builder: (context) => const PinSetupDialog(),
                );
                if (pin != null) {
                  // Save the PIN securely here if needed
                  await authVM.setUsePin(true);
                }
              } else {
                await authVM.setUsePin(false);
              }

              _isPinSwitchChanging = false;
            },
          ),
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: authVM.isDarkMode,
              onChanged: (bool value) {
                authVM.toggleDarkMode();
              },
            ),
          ),
        ],
      ),
    );
  }
}
