import 'package:flutter/material.dart';

class PinSetupDialog extends StatefulWidget {
  const PinSetupDialog({Key? key}) : super(key: key);

  @override
  State<PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends State<PinSetupDialog> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  String? _errorText;

  void _submit() {
    final pin = _pinController.text;
    final confirmPin = _confirmPinController.text;

    if (pin.isEmpty || confirmPin.isEmpty) {
      setState(() {
        _errorText = 'Please enter and confirm your PIN.';
      });
      return;
    }
    if (pin != confirmPin) {
      setState(() {
        _errorText = 'PINs do not match.';
      });
      return;
    }
    if (pin.length < 4) {
      setState(() {
        _errorText = 'PIN must be at least 4 digits.';
      });
      return;
    }

    Navigator.of(context).pop(pin);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set up PIN'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Enter PIN'),
          ),
          TextField(
            controller: _confirmPinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Confirm PIN'),
          ),
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _errorText!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Set PIN')),
      ],
    );
  }
}
