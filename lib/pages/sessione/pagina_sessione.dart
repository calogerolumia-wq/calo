import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/archivio_locale.dart';
import '../../utils/navigazione.dart';
import '../schede/pagina_schede.dart';
import 'pagina_sessione_in_corso.dart';
import '../../stato/fornitori.dart';

class PaginaSessione extends ConsumerStatefulWidget {
  const PaginaSessione({super.key});

  @override
  ConsumerState<PaginaSessione> createState() => _PaginaSessioneState();
}

class _PaginaSessioneState extends ConsumerState<PaginaSessione> {
  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    final archivio = ref.watch(fornitoreArchivioLocale);
    final sessioneAsync = ref.watch(gestoreSessioneAttiva);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessione'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: sessioneAsync.when(
          data: (sessione) {
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  sliver: SliverToBoxAdapter(
                    child: _IntestazioneSezione(
                      titolo: sessione != null
                          ? 'Sessione in corso'
                          : 'Avvia una sessione',
                      descrizione: sessione != null
                          ? 'Riprendi da dove hai lasciato.'
                          : 'Seleziona una scheda attiva per iniziare.',
                      icona: sessione != null ? Icons.timer : Icons.fitness_center,
                    ),
                  ),
                ),
                if (sessione != null)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: SliverToBoxAdapter(
                      child: _CardSessioneAttiva(
                        orarioAvvio: _formattaOrario(sessione.inizio),
                        onRiprendi: () => apriPagina(
                          context,
                          PaginaSessioneInCorso(sessioneId: sessione.id),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 220.ms)
                          .slideY(begin: 0.06, end: 0, duration: 220.ms),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: _Suggerimento(
                        testo:
                        'Suggerimento: imposta una sola scheda come “Attiva” per trovarla subito qui.',
                        coloreBordo: colori.primary.withOpacity(0.18),
                        coloreSfondo: colori.primary.withOpacity(0.07),
                      ).animate().fadeIn(duration: 200.ms),
                    ),
                  ),
                if (sessione == null)
                  SliverToBoxAdapter(
                    child: const SizedBox(height: 8),
                  ),
                if (sessione == null)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                    sliver: SliverToBoxAdapter(
                      child: StreamBuilder<List<SchedeData>>(
                        stream: archivio.guardaSchede(soloAttive: true),
                        builder: (context, snapshot) {
                          final schede = snapshot.data ?? [];

                          if (snapshot.connectionState ==
                              ConnectionState.waiting &&
                              schede.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 24),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (schede.isEmpty) {
                            return _EmptyState(
                              titolo: 'Nessuna scheda attiva',
                              descrizione:
                              'Attiva una scheda dalla sezione “Schede” per avviare una sessione.',
                              icona: Icons.play_circle_outline,
                              azione: FilledButton.icon(
                                onPressed: () => vaiAllaPaginaPrincipale(
                                  context,
                                  const PaginaSchede(),
                                ),
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('Vai alle schede'),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 200.ms)
                                .slideY(begin: 0.05, end: 0, duration: 200.ms);
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Schede attive',
                                style: tema.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...List.generate(schede.length, (index) {
                                final scheda = schede[index];
                                return _RigaScheda(
                                  nome: scheda.nomeScheda,
                                  descrizione: scheda.descrizione ??
                                      'Allenamento personalizzato',
                                  onTap: () async {
                                    final idSessione = await ref
                                        .read(gestoreSessioneAttiva.notifier)
                                        .avviaDaScheda(scheda.id);

                                    if (!mounted) return;
                                    apriPagina(
                                      context,
                                      PaginaSessioneInCorso(
                                        sessioneId: idSessione,
                                      ),
                                    );
                                  },
                                )
                                    .animate()
                                    .fadeIn(
                                  duration: 220.ms,
                                  delay: (40 * index).ms,
                                )
                                    .slideY(
                                  begin: 0.06,
                                  end: 0,
                                  duration: 220.ms,
                                  delay: (40 * index).ms,
                                );
                              }),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
              ],
            );
          },
          error: (errore, _) => Center(child: Text('Errore: $errore')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  String _formattaOrario(DateTime data) {
    final ore = data.hour.toString().padLeft(2, '0');
    final minuti = data.minute.toString().padLeft(2, '0');
    return '$ore:$minuti';
  }
}

class _IntestazioneSezione extends StatelessWidget {
  const _IntestazioneSezione({
    required this.titolo,
    required this.descrizione,
    required this.icona,
  });

  final String titolo;
  final String descrizione;
  final IconData icona;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colori.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colori.primary.withOpacity(0.18),
            ),
          ),
          child: Icon(
            icona,
            color: colori.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titolo,
                style: tema.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                descrizione,
                style: tema.textTheme.bodyMedium?.copyWith(
                  color: colori.onSurface.withOpacity(0.75),
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardSessioneAttiva extends StatelessWidget {
  const _CardSessioneAttiva({
    required this.orarioAvvio,
    required this.onRiprendi,
  });

  final String orarioAvvio;
  final VoidCallback onRiprendi;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return Card(
      elevation: 0,
      color: colori.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: colori.primary.withOpacity(0.18),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _Badge(
                  testo: 'ATTIVA',
                  icona: Icons.bolt,
                ),
                const Spacer(),
                Icon(
                  Icons.timer,
                  color: colori.primary.withOpacity(0.90),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Allenamento in corso',
              style: tema.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Avviata alle $orarioAvvio',
              style: tema.textTheme.bodyMedium?.copyWith(
                color: colori.onSurface.withOpacity(0.75),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onRiprendi,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Riprendi sessione'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.testo, required this.icona});

  final String testo;
  final IconData icona;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colori.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colori.primary.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icona, size: 16, color: colori.primary),
          const SizedBox(width: 6),
          Text(
            testo,
            style: tema.textTheme.labelMedium?.copyWith(
              color: colori.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _RigaScheda extends StatelessWidget {
  const _RigaScheda({
    required this.nome,
    required this.descrizione,
    required this.onTap,
  });

  final String nome;
  final String descrizione;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: colori.onSurface.withOpacity(0.08),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          nome,
          style: tema.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            descrizione,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: tema.textTheme.bodyMedium?.copyWith(
              color: colori.onSurface.withOpacity(0.70),
            ),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: colori.onSurface.withOpacity(0.55),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

class _Suggerimento extends StatelessWidget {
  const _Suggerimento({
    required this.testo,
    required this.coloreBordo,
    required this.coloreSfondo,
  });

  final String testo;
  final Color coloreBordo;
  final Color coloreSfondo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: coloreSfondo,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: coloreBordo),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 20, color: colori.onSurface),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              testo,
              style: tema.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.titolo,
    required this.descrizione,
    required this.icona,
    required this.azione,
  });

  final String titolo;
  final String descrizione;
  final IconData icona;
  final Widget azione;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colori.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: colori.primary.withOpacity(0.18)),
            ),
            child: Icon(icona, size: 30, color: colori.primary),
          ),
          const SizedBox(height: 14),
          Text(
            titolo,
            textAlign: TextAlign.center,
            style: tema.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            descrizione,
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyMedium?.copyWith(
              color: colori.onSurface.withOpacity(0.75),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          azione,
        ],
      ),
    );
  }
}
