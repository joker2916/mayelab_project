import 'package:flutter/material.dart';

class EcrituresScreen extends StatefulWidget {
  const EcrituresScreen({super.key});

  @override
  State<EcrituresScreen> createState() => _EcrituresScreenState();
}

// Modèle temporaire
class Ecriture {
  final String id;
  String libelle;
  DateTime date;
  double montant;
  String compte;
  String type; // DEBIT ou CREDIT

  Ecriture({
    required this.id,
    required this.libelle,
    required this.date,
    required this.montant,
    required this.compte,
    required this.type,
  });
}

class _EcrituresScreenState extends State<EcrituresScreen> {
  // Données fictives plan comptable
  final List<String> _planComptable = [
    'Caisse',
    'Banque',
    'Dépenses Transport',
    'Dépenses Alimentation',
    'Ventes',
    'Salaires',
  ];

  final List<Ecriture> _ecritures = [];

  void _ouvrirFormulaire({Ecriture? ecriture}) {
    final _formKey = GlobalKey<FormState>();
    final _libelle = TextEditingController(text: ecriture?.libelle ?? '');
    final _montant = TextEditingController(
        text: ecriture != null ? ecriture.montant.toString() : '');
    DateTime _date = ecriture?.date ?? DateTime.now();
    String _compte = ecriture?.compte ?? _planComptable.first;
    String _type = ecriture?.type ?? 'DEBIT';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ecriture == null
                            ? 'Ajouter une écriture'
                            : 'Modifier l\'écriture',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      // Libellé
                      TextFormField(
                        controller: _libelle,
                        decoration: const InputDecoration(
                          labelText: 'Libellé',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Champ requis' : null,
                      ),
                      const SizedBox(height: 12),

                      // Date
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setModalState(() => _date = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            '${_date.day.toString().padLeft(2, '0')}/'
                            '${_date.month.toString().padLeft(2, '0')}/'
                            '${_date.year}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Montant
                      TextFormField(
                        controller: _montant,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Montant',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Champ requis';
                          if (double.tryParse(v) == null)
                            return 'Montant invalide';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Compte (plan comptable)
                      DropdownButtonFormField<String>(
                        value: _compte,
                        decoration: const InputDecoration(
                          labelText: 'Compte',
                          border: OutlineInputBorder(),
                        ),
                        items: _planComptable
                            .map((c) =>
                                DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) =>
                            setModalState(() => _compte = v ?? _compte),
                      ),
                      const SizedBox(height: 12),

                      // Débit / Crédit
                      const Text('Type',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Débit'),
                              value: 'DEBIT',
                              groupValue: _type,
                              onChanged: (v) =>
                                  setModalState(() => _type = v ?? _type),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Crédit'),
                              value: 'CREDIT',
                              groupValue: _type,
                              onChanged: (v) =>
                                  setModalState(() => _type = v ?? _type),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Bouton valider
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                if (ecriture == null) {
                                  _ecritures.add(Ecriture(
                                    id: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    libelle: _libelle.text,
                                    date: _date,
                                    montant: double.parse(_montant.text),
                                    compte: _compte,
                                    type: _type,
                                  ));
                                } else {
                                  ecriture.libelle = _libelle.text;
                                  ecriture.date = _date;
                                  ecriture.montant =
                                      double.parse(_montant.text);
                                  ecriture.compte = _compte;
                                  ecriture.type = _type;
                                }
                              });
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                              ecriture == null ? 'Ajouter' : 'Enregistrer'),
                        ),
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

  void _supprimerEcriture(Ecriture ecriture) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer'),
        content: Text('Supprimer l\'écriture "${ecriture.libelle}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _ecritures.remove(ecriture));
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Écritures'),
        centerTitle: true,
      ),
      body: _ecritures.isEmpty
          ? const Center(
              child: Text(
                'Aucune écriture.\nAppuyez sur + pour en ajouter.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _ecritures.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final e = _ecritures[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: e.type == 'DEBIT'
                        ? Colors.red.shade100
                        : Colors.green.shade100,
                    child: Icon(
                      e.type == 'DEBIT'
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: e.type == 'DEBIT' ? Colors.red : Colors.green,
                    ),
                  ),
                  title: Text(e.libelle,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    '${e.compte} • '
                    '${e.date.day.toString().padLeft(2, '0')}/'
                    '${e.date.month.toString().padLeft(2, '0')}/'
                    '${e.date.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${e.montant.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: e.type == 'DEBIT' ? Colors.red : Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _ouvrirFormulaire(ecriture: e),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            size: 20, color: Colors.red),
                        onPressed: () => _supprimerEcriture(e),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ouvrirFormulaire(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
