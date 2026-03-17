// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/comptes_pages.dart';
import 'package:mayelab_project/journal_page.dart';
import 'package:mayelab_project/ecritures_pages.dart';
import 'package:mayelab_project/screens/balance_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Mayelab',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MainShell(),
      ),
    );
  }
}

class MainShell extends ConsumerWidget {
  //  ConsumerWidget
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
        ],
      ),
    );
  }
}
