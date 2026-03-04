// ignore_for_file: use_build_context_synchronously

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/db/app_database.dart';
import 'package:mayelab_project/providers.dart';

final comptesSearchProvider = StateProvider.autoDispose<String>((ref) => '');
final expandedComptesProvider = StateProvider.autoDispose<Set<int>>(
  (ref) => {},
);

class _TreeNode {
  final Compte compte;
  final List<_TreeNode> children;
  _TreeNode(this.compte) : children = [];
}

class _VisibleNode {
  final Compte compte;
  final int depth;
  final bool hasChildren;
  _VisibleNode({
    required this.compte,
    required this.depth,
    required this.hasChildren,
  });
}

class ComptesPage extends ConsumerWidget {
  const ComptesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Si tu as un seed/init
    ref.watch(seedProvider);

    final comptesAsync = ref.watch(comptesStreamProvider);
    final query = ref.watch(comptesSearchProvider).trim().toLowerCase();
    final expanded = ref.watch(expandedComptesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan comptable'),
        actions: [
          IconButton(
            tooltip: 'Nouveau compte',
            icon: const Icon(Icons.add),
            onPressed: () => _showAddRootCompteDialog(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Rechercher par code ou nom',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) =>
                  ref.read(comptesSearchProvider.notifier).state = v,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: comptesAsync.when(
              data: (comptes) {
                final sorted = [...comptes]
                  ..sort((a, b) => a.lft.compareTo(b.lft));

                final roots = _buildTreeFromNestedSet(sorted);

                final bool isSearchMode = query.isNotEmpty;
                final visible = _flattenVisible(
                  roots,
                  expanded: expanded,
                  isSearchMode: isSearchMode,
                  matches: (c) => _matchesQuery(c, query),
                );

                if (visible.isEmpty) {
                  return const Center(child: Text('Aucun compte.'));
                }

                return ListView.separated(
                  itemCount: visible.length,
                  // ignore: unnecessary_underscores
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final node = visible[index];
                    final c = node.compte;

                    final isExpanded = expanded.contains(c.id);

                    return ListTile(
                      dense: true,
                      // IMPORTANT: padding fixe => pas d'escalier
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      leading: SizedBox(
                        // Largeur fixe => tout reste aligné verticalement
                        width: 72,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Marque "sous-compte" sans décaler le texte
                            if (node.depth > 0)
                              const Icon(
                                Icons.subdirectory_arrow_right,
                                size: 18,
                                color: Colors.grey,
                              )
                            else
                              const SizedBox(width: 18),

                            // Expand/collapse (désactivé en mode recherche)
                            if (!isSearchMode && node.hasChildren)
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  isExpanded
                                      ? Icons.expand_more
                                      : Icons.chevron_right,
                                ),
                                onPressed: () {
                                  final st = ref.read(expandedComptesProvider);
                                  final next = {...st};
                                  next.contains(c.id)
                                      ? next.remove(c.id)
                                      : next.add(c.id);
                                  ref
                                      .read(
                                        expandedComptesProvider.notifier,
                                      )
                                      .state = next;
                                },
                              )
                            else
                              const SizedBox(width: 40),
                          ],
                        ),
                      ),
                      title: Text('${c.code} - ${c.nom}'),
                      // Tu peux enlever le subtitle si tu ne veux plus voir lft/rgt
                      subtitle: Text('lft=${c.lft}  rgt=${c.rgt}'),
                      onTap: () => _showEditCompteDialog(context, ref, c),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Ajouter un sous-compte',
                            icon: const Icon(Icons.playlist_add),
                            onPressed: () =>
                                _showAddSousCompteDialog(context, ref, c),
                          ),
                          IconButton(
                            tooltip: 'Supprimer',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () =>
                                _confirmDeleteCompte(context, ref, c),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Erreur: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

/// -------------------------
/// Helpers (search, tree)
/// -------------------------
bool _matchesQuery(Compte c, String q) {
  if (q.isEmpty) return true;
  return c.code.toLowerCase().contains(q) || c.nom.toLowerCase().contains(q);
}

/// Construit un arbre à partir de nested set (lft/rgt) trié par lft
List<_TreeNode> _buildTreeFromNestedSet(List<Compte> sortedByLft) {
  final roots = <_TreeNode>[];
  final stack = <_TreeNode>[];

  for (final c in sortedByLft) {
    final node = _TreeNode(c);

    while (stack.isNotEmpty && stack.last.compte.rgt < c.lft) {
      stack.removeLast();
    }

    if (stack.isEmpty) {
      roots.add(node);
    } else {
      // Normalement c est à l'intérieur de stack.last
      stack.last.children.add(node);
    }

    stack.add(node);
  }

  return roots;
}

List<_VisibleNode> _flattenVisible(
  List<_TreeNode> roots, {
  required Set<int> expanded,
  required bool isSearchMode,
  required bool Function(Compte) matches,
}) {
  final out = <_VisibleNode>[];

  void visit(_TreeNode n, int depth) {
    final hasChildren = n.children.isNotEmpty;

    if (isSearchMode) {
      // En recherche : on affiche seulement les éléments qui matchent (sans logique expand)
      if (matches(n.compte)) {
        out.add(
          _VisibleNode(
            compte: n.compte,
            depth: depth,
            hasChildren: hasChildren,
          ),
        );
      }
      for (final ch in n.children) {
        visit(ch, depth + 1);
      }
      return;
    }

    // Mode normal : on affiche tout, mais on ne descend que si "expanded"
    out.add(
      _VisibleNode(compte: n.compte, depth: depth, hasChildren: hasChildren),
    );
    if (hasChildren && expanded.contains(n.compte.id)) {
      for (final ch in n.children) {
        visit(ch, depth + 1);
      }
    }
  }

  for (final r in roots) {
    visit(r, 0);
  }

  return out;
}

/// -------------------------
/// Dialogs (Add / Edit)
/// -------------------------
Future<void> _showAddRootCompteDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final codeCtrl = TextEditingController();
  final nomCtrl = TextEditingController();

  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Nouveau compte (racine)'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: codeCtrl,
            decoration: const InputDecoration(labelText: 'Code'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nomCtrl,
            decoration: const InputDecoration(labelText: 'Nom'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () async {
            final code = codeCtrl.text.trim();
            final nom = nomCtrl.text.trim();

            if (code.isEmpty || nom.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Code et nom obligatoires.')),
              );
              return;
            }

            try {
              await _insertRootCompte(ref, code: code, nom: nom);
              if (context.mounted) Navigator.pop(ctx);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Erreur ajout : $e')));
              }
            }
          },
          child: const Text('Créer'),
        ),
      ],
    ),
  );
}

