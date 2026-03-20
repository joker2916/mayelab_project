// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/comptes_pages.dart';
import 'package:mayelab_project/journal_page.dart';
import 'package:mayelab_project/ecritures_pages.dart';
import 'package:mayelab_project/screens/balance_screen.dart';
import 'package:mayelab_project/screens/audit_log_screen.dart';
import 'package:mayelab_project/screens/pin_setup_screen.dart';
import 'package:mayelab_project/screens/pin_login_screen.dart';
import 'package:mayelab_project/services/auth_service.dart';
import 'package:mayelab_project/services/audit_log_helper.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Mayelab',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _authService = AuthService();
  final _auditLog = AuditLogHelper();
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_authenticated) {
      return const MainShell();
    }

    if (!_hasPin) {
      return PinSetupScreen(
        onPinCreated: (pin) async {
          await _authService.createPin(pin);
          await _auditLog.log(
            action: 'Création',
            module: 'Auth',
            details: 'PIN admin créé pour la première fois',
          );
          setState(() {
            _hasPin = true;
            _authenticated = true;
          });
        },
      );
    }

    return PinLoginScreen(
      onPinEntered: (pin) async {
        final ok = await _authService.verifyPin(pin);
        if (ok) {
          await _auditLog.log(
            action: 'Connexion',
            module: 'Auth',
            details: 'Connexion réussie',
          );
          setState(() => _authenticated = true);
        } else {
          await _auditLog.log(
            action: 'Connexion',
            module: 'Auth',
            details: 'Tentative de connexion échouée',
          );
        }
        return ok;
      },
    );
  }
}

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _MainShellView();
  }
}

class _MainShellView extends StatefulWidget {
  @override
  State<_MainShellView> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShellView> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ComptesPage(),
    EcrituresPage(),
    JournalPage(),
    BalanceScreen(),
    AuditLogScreen(),
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
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Audit',
          ),
        ],
      ),
    );
  }
}
