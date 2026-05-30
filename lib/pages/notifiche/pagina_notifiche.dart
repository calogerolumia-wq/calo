import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/notifica_remota.dart';
import '../../stato/fornitori.dart';

class PaginaNotifiche extends ConsumerWidget {
  const PaginaNotifiche({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificheAsync = ref.watch(fornitoreNotifiche);
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Scaffold(
      backgroundColor: c.surface,
      appBar: AppBar(
        title: const Text('Notifiche'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Aggiorna',
            onPressed: () => ref.invalidate(fornitoreNotifiche),
          ),
        ],
      ),
      body: notificheAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off_outlined, size: 48, color: c.error),
              const SizedBox(height: 12),
              Text('Impossibile caricare le notifiche',
                  style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        data: (lista) {
          if (lista.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_none_outlined,
                      size: 56, color: c.onSurface.withOpacity(0.30)),
                  const SizedBox(height: 12),
                  Text('Nessuna notifica',
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('Non hai ricevuto comunicazioni.',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: c.onSurface.withOpacity(0.55))),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(fornitoreNotifiche),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: lista.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) =>
                  _NotificaTile(notifica: lista[i]),
            ),
          );
        },
      ),
    );
  }
}

class _NotificaTile extends StatelessWidget {
  const _NotificaTile({required this.notifica});

  final NotificaRemota notifica;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: c.outlineVariant.withOpacity(0.5)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _apriDettaglio(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconaCanale(isBroadcast: notifica.isBroadcast, colorScheme: c),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notifica.titolo,
                            style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (notifica.isBroadcast)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: c.secondaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('Broadcast',
                                style: theme.textTheme.labelSmall?.copyWith(
                                    color: c.onSecondaryContainer,
                                    fontWeight: FontWeight.w700)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notifica.corpo,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: c.onSurface.withOpacity(0.65)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(notifica.dataInvio ?? notifica.dataCreazione),
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: c.onSurface.withOpacity(0.45)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  void _apriDettaglio(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _DettaglioNotifica(notifica: notifica),
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm', 'it_IT').format(dt.toLocal());
  }
}

class _IconaCanale extends StatelessWidget {
  const _IconaCanale(
      {required this.isBroadcast, required this.colorScheme});

  final bool isBroadcast;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final icon =
        isBroadcast ? Icons.campaign_outlined : Icons.mark_email_unread_outlined;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: colorScheme.onPrimaryContainer, size: 20),
    );
  }
}

class _DettaglioNotifica extends StatelessWidget {
  const _DettaglioNotifica({required this.notifica});

  final NotificaRemota notifica;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.92,
      builder: (_, ctrl) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: c.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    notifica.titolo,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
                if (notifica.isBroadcast)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: c.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Broadcast',
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: c.onSecondaryContainer,
                            fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(notifica.dataInvio ?? notifica.dataCreazione),
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: c.onSurface.withOpacity(0.50)),
            ),
            const Divider(height: 24),
            Expanded(
              child: SingleChildScrollView(
                controller: ctrl,
                child: Text(
                  notifica.corpo,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(height: 1.7),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Chiudi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm', 'it_IT').format(dt.toLocal());
  }
}
