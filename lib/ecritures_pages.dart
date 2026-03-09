import 'package:flutter/material.dart';

// Modèle temporaire
class Ecriture {
  final String id;
  String libelle;
  DateTime date;
  double montant;
  String compte;
  String type;

  Ecriture({
    required this.id,
    required this.libelle,
    required this.date,
    required this.montant,
    required this.compte,
    required this.type,
  });
}

class EcrituresPage extends StatefulWidget {
  const EcrituresPage({super.key});

  @override
  State<EcrituresPage> createState() => _EcrituresPageState();
}

class _EcrituresPageState extends State<EcrituresPage> {
  final List<String> _planComptable = [
    'Caisse',
    'Banque',
    'Dépenses Transport',
    'Dépenses Alimentation',
    'Ventes',
    'Salaires',
  ];

  final List<Ecriture> _ecritures = [];

  void _supprimerEcriture(Ecriture e) {
    setState(() => _ecritures.remove(e));
  }

  void _ouvrirFormulaire({Ecriture? ecriture}) {
    final formKey = GlobalKey<FormState>();
    final libelleCtrl = TextEditingController(text: ecriture?.libelle ?? '');
    final montantCtrl = TextEditingController(
        text: ecriture != null ? ecriture.montant.toString() : '');
    DateTime date = ecriture?.date ?? DateTime.now();
    String compte = ecriture?.compte ?? _planComptable.first;
    String type = ecriture?.type ?? 'DEBIT';

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
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ecriture == null
                          ? 'Nouvelle écriture'
                          : 'Modifier écriture',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Libellé
                    TextFormField(
                      controller: libelleCtrl,
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
                          initialDate: date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setModalState(() => date = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          '${date.day.toString().padLeft(2, '0')}/'
                          '${date.month.toString().padLeft(2, '0')}/'
                          '${date.year}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Montant
                    TextFormField(
                      controller: montantCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Montant',
                        border: OutlineInputBorder(),
                        suffixText: 'FC',
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Champ requis';
                        if (double.tryParse(v) == null)
                          return 'Nombre invalide';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Compte (plan comptable)
                    DropdownButtonFormField<String>(
                      value: compte,
                      decoration: const InputDecoration(
                        labelText: 'Compte',
                        border: OutlineInputBorder(),
                      ),
                      items: _planComptable
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setModalState(() => compte = v!),
                    ),
                    const SizedBox(height: 12),

                    // Débit / Crédit
                    Row(
                      children: [
                        const Text('Type : ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        ChoiceChip(
                          label: const Text('DÉBIT'),
                          selected: type == 'DEBIT',
                          selectedColor: Colors.red.shade100,
                          onSelected: (_) =>
                              setModalState(() => type = 'DEBIT'),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('CRÉDIT'),
                          selected: type == 'CREDIT',
                          selectedColor: Colors.green.shade100,
                          onSelected: (_) =>
                              setModalState(() => type = 'CREDIT'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Bouton valider
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final nouvelleEcriture = Ecriture(
                              id: ecriture?.id ??
                                  DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                              libelle: libelleCtrl.text,
                              date: date,
                              montant: double.parse(montantCtrl.text),
                              compte: compte,
                              type: type,
                            );
                            setState(() {
                              if (ecriture == null) {
                                _ecritures.add(nouvelleEcriture);
                              } else {
                                final index = _ecritures.indexOf(ecriture);
                                _ecritures[index] = nouvelleEcriture;
                              }
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Valider'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Écritures')),
      body: _ecritures.isEmpty
          ? const Center(child: Text('Aucune écriture pour le moment'))
          : ListView.builder(
              itemCount: _ecritures.length,
              itemBuilder: (context, index) {
                final e = _ecritures[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        e.type == 'DEBIT' ? Colors.red : Colors.green,
                    child: Text(
                      e.type == 'DEBIT' ? 'D' : 'C',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(e.libelle),
                  subtitle: Text(
                    '${e.compte} • '
                    '${e.date.day.toString().padLeft(2, '0')}/'
                    '${e.date.month.toString().padLeft(2, '0')}/'
                    '${e.date.year}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${e.montant.toStringAsFixed(2)} FC',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: e.type == 'DEBIT' ? Colors.red : Colors.green,
                        ),
                      ),
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