Future<void> _showAddSousCompteDialog(
  BuildContext context,
  WidgetRef ref,
  Compte parent,
) async {
  final codeCtrl = TextEditingController();
  final nomCtrl = TextEditingController();

  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Nouveau sous-compte de ${parent.code}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: codeCtrl,
            decoration: const InputDecoration(labelText: 'Code'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nomCtrl,
            decoration: const InputDecoration(labelText: 'Nom'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () async {
            final code = codeCtrl.text.trim();
            final nom = nomCtrl.text.trim();

            if (code.isEmpty || nom.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Code et nom obligatoires.')),
              );
              return;
            }

            try {
              await _insertChildCompte(
                ref,
                parentId: parent.id,
                code: code,
                nom: nom,
              );
              if (context.mounted) Navigator.pop(ctx);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Erreur ajout : $e')));
              }
            }
          },
          child: const Text('Créer'),
        ),
      ],
    ),
  );
}

Future<void> _showEditCompteDialog(
  BuildContext context,
  WidgetRef ref,
  Compte c,
) async {
  final codeCtrl = TextEditingController(text: c.code);
  final nomCtrl = TextEditingController(text: c.nom);

  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Modifier le compte'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: codeCtrl,
            decoration: const InputDecoration(labelText: 'Code'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nomCtrl,
            decoration: const InputDecoration(labelText: 'Nom'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () async {
            final newCode = codeCtrl.text.trim();
            final newNom = nomCtrl.text.trim();

            if (newCode.isEmpty || newNom.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Code et nom obligatoires.')),
              );
              return;
            }

            try {
              await _updateCompte(ref, id: c.id, code: newCode, nom: newNom);
              if (context.mounted) Navigator.pop(ctx);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur modification : $e')),
                );
              }
            }
          },
          child: const Text('Enregistrer'),
        ),
      ],
    ),
  );
}

/// -------------------------
/// DB operations (Nested set)
/// -------------------------
Future<void> _insertRootCompte(
  WidgetRef ref, {
  required String code,
  required String nom,
}) async {
  final db = ref.read(databaseProvider);

  // UNIQUE check (message propre)
  final existing = await (db.select(
    db.comptes,
  )..where((t) => t.code.equals(code)))
      .get();
  if (existing.isNotEmpty) {
    throw Exception('Ce code existe déjà : $code');
  }

  final maxRgtRows = await db.customSelect(
    'SELECT COALESCE(MAX(rgt), 0) AS maxRgt FROM comptes',
    readsFrom: {db.comptes},
  ).get();

  final maxRgt = (maxRgtRows.first.data['maxRgt'] as int);
  final lft = maxRgt + 1;
  final rgt = maxRgt + 2;

  await db.into(db.comptes).insert(
        ComptesCompanion.insert(code: code, nom: nom, lft: lft, rgt: rgt),
      );
}

