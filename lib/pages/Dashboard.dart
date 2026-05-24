import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/archivio_locale.dart';
import '../stato/fornitori.dart';
import '../ui/app_drawer.dart';
import '../ui/app_ui.dart';
import 'Impostazioni.dart';
import 'calendario/pagina_calendario_allenamenti.dart';
import 'esercizi/pagina_esercizi.dart';
import 'misure/pagina_misure.dart';
import 'schede/pagina_schede.dart';
import 'sessione/pagina_sessione.dart';
import 'sessione/pagina_sessione_in_corso.dart';

class PaginaDashboard extends ConsumerWidget {
  const PaginaDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          const _Background(),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: _Header()),
              _pad(const _HeroCta(), bottom: AppSpacing.md),
              _pad(const _QuickActions(), bottom: AppSpacing.lg),
              _pad(const _ProgressModule()),
              _pad(const _CalendarioModule()),
              _pad(const _MisureModule(), bottom: 96),
            ],
          ),
        ],
      ),
    );
  }

  static SliverPadding _pad(Widget child, {double bottom = AppSpacing.lg}) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, bottom),
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}

// ─── Background ──────────────────────────────────────────────────────────────

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.alphaBlend(c.primary.withOpacity(0.04), c.background),
            c.background,
            Color.alphaBlend(c.tertiary.withOpacity(0.03), c.background),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final now = DateTime.now();

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
        child: Row(
          children: [
            // Logo / drawer button
            GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: c.primary,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: [
                    BoxShadow(
                      color: c.primary.withOpacity(0.28),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(Icons.fitness_center_rounded,
                    color: c.onPrimary, size: 22),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _saluto(now),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formattaDataBreve(now),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: c.onSurface.withOpacity(0.50),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            _CircleButton(
              icon: Icons.settings_outlined,
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const Impostazioni()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: c.surface,
          shape: BoxShape.circle,
          border: Border.all(color: c.outline, width: 1),
          boxShadow: const [_kShadow1],
        ),
        child: Icon(icon, color: c.onSurface, size: 20),
      ),
    );
  }
}

const _kShadow1 = BoxShadow(
  color: Color(0x0D000000),
  blurRadius: 16,
  offset: Offset(0, 5),
);

// ─── Hero CTA ─────────────────────────────────────────────────────────────────

class _HeroCta extends ConsumerWidget {
  const _HeroCta();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessioneAsync = ref.watch(gestoreSessioneAttiva);
    return sessioneAsync.when(
      loading: () => _heroCard(context, child: const _HeroSkeleton()),
      error: (_, __) => _heroCard(
        context,
        child: const AppInlineBanner(
            message: 'Connessione assente: sessione non disponibile.'),
      ),
      data: (sessione) => _heroCard(
        context,
        child: sessione != null
            ? _HeroInCorso(sessione: sessione)
            : const _HeroPronto(),
      ),
    ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.04, end: 0);
  }

  Widget _heroCard(BuildContext context, {required Widget child}) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: child,
    );
  }
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSkeleton(width: 80, height: 26, radius: 999),
        SizedBox(height: AppSpacing.sm),
        AppSkeleton(width: 220, height: 30),
        SizedBox(height: AppSpacing.xs),
        AppSkeleton(width: 160, height: 18),
        SizedBox(height: AppSpacing.md),
        AppSkeleton(width: double.infinity, height: 50, radius: AppRadius.md),
      ],
    );
  }
}

