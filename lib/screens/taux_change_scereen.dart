import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/db/app_database.dart';
import '../providers.dart';
import 'package:drift/drift.dart' show Value;

class TauxChangeScreen extends ConsumerStatefulWidget {
  const TauxChangeScreen({super.key});

  @override
  ConsumerState<TauxChangeScreen> createState() => _TauxChangeScreenState();
}

class _TauxChangeScreenState extends ConsumerState<TauxChangeScreen> {
  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Taux de Change'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<TauxChangeData>>(
        stream: db.select(db.tauxChange).watch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final taux = snapshot.data ?? [];

          if (taux.isEmpty) {
            return const Center(
              child: Text(
                'Aucun taux de change enregistré',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: taux.length,
            itemBuilder: (context, index) {
              final t = taux[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(
                      '${t.deviseSource}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                  title: Text(
                    '${t.deviseSource} → ${t.deviseCible}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Achat: ${t.tauxAchat.toStringAsFixed(4)}'),
                      Text('Vente: ${t.tauxVente.toStringAsFixed(4)}'),
                      Text(
                        'Du ${_formatDate(t.dateDebut)}${t.dateFin != null ? ' au ${_formatDate(t.dateFin!)}' : ' - En cours'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: t.dateFin == null ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _showForm(context, db, taux: t),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTaux(db, t),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => _showForm(context, ref.read(databaseProvider)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _deleteTaux(AppDatabase db, TauxChangeData t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content:
            Text('Supprimer le taux ${t.deviseSource} → ${t.deviseCible} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              (db.delete(db.tauxChange)..where((row) => row.id.equals(t.id)))
                  .go();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Taux supprimé'),
                    backgroundColor: Colors.red),
              );
            },
            child:
                const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showForm(BuildContext context, AppDatabase db, {TauxChangeData? taux}) {
    final deviseSourceCtrl =
        TextEditingController(text: taux?.deviseSource ?? 'USD');
    final deviseCibleCtrl =
        TextEditingController(text: taux?.deviseCible ?? 'CDF');
    final achatCtrl =
        TextEditingController(text: taux?.tauxAchat.toString() ?? '');
    final venteCtrl =
        TextEditingController(text: taux?.tauxVente.toString() ?? '');
    DateTime dateDebut = taux?.dateDebut ?? DateTime.now();
    DateTime? dateFin = taux?.dateFin;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        taux == null
                            ? 'Nouveau Taux de Change'
                            : 'Modifier le Taux',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Devises
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: deviseSourceCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Devise Source',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.monetization_on),
                              ),
                              textCapitalization: TextCapitalization.characters,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Requis' : null,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child:
                                Icon(Icons.arrow_forward, color: Colors.teal),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: deviseCibleCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Devise Cible',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.monetization_on),
                              ),
                              textCapitalization: TextCapitalization.characters,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Requis' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Taux Achat
                      TextFormField(
                        controller: achatCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Taux d\'Achat',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.trending_down),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Requis';
                          if (double.tryParse(v) == null)
                            return 'Nombre invalide';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Taux Vente
                      TextFormField(
                        controller: venteCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Taux de Vente',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.trending_up),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Requis';
                          if (double.tryParse(v) == null)
                            return 'Nombre invalide';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Date Début
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today,
                            color: Colors.teal),
                        title: Text('Début: ${_formatDate(dateDebut)}'),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: dateDebut,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setModalState(() => dateDebut = picked);
                          }
                        },
                      ),

                      // Date Fin
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today_outlined,
                            color: Colors.teal),
                        title: Text(dateFin != null
                            ? 'Fin: ${_formatDate(dateFin!)}'
                            : 'Fin: Non définie (en cours)'),
                        trailing: dateFin != null
                            ? IconButton(
                                icon:
                                    const Icon(Icons.clear, color: Colors.red),
                                onPressed: () =>
                                    setModalState(() => dateFin = null),
                              )
                            : null,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: dateFin ?? DateTime.now(),
                            firstDate: dateDebut,
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setModalState(() => dateFin = picked);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Bouton
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: Icon(
                          taux == null ? Icons.save : Icons.update,
                          color: Colors.white,
                        ),
                        label: Text(
                          taux == null ? 'Enregistrer' : 'Mettre à jour',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;

                          final companion = TauxChangeCompanion(
                            deviseSource: Value(
                                deviseSourceCtrl.text.trim().toUpperCase()),
                            deviseCible: Value(
                                deviseCibleCtrl.text.trim().toUpperCase()),
                            tauxAchat:
                                Value(double.parse(achatCtrl.text.trim())),
                            tauxVente:
                                Value(double.parse(venteCtrl.text.trim())),
                            dateDebut: Value(dateDebut),
                            dateFin: Value(dateFin),
                            dateModification: Value(DateTime.now()),
                          );

                          if (taux == null) {
                            db.into(db.tauxChange).insert(companion);
                          } else {
                            (db.update(db.tauxChange)
                                  ..where((row) => row.id.equals(taux.id)))
                                .write(companion);
                          }

                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(taux == null
                                  ? 'Taux ajouté'
                                  : 'Taux modifié'),
                              backgroundColor: Colors.teal,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
