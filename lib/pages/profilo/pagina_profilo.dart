import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../stato/fornitori.dart';
import '../../ui/app_ui.dart';

class PaginaProfilo extends ConsumerWidget {
  const PaginaProfilo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utente = ref.watch(fornitoreUtenteCorrente);
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilo utente'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: utente == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: c.primary.withOpacity(0.15),
                          child: Icon(Icons.person, color: c.primary, size: 28),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                utente.nome,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (utente.email != null &&
                                  utente.email!.trim().isNotEmpty)
                                Text(
                                  utente.email!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: c.onSurface.withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dettagli',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _RigaDettaglio(
                          label: 'ID utente',
                          value: utente.id.toString(),
                        ),
                        _RigaDettaglio(
                          label: 'Email',
                          value: (utente.email ?? '-').trim().isEmpty
                              ? '-'
                              : utente.email!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _RigaDettaglio extends StatelessWidget {
  const _RigaDettaglio({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: c.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