class _HeroInCorso extends StatelessWidget {
  const _HeroInCorso({required this.sessione});
  final SessioniAllenamentoData sessione;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _StatusTag(label: 'IN CORSO', color: c.primary),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Sessione attiva',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Avviata alle ${_formattaOrario(sessione.inizio)}',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: 'Riprendi sessione',
          icon: Icons.play_arrow_rounded,
          expand: true,
          onPressed: () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => PaginaSessioneInCorso(sessioneId: sessione.id),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroPronto extends ConsumerWidget {
  const _HeroPronto();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final schedeAsync = ref.watch(fornitoreSchedeRemote);

    return schedeAsync.when(
      loading: () => const _HeroSkeleton(),
      error: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusTag(label: 'PRONTO', color: c.tertiary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Allenamento libero',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Avvia allenamento',
            icon: Icons.play_arrow_rounded,
            expand: true,
            onPressed: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (_) => const PaginaSessione()),
            ),
          ),
        ],
      ),
      data: (schede) {
        if (schede.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatusTag(label: 'NESSUNA SCHEDA', color: c.secondary),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Inizia da qui',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              Text('Sfoglia le schede disponibili per te.',
                  style: theme.textTheme.bodySmall),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Vai alle schede',
                icon: Icons.view_agenda_outlined,
                expand: true,
                onPressed: () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (_) => const PaginaSchede()),
                ),
              ),
            ],
          );
        }

        final scheda = schede.first;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatusTag(label: 'PRONTO', color: c.tertiary),
            const SizedBox(height: AppSpacing.sm),
            Text(
              scheda.nomeScheda,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (scheda.descrizione != null && scheda.descrizione!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                scheda.descrizione!,
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Avvia allenamento',
              icon: Icons.play_arrow_rounded,
              expand: true,
              onPressed: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const PaginaSessione()),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
      ),
    );
  }
}

// ─── Quick Actions ────────────────────────────────────────────────────────────

class _QuickActions extends ConsumerWidget {
  const _QuickActions();

  void _apri(BuildContext context, Widget page) {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final cfg = ref.watch(fornitoreConfigurazioneApp);

    final items = <_ActionItem>[
      if (cfg.featureSchede)
        _ActionItem(
          title: 'Schede',
          subtitle: 'Piani',
          icon: Icons.view_agenda_outlined,
          color: c.primary,
          onTap: () => _apri(context, const PaginaSchede()),
        ),
      if (cfg.featureEsercizi)
        _ActionItem(
          title: 'Esercizi',
          subtitle: 'Catalogo',
          icon: Icons.bolt_outlined,
          color: const Color(0xFF7C3AED),
          onTap: () => _apri(context, const PaginaEsercizi()),
        ),
      _ActionItem(
        title: 'Calendario',
        subtitle: 'Sessioni',
        icon: Icons.calendar_month_outlined,
        color: const Color(0xFF0EA5E9),
        onTap: () => _apri(context, const PaginaCalendarioAllenamenti()),
      ),
      if (cfg.featureMisurazioni)
        _ActionItem(
          title: 'Misure',
          subtitle: 'Check-in',
          icon: Icons.monitor_weight_outlined,
          color: c.tertiary,
          onTap: () => _apri(context, const PaginaMisure()),
        ),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Accesso rapido', subtitle: null),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (_, constraints) {
            final spacing = AppSpacing.sm;
            final w = (constraints.maxWidth - spacing) / 2;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: items
                  .map((it) => SizedBox(width: w, child: _ActionTile(item: it)))
                  .toList(),
            );
          },
        ),
      ],
    ).animate().fadeIn(duration: 240.ms, delay: 40.ms).slideY(begin: 0.04, end: 0);
  }
}

