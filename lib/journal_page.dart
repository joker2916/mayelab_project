// lib/journal_page.dart
import 'package:flutter/material.dart';
import 'package:mayelab_project/db/app_database.dart';

class JournalPage extends StatelessWidget {
  final AppDatabase db;
  const JournalPage({super.key, required this.db});

  Future<void> _showAddDialog(BuildContext context) async {
    final _libelleCtrl = TextEditingController();
    final _refCtrl = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajouter une pièce'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _libelleCtrl,
              decoration: const InputDecoration(labelText: 'Libellé'),
            ),
            TextField(
              controller: _refCtrl,
              decoration: const InputDecoration(
                labelText: 'Référence (optionnelle)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              final libelle = _libelleCtrl.text.trim();
              final reference =
                  _refCtrl.text.trim().isEmpty ? null : _refCtrl.text.trim();
              if (libelle.isEmpty) return; // pas d'insertion si vide
              // Crée la pièce (pièce minimale sans lignes)
              await db.createPieceWithLines(
                companyId:
                    'default-company', // adapte selon ton contexte / sélection
                libelle: libelle,
                reference: reference,
              );
              Navigator.of(ctx).pop();
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer'),
        content: const Text('Supprimer cette pièce ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await db.deletePieceById(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Ecriture>>(
        stream: db.watchAllPieces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Aucune pièce'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final e = items[i];
              return ListTile(
                title: Text(e.libelle),
                subtitle: Text(e.reference ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(context, e.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
