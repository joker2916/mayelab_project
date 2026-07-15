import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/db/app_database.dart';
import 'package:mayelab_project/providers.dart';

class JournalPage extends ConsumerWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ecrituresAsync = ref.watch(ecrituresStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
      ),
      body: ecrituresAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Aucune pièce'));
          }

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final e = items[i];
              final date = e.date;
              final dateStr = date == null
                  ? 'Date non définie'
                  : '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

              return ListTile(
                leading: const Icon(Icons.menu_book_outlined),
                title: Text(e.libelle),
                subtitle: Text('${e.reference ?? 'Sans référence'} • $dateStr'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showPieceDetails(context, ref, e),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showPieceDetails(
    BuildContext context,
    WidgetRef ref,
    Ecriture ecriture,
  ) async {
    final repo = ref.read(ecrituresRepositoryProvider);
    final piece = await repo.fetchWithLines(ecriture.id);
    if (!context.mounted || piece == null) return;

    final totalDebit = piece.lignes.fold<int>(0, (s, l) => s + l.debit);
    final totalCredit = piece.lignes.fold<int>(0, (s, l) => s + l.credit);

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  piece.ecriture.libelle,
                  style: Theme.of(ctx).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Réf: ${piece.ecriture.reference ?? 'Sans référence'}',
                  style: Theme.of(ctx).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: piece.lignes.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final l = piece.lignes[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Compte #${l.compteId}'),
                        subtitle: Text(l.description ?? ''),
                        trailing: Text(
                          'D ${_fmt(l.debit)} | C ${_fmt(l.credit)}',
                          style: Theme.of(ctx).textTheme.bodySmall,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Débit total: ${_fmt(totalDebit)}'),
                    Text('Crédit total: ${_fmt(totalCredit)}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _fmt(int cents) => (cents / 100).toStringAsFixed(2);
}