class _ActionItem {
  const _ActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.item});
  final _ActionItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      radius: BorderRadius.circular(AppRadius.lg),
      onTap: item.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(item.icon, color: item.color, size: 20),
              ),
              Icon(
                Icons.arrow_outward_rounded,
                size: 16,
                color: c.onSurface.withOpacity(0.30),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.title,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            item.subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: c.onSurface.withOpacity(0.48),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Progress Module ──────────────────────────────────────────────────────────

class _ProgressModule extends ConsumerWidget {
  const _ProgressModule();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final archivio = ref.watch(fornitoreArchivioLocale);
    final idUtente = ref.watch(fornitoreIdUtenteCorrente);
    if (idUtente == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Progressi',
          subtitle: 'Ultime 6 settimane',
        ),
        const SizedBox(height: AppSpacing.md),
        StreamBuilder<List<SessioneCalendario>>(
          stream: archivio.guardaSessioniCompletate(idUtente),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const AppInlineBanner(message: 'Progressi non disponibili.');
            }
            if (snapshot.connectionState == ConnectionState.waiting &&
                (snapshot.data ?? []).isEmpty) {
              return const AppSkeleton(
                  height: 160, radius: AppRadius.xl);
            }

            final sessioni = snapshot.data ?? [];

            if (sessioni.isEmpty) {
              return AppCard(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bar_chart_rounded,
                        size: 32, color: c.onSurface.withOpacity(0.25)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Nessun dato ancora',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Completa un allenamento per vedere i tuoi trend.',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Avvia allenamento',
                      icon: Icons.play_arrow_rounded,
                      filled: false,
                      small: true,
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (_) => const PaginaSessione()),
                      ),
                    ),
                  ],
                ),
              );
            }

            final valori = _calcolaTrend(sessioni, 6);
            final maxV = max(1, valori.reduce(max));

            return AppCard(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${sessioni.length} sessioni',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Ultimi 6 mesi',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(valori.length, (i) {
                        final v = valori[i];
                        final h = (v / maxV) * 88;
                        final isLast = i == valori.length - 1;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      height: 88,
                                      decoration: BoxDecoration(
                                        color: c.surfaceVariant,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 350),
                                      curve: Curves.easeOutCubic,
                                      height: max(6.0, h),
                                      decoration: BoxDecoration(
                                        color: isLast
                                            ? c.primary
                                            : c.primary.withOpacity(0.45),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ).animate().fadeIn(duration: 240.ms, delay: 60.ms).slideY(begin: 0.04, end: 0);
  }
}

// ─── Calendario Module ────────────────────────────────────────────────────────

class _CalendarioModule extends ConsumerWidget {
  const _CalendarioModule();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivio = ref.watch(fornitoreArchivioLocale);
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final idUtente = ref.watch(fornitoreIdUtenteCorrente);
    if (idUtente == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Ultime sessioni',
          trailing: TextButton(
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                  builder: (_) => const PaginaCalendarioAllenamenti()),
            ),
            child: const Text('Vedi tutto'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: EdgeInsets.zero,
          child: StreamBuilder<List<SessioneCalendario>>(
            stream: archivio.guardaSessioniCompletate(idUtente),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: AppInlineBanner(
                      message: 'Cronologia non disponibile.'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting &&
                  (snapshot.data ?? []).isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: AppSkeleton(height: 100, radius: AppRadius.lg),
                );
              }

              final list = [...(snapshot.data ?? [])]..sort((a, b) {
                  final da = a.sessione.fine ?? a.sessione.inizio;
                  final db = b.sessione.fine ?? b.sessione.inizio;
                  return db.compareTo(da);
                });

              if (list.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 28,
                          color: c.onSurface.withOpacity(0.25)),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Nessuna sessione',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Avvia il primo allenamento per popolare lo storico.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }

              final items = list.take(3).toList();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    _SessionRow(
                      item: items[i],
                      onTap: () =>
                          Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (_) =>
                                const PaginaCalendarioAllenamenti()),
                      ),
                    ),
                    if (i < items.length - 1)
                      Divider(
                          height: 1,
                          indent: AppSpacing.lg + 48,
                          color: c.outline),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 240.ms, delay: 80.ms).slideY(begin: 0.04, end: 0);
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.item, required this.onTap});
  final SessioneCalendario item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final data = item.sessione.fine ?? item.sessione.inizio;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: c.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(Icons.fitness_center_rounded,
                  color: c.onSurface.withOpacity(0.50), size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nomeScheda,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_formattaDataBreve(data)} · ${_formattaOrario(data)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                size: 18, color: c.onSurface.withOpacity(0.28)),
          ],
        ),
      ),
    );
  }
}

