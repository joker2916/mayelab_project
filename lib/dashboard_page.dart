import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mayelab_project/providers.dart';
import 'package:mayelab_project/theme/app_theme.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({
    super.key,
    required this.onOpenComptes,
    required this.onOpenEcritures,
    required this.onOpenJournal,
    required this.onOpenBalance,
    required this.onOpenGrandLivre,
  });

  final VoidCallback onOpenComptes;
  final VoidCallback onOpenEcritures;
  final VoidCallback onOpenJournal;
  final VoidCallback onOpenBalance;
  final VoidCallback onOpenGrandLivre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comptesAsync = ref.watch(comptesStreamProvider);
    final ecrituresAsync = ref.watch(ecrituresStreamProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _HeroSection(
              dateLabel: DateFormat('EEEE d MMMM yyyy', 'fr_FR')
                  .format(DateTime.now()),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
              child: _KpiSection(
                comptesAsync: comptesAsync,
                ecrituresAsync: ecrituresAsync,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _QuickActions(
                onOpenComptes: onOpenComptes,
                onOpenEcritures: onOpenEcritures,
                onOpenJournal: onOpenJournal,
                onOpenBalance: onOpenBalance,
                onOpenGrandLivre: onOpenGrandLivre,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              child: _RecentEntries(ecrituresAsync: ecrituresAsync),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.dateLabel});

  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F3D5F),
            Color(0xFF146C94),
            Color(0xFF22A39F),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33146C94),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MayeLab Compta',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pilotez vos opérations avec une vue claire et instantanée.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 16, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  dateLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiSection extends StatelessWidget {
  const _KpiSection({
    required this.comptesAsync,
    required this.ecrituresAsync,
  });

  final AsyncValue<List<dynamic>> comptesAsync;
  final AsyncValue<List<dynamic>> ecrituresAsync;

  @override
  Widget build(BuildContext context) {
    final comptesCount = comptesAsync.maybeWhen(
      data: (list) => list.length,
      orElse: () => null,
    );
    final ecrituresCount = ecrituresAsync.maybeWhen(
      data: (list) => list.length,
      orElse: () => null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vue d\'ensemble',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                label: 'Comptes',
                value: comptesCount == null ? '...' : '$comptesCount',
                icon: Icons.account_tree_outlined,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _KpiCard(
                label: 'Écritures',
                value: ecrituresCount == null ? '...' : '$ecrituresCount',
                icon: Icons.receipt_long_outlined,
                color: AppTheme.secondaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onOpenComptes,
    required this.onOpenEcritures,
    required this.onOpenJournal,
    required this.onOpenBalance,
    required this.onOpenGrandLivre,
  });

  final VoidCallback onOpenComptes;
  final VoidCallback onOpenEcritures;
  final VoidCallback onOpenJournal;
  final VoidCallback onOpenBalance;
  final VoidCallback onOpenGrandLivre;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions rapides',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ActionPill(
              icon: Icons.account_tree_outlined,
              label: 'Comptes',
              onTap: onOpenComptes,
            ),
            _ActionPill(
              icon: Icons.post_add,
              label: 'Nouvelle écriture',
              onTap: onOpenEcritures,
            ),
            _ActionPill(
              icon: Icons.book_outlined,
              label: 'Journal',
              onTap: onOpenJournal,
            ),
            _ActionPill(
              icon: Icons.balance,
              label: 'Balance',
              onTap: onOpenBalance,
            ),
            _ActionPill(
              icon: Icons.menu_book_outlined,
              label: 'Grand Livre',
              onTap: onOpenGrandLivre,
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0x220F3D5F)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _RecentEntries extends StatelessWidget {
  const _RecentEntries({required this.ecrituresAsync});

  final AsyncValue<List<dynamic>> ecrituresAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dernières pièces',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        ecrituresAsync.when(
          loading: () => const _LoadingBox(),
          error: (_, __) => const _InfoBox(
            text: 'Impossible de charger les dernières écritures.',
            icon: Icons.error_outline,
          ),
          data: (items) {
            if (items.isEmpty) {
              return const _InfoBox(
                text: 'Aucune écriture pour le moment.',
                icon: Icons.receipt_long_outlined,
              );
            }

            final recent = items.take(5).toList();
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x110F3D5F)),
              ),
              child: ListView.separated(
                itemCount: recent.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final e = recent[i] as dynamic;
                  final formattedDate = e.date == null
                      ? 'Date non définie'
                      : DateFormat('dd/MM/yyyy').format(e.date as DateTime);

                  return ListTile(
                    leading: Container(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.description_outlined,
                          color: AppTheme.secondaryColor, size: 18),
                    ),
                    title: Text(
                      (e.libelle as String).trim().isEmpty
                          ? 'Sans libellé'
                          : e.libelle as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${(e.reference as String?) ?? 'Sans référence'} • $formattedDate',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x110F3D5F)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.darkGrey),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _LoadingBox extends StatelessWidget {
  const _LoadingBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x110F3D5F)),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
