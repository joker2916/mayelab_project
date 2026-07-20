// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/comptes_pages.dart';
import 'package:mayelab_project/journal_page.dart';
import 'package:mayelab_project/ecritures_pages.dart';
import 'package:mayelab_project/balance_page.dart';
import 'package:mayelab_project/grand_livre_page.dart';
import 'package:mayelab_project/pin_setup_page.dart';
import 'package:mayelab_project/pin_login_page.dart';
import 'package:mayelab_project/services/auth_service.dart';
import 'package:mayelab_project/theme/app_theme.dart';
import 'package:mayelab_project/dashboard_page.dart';
import 'package:mayelab_project/providers.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'MayeLab',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
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
      return PinSetupPage(
        onPinCreated: (pin) async {
          await _authService.createPin(pin);
          _onPinSetupComplete();
        },
      );
    }

    // PIN existe mais pas encore authentifié → écran de login
    if (!_authenticated) {
      return PinLoginPage(
        onPinEntered: (pin) async {
          final result = await _authService.verifyPinWithStatus(pin);
          if (result.isSuccess) _onLoginSuccess();
          return result;
        },
      );
    }

    // Authentifié → app principale
    return const MainShell();
  }
}

/// Shell principal avec Bottom Navigation (5 onglets)
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;
  final _ecrituresController = EcrituresPageController();

  void _openEcrituresComposer() {
    setState(() => _currentIndex = 2);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ecrituresController.openComposer();
    });
  }

  List<Widget> _buildPages() {
    return [
      DashboardPage(
        onOpenComptes: () => setState(() => _currentIndex = 1),
        onOpenEcritures: _openEcrituresComposer,
        onOpenJournal: () => setState(() => _currentIndex = 3),
        onOpenBalance: () => setState(() => _currentIndex = 4),
        onOpenGrandLivre: () => setState(() => _currentIndex = 5),
      ),
      const ComptesPage(),
      EcrituresPage(controller: _ecrituresController),
      const JournalPage(),
      const BalancePage(),
      const GrandLivrePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(seedProvider);
    final pages = _buildPages();
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        height: 70,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.space_dashboard_outlined),
            selectedIcon: Icon(Icons.space_dashboard),
            label: 'Accueil',
          ),
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
            icon: Icon(Icons.table_chart_outlined),
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
