// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/comptes_pages.dart';
import 'package:mayelab_project/journal_page.dart';
import 'package:mayelab_project/ecritures_pages.dart';
import 'package:mayelab_project/screens/balance_screen.dart';
import 'package:mayelab_project/screens/grand_livre_screen.dart';
import 'package:mayelab_project/screens/pin_setup_screen.dart';
import 'package:mayelab_project/screens/pin_login_screen.dart';
import 'package:mayelab_project/services/auth_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'MayeLab',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AuthGate(),
      ),
    );
  }
}

/// Gère le flux : PIN Setup → PIN Login → App principale
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _authService = AuthService();
  bool _loading = true;
  bool _hasPin = false;
  bool _authenticated = false;

  @override
  void initState() {
    super.initState();
    _checkPin();
  }

  Future<void> _checkPin() async {
    final exists = await _authService.hasPin();
    setState(() {
      _hasPin = exists;
      _loading = false;
    });
  }

  void _onPinSetupComplete() {
    setState(() {
      _hasPin = true;
    });
  }

  void _onLoginSuccess() {
    setState(() {
      _authenticated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Pas encore de PIN → écran de création
    if (!_hasPin) {
      return PinSetupScreen(
        onPinCreated: (pin) async {
          await _authService.createPin(pin);
          _onPinSetupComplete();
        },
      );
    }

    // PIN existe mais pas encore authentifié → écran de login
    if (!_authenticated) {
      return PinLoginScreen(
        onPinEntered: (pin) async {
          final ok = await _authService.verifyPin(pin);
          if (ok) _onLoginSuccess();
          return ok;
        },
      );
    }

    // Authentifié → app principale
    return const MainShell();
  }
}

/// Shell principal avec Bottom Navigation (5 onglets)
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ComptesPage(),
    EcrituresPage(),
    JournalPage(),
    BalanceScreen(),
    GrandLivreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.account_tree_outlined),
            selectedIcon: Icon(Icons.account_tree),
            label: 'Comptes',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Écritures',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Journal',
          ),
          NavigationDestination(
            icon: Icon(Icons.balance_outlined),
            selectedIcon: Icon(Icons.balance),
            label: 'Balance',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Grand Livre',
          ),
        ],
      ),
    );
  }
}
