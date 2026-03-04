import 'package:flutter/material.dart';
import 'package:mayelab_project/db/app_database.dart';
import 'package:mayelab_project/journal_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JournalPage(db: db),
    );
  }
}