// ─── Misure Module ────────────────────────────────────────────────────────────

class _MisureModule extends ConsumerWidget {
  const _MisureModule();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivio = ref.watch(fornitoreArchivioLocale);
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final idUtente = ref.watch(fornitoreIdUtenteCorrente);
    final cfg = ref.watch(fornitoreConfigurazioneApp);
    if (idUtente == null || !cfg.featureMisurazioni) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Misure corporee',
          trailing: TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (_) => const PaginaMisure()),
            ),
            child: const Text('Vedi tutto'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: StreamBuilder<List<MisurazioniData>>(
            stream: archivio.guardaMisure(idUtente),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const AppInlineBanner(
                    message: 'Misure non disponibili.');
              }
              if (snapshot.connectionState == ConnectionState.waiting &&
                  (snapshot.data ?? []).isEmpty) {
                return const AppSkeleton(height: 110, radius: AppRadius.lg);
              }

              final misure = [...(snapshot.data ?? [])]
                ..sort((a, b) => b.data.compareTo(a.data));

              if (misure.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.monitor_weight_outlined,
                        size: 28,
                        color: c.onSurface.withOpacity(0.25)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Nessuna misura',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text('Fai il primo check-in per tracciare i progressi.',
                        style: theme.textTheme.bodySmall),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Vai alle misure',
                      icon: Icons.arrow_forward,
                      filled: false,
                      small: true,
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(builder: (_) => const PaginaMisure()),
                      ),
                    ),
                  ],
                );
              }

              final last = misure.first;
              final prev = misure.length > 1 ? misure[1] : null;
              final delta = prev != null ? last.peso - prev.peso : null;

              String fmtDelta(double v) {
                final sign = v > 0 ? '+' : '';
                return '$sign${v.toStringAsFixed(1)} kg';
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        last.peso.toStringAsFixed(1),
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Text(
                          'kg',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: c.onSurface.withOpacity(0.45),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (delta != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: (delta <= 0 ? c.tertiary : c.primary)
                                .withOpacity(0.10),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: (delta <= 0 ? c.tertiary : c.primary)
                                  .withOpacity(0.20),
                            ),
                          ),
                          child: Text(
                            fmtDelta(delta),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: delta <= 0 ? c.tertiary : c.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ultima misura: ${_formattaDataBreve(last.data)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (last.percentualeMassaGrassa != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _MisuraRow(
                      icon: Icons.water_drop_outlined,
                      label: 'Massa grassa',
                      value:
                          '${last.percentualeMassaGrassa!.toStringAsFixed(1)}%',
                      color: const Color(0xFF0EA5E9),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 240.ms, delay: 100.ms).slideY(begin: 0.04, end: 0);
  }
}

class _MisuraRow extends StatelessWidget {
  const _MisuraRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Text(label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(value,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

String _saluto(DateTime d) {
  if (d.hour < 12) return 'Buongiorno';
  if (d.hour < 18) return 'Buon pomeriggio';
  return 'Buonasera';
}

String _formattaOrario(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

String _formattaDataBreve(DateTime d) {
  const g = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
  const m = [
    'Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu',
    'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic'
  ];
  return '${g[d.weekday - 1]} ${d.day} ${m[d.month - 1]}';
}

List<int> _calcolaTrend(List<SessioneCalendario> sessioni, int settimane) {
  final now = DateTime.now();
  final valori = List<int>.filled(settimane, 0);
  for (final s in sessioni) {
    final data = s.sessione.fine ?? s.sessione.inizio;
    final diff = now.difference(data).inDays;
    if (diff < 0) continue;
    final idx = (settimane - 1) - (diff ~/ 7);
    if (idx >= 0 && idx < settimane) valori[idx]++;
  }
  return valori;
}