Future<void> _insertChildCompte(
  WidgetRef ref, {
  required int parentId,
  required String code,
  required String nom,
}) async {
  final db = ref.read(databaseProvider);

  await db.transaction(() async {
    // UNIQUE check
    final existing = await (db.select(
      db.comptes,
    )..where((t) => t.code.equals(code)))
        .get();
    if (existing.isNotEmpty) {
      throw Exception('Ce code existe déjà : $code');
    }

    final parentList = await (db.select(
      db.comptes,
    )..where((t) => t.id.equals(parentId)))
        .get();
    if (parentList.isEmpty) {
      throw Exception('Parent introuvable.');
    }
    final parent = parentList.first;

    // Insertion juste avant la fermeture du parent
    final insertAt = parent.rgt;

    // Décale tous les noeuds à droite (y compris rgt des ancêtres)
    await db.customUpdate(
      'UPDATE comptes SET lft = lft + 2 WHERE lft >= ?',
      variables: [drift.Variable.withInt(insertAt)],
      updates: {db.comptes},
    );

    await db.customUpdate(
      'UPDATE comptes SET rgt = rgt + 2 WHERE rgt >= ?',
      variables: [drift.Variable.withInt(insertAt)],
      updates: {db.comptes},
    );

    await db.into(db.comptes).insert(
          ComptesCompanion.insert(
            code: code,
            nom: nom,
            lft: insertAt,
            rgt: insertAt + 1,
          ),
        );
  });
}

Future<void> _updateCompte(
  WidgetRef ref, {
  required int id,
  required String code,
  required String nom,
}) async {
  final db = ref.read(databaseProvider);

  // UNIQUE check (exclure soi-même)
  final existing = await (db.select(
    db.comptes,
  )..where((t) => t.code.equals(code) & t.id.isNotIn([id])))
      .get();

  if (existing.isNotEmpty) {
    throw Exception('Ce code existe déjà : $code');
  }

  await (db.update(db.comptes)..where((t) => t.id.equals(id))).write(
    ComptesCompanion(code: drift.Value(code), nom: drift.Value(nom)),
  );
}

/// Robust: "a des enfants ?" = existe un noeud à l'intérieur (lft >, rgt <)
Future<bool> _hasChildrenDb(AppDatabase db, Compte c) async {
  final rows = await db.customSelect(
    'SELECT 1 FROM comptes WHERE lft > ? AND rgt < ? LIMIT 1',
    variables: [
      drift.Variable.withInt(c.lft),
      drift.Variable.withInt(c.rgt),
    ],
    readsFrom: {db.comptes},
  ).get();

  return rows.isNotEmpty;
}

Future<void> _confirmDeleteCompte(
  BuildContext context,
  WidgetRef ref,
  Compte c,
) async {
  final db = ref.read(databaseProvider);

  // Recharge pour éviter des valeurs "stale"
  final freshList = await (db.select(
    db.comptes,
  )..where((t) => t.id.equals(c.id)))
      .get();
  if (freshList.isEmpty) return;
  final fresh = freshList.first;

  final hasChildren = await _hasChildrenDb(db, fresh);
  if (hasChildren) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Impossible : ce compte a des sous-comptes."),
      ),
    );
    return;
  }

  final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Supprimer ce compte ?'),
          content: Text('${fresh.code} - ${fresh.nom}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Supprimer'),
            ),
          ],
        ),
      ) ??
      false;

  if (!ok) return;

  try {
    await _deleteLeafCompte(ref, fresh);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Compte supprimé.')));
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur suppression : $e')));
    }
  }
}

Future<void> _deleteLeafCompte(WidgetRef ref, Compte c) async {
  final db = ref.read(databaseProvider);

  await db.transaction(() async {
    final freshList = await (db.select(
      db.comptes,
    )..where((t) => t.id.equals(c.id)))
        .get();
    if (freshList.isEmpty) return;
    final fresh = freshList.first;

    final hasChildren = await _hasChildrenDb(db, fresh);
    if (hasChildren) {
      throw Exception("Ce compte a des sous-comptes.");
    }

    final deletedRgt = fresh.rgt;

    await (db.delete(db.comptes)..where((t) => t.id.equals(fresh.id))).go();

    // Refermer le trou
    await db.customUpdate(
      'UPDATE comptes SET lft = lft - 2 WHERE lft > ?',
      variables: [drift.Variable.withInt(deletedRgt)],
      updates: {db.comptes},
    );

    await db.customUpdate(
      'UPDATE comptes SET rgt = rgt - 2 WHERE rgt > ?',
      variables: [drift.Variable.withInt(deletedRgt)],
      updates: {db.comptes},
    );
  });
}
