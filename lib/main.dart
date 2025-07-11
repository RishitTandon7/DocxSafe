import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const DocxSafeApp());
}

class DocxSafeApp extends StatelessWidget {
  const DocxSafeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>(
      create: (_) => AuthViewModel(),
      child: Consumer<AuthViewModel>(
        builder: (context, authVM, _) {
          return MaterialApp(
            title: 'DocxSafe',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: authVM.isDarkMode
                    ? Brightness.dark
                    : Brightness.light,
              ),
              useMaterial3: false,
              brightness: authVM.isDarkMode
                  ? Brightness.dark
                  : Brightness.light,
            ),
            home: authVM.isAuthenticated
                ? const HomeScreen()
                : const AuthScreen(),
          );
        },
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    try {
      if (authVM.useBiometric) {
        bool canCheckBiometrics = await auth.canCheckBiometrics;
        bool authenticated = false;
        if (canCheckBiometrics) {
          authenticated = await auth.authenticate(
            localizedReason: 'Please authenticate to access DocxSafe',
            options: const AuthenticationOptions(biometricOnly: true),
          );
        }
        if (authenticated) {
          authVM.setAuthenticated(true);
          setState(() {
            _isAuthenticating = false;
          });
          return;
        }
      }
      if (authVM.usePin) {
        // PIN authentication flow can be added here if needed
        // Since PIN system was removed, skipping PIN auth
        setState(() {
          _errorMessage = 'PIN authentication is disabled.';
          _isAuthenticating = false;
        });
        return;
      }
      // If neither biometric nor PIN is enabled, authenticate automatically
      authVM.setAuthenticated(true);
      setState(() {
        _isAuthenticating = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Authentication failed.';
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticating) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Authenticate')),
      body: Center(
        child: _errorMessage != null
            ? Text(_errorMessage!, style: const TextStyle(color: Colors.red))
            : const Text('Please authenticate to continue'),
      ),
    );
  }
}
