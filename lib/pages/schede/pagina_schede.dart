import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/scheda_remota.dart';
import '../../stato/fornitori.dart';
import '../../ui/app_ui.dart';
import 'pagina_dettaglio_scheda.dart';

class PaginaSchede extends ConsumerStatefulWidget {
  const PaginaSchede({super.key});

  @override
  ConsumerState<PaginaSchede> createState() => _PaginaSchedeState();
}

class _PaginaSchedeState extends ConsumerState<PaginaSchede>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _mostraAttive = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cfg = ref.watch(fornitoreConfigurazioneApp);
    if (!cfg.featureSchede) return const FeatureDisabilitata(titolo: 'Schede');

    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          const _SchedeBackground(),
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                floating: false,
                elevation: 0,
                scrolledUnderElevation: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                expandedHeight: 148,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                            'Schede',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.4,
                              color: c.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Consulta le schede assegnate e i modelli.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: c.onSurface.withOpacity(0.72),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      indicatorColor: c.primary,
                      indicatorWeight: 2.5,
                      labelColor: c.onSurface,
                      unselectedLabelColor: c.onSurface.withOpacity(0.50),
                      labelStyle: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                      dividerColor: c.outline.withOpacity(0.4),
                      tabs: const [
                        Tab(text: 'Le mie schede'),
                        Tab(text: 'Modelli'),
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      ref.read(fornitoreSchedeRemote.notifier).ricarica();
                      ref.invalidate(fornitoreModelliSchede);
                    },
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Aggiorna',
                  ),
                  const SizedBox(width: 6),
                ],
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _TabMieSchede(
                  mostraAttive: _mostraAttive,
                  onFiltroChanged: (v) => setState(() => _mostraAttive = v),
                ),
                const _TabModelli(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tab: Le mie schede ───────────────────────────────────────────────────────

class _TabMieSchede extends ConsumerWidget {
  const _TabMieSchede({
    required this.mostraAttive,
    required this.onFiltroChanged,
  });

  final bool mostraAttive;
  final ValueChanged<bool> onFiltroChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final schedeAsync = ref.watch(fornitoreSchedeRemote);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
            child: AppCard(
              padding: const EdgeInsets.all(AppSpacing.sm),
              radius: BorderRadius.circular(AppRadius.xl),
              child: _FiltroSegmented(
                mostraAttive: mostraAttive,
                onChanged: onFiltroChanged,
              ),
            ),
          ),
        ),
        schedeAsync.when(
          loading: () => const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_off,
                        size: 38, color: c.error.withOpacity(0.7)),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Impossibile caricare le schede',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text(e.toString().replaceFirst('Exception: ', ''),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Riprova',
                      icon: Icons.refresh,
                      onPressed: () =>
                          ref.read(fornitoreSchedeRemote.notifier).ricarica(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          data: (schede) {
            final filtrate =
                mostraAttive ? schede.where((s) => s.attiva).toList() : schede;

            if (filtrate.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: AppCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      radius: BorderRadius.circular(AppRadius.xl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.view_agenda_outlined,
                              size: 34,
                              color: c.onSurface.withOpacity(0.70)),
                          const SizedBox(height: AppSpacing.sm),
                          Text('Nessuna scheda disponibile',
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w900),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 6),
                          Text(
                            mostraAttive
                                ? 'Non hai schede attive. Passa su "Tutte" per vedere tutte le schede.'
                                : 'Nessuna scheda assegnata al tuo account.',
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.04, end: 0),
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 120),
              sliver: SliverList.builder(
                itemCount: filtrate.length,
                itemBuilder: (context, index) {
                  final scheda = filtrate[index];
                  return _SchedaTile(
                    scheda: scheda,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PaginaDettaglioScheda(scheda: scheda),
                      ),
                    ),
                  ).animate().fadeIn(
                        duration: 320.ms,
                        delay: (28 * index).ms,
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

// ─── Tab: Modelli ─────────────────────────────────────────────────────────────

class _TabModelli extends ConsumerWidget {
  const _TabModelli();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final cfg = ref.watch(fornitoreConfigurazioneApp);

    if (!cfg.featureModelliSchede) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline_rounded,
                  size: 48, color: c.onSurface.withOpacity(0.22)),
              const SizedBox(height: AppSpacing.md),
              Text('Modelli non disponibili',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Questa funzionalità è disabilitata per il tuo account.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: c.onSurface.withOpacity(0.54)),
              ),
            ],
          ),
        ),
      );
    }

    final modelliAsync = ref.watch(fornitoreModelliSchede);

    return modelliAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 38, color: c.error.withOpacity(0.7)),
              const SizedBox(height: AppSpacing.sm),
              Text('Impossibile caricare i modelli',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Riprova',
                icon: Icons.refresh,
                onPressed: () => ref.invalidate(fornitoreModelliSchede),
              ),
            ],
          ),
        ),
      ),
      data: (modelli) {
        if (modelli.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                radius: BorderRadius.circular(AppRadius.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.view_list_outlined,
                        size: 34, color: c.onSurface.withOpacity(0.70)),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Nessun modello disponibile',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text(
                      'Il tuo trainer non ha ancora pubblicato modelli di scheda.',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.04, end: 0),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xs),
                child: Text(
                  'Schede modello configurate dal tuo trainer. Consultale e avvia un allenamento.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: c.onSurface.withOpacity(0.60),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 120),
              sliver: SliverList.builder(
                itemCount: modelli.length,
                itemBuilder: (context, index) {
                  final m = modelli[index];
                  return _ModelloTile(
                    scheda: m,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PaginaDettaglioScheda(scheda: m),
                      ),
                    ),
                  ).animate().fadeIn(
                        duration: 320.ms,
                        delay: (28 * index).ms,
                      );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _SchedeBackground extends StatelessWidget {
  const _SchedeBackground();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final base = Color.alphaBlend(
      Colors.white.withOpacity(isDark ? 0.02 : 0.00),
      c.background,
    );
    final tintTop =
        Color.alphaBlend(c.primary.withOpacity(isDark ? 0.08 : 0.05), base);
    final tintBottom =
        Color.alphaBlend(c.secondary.withOpacity(isDark ? 0.06 : 0.04), base);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tintTop, base, tintBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          _GlowBlob(
            alignment: const Alignment(-0.95, -0.85),
            color: c.primary,
            size: isDark ? 340 : 360,
            opacity: isDark ? 0.10 : 0.07,
          ),
          _GlowBlob(
            alignment: const Alignment(0.95, -0.65),
            color: c.secondary,
            size: isDark ? 300 : 320,
            opacity: isDark ? 0.09 : 0.06,
          ),
          _GlowBlob(
            alignment: const Alignment(0.10, 1.05),
            color: c.tertiary,
            size: isDark ? 400 : 420,
            opacity: isDark ? 0.08 : 0.05,
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({
    required this.alignment,
    required this.color,
    required this.size,
    required this.opacity,
  });

  final Alignment alignment;
  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color.withOpacity(opacity), color.withOpacity(0.0)],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

class _FiltroSegmented extends StatelessWidget {
  const _FiltroSegmented({required this.mostraAttive, required this.onChanged});

  final bool mostraAttive;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final style = ButtonStyle(
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      textStyle: WidgetStateProperty.all(
        theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return c.primary.withOpacity(isDark ? 0.20 : 0.14);
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return c.onSurface;
        return c.onSurface.withOpacity(0.78);
      }),
      side: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return BorderSide(
          color: selected
              ? c.primary.withOpacity(isDark ? 0.55 : 0.45)
              : c.outline.withOpacity(isDark ? 0.45 : 0.70),
          width: 1,
        );
      }),
    );

    return SegmentedButton<bool>(
      style: style,
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(value: true, label: Text('Attive')),
        ButtonSegment(value: false, label: Text('Tutte')),
      ],
      selected: {mostraAttive},
      onSelectionChanged: (values) => onChanged(values.first),
    );
  }
}

class _SchedaTile extends StatelessWidget {
  const _SchedaTile({required this.scheda, required this.onTap});

  final SchedaRemota scheda;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            radius: BorderRadius.circular(AppRadius.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        scheda.nomeScheda,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (scheda.attiva)
                      _StatoPill(label: 'Attiva', color: c.primary),
                    Icon(Icons.chevron_right,
                        color: c.onSurface.withOpacity(0.40)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  scheda.descrizione ?? 'Routine personalizzata',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: c.onSurface.withOpacity(0.78),
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Icon(Icons.bolt_rounded,
                        size: 18, color: c.onSurface.withOpacity(0.80)),
                    const SizedBox(width: 8),
                    Text(
                      scheda.livelloDifficolta ?? 'Standard',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: c.onSurface.withOpacity(0.82),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModelloTile extends StatelessWidget {
  const _ModelloTile({required this.scheda, required this.onTap});

  final SchedaRemota scheda;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            radius: BorderRadius.circular(AppRadius.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: c.tertiary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: c.tertiary.withOpacity(0.22)),
                      ),
                      child: Icon(Icons.view_list_outlined,
                          color: c.tertiary, size: 18),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        scheda.nomeScheda,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatoPill(label: 'Modello', color: c.tertiary),
                    Icon(Icons.chevron_right,
                        color: c.onSurface.withOpacity(0.40)),
                  ],
                ),
                if (scheda.descrizione != null &&
                    scheda.descrizione!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    scheda.descrizione!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: c.onSurface.withOpacity(0.72),
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(Icons.bolt_rounded,
                        size: 16, color: c.onSurface.withOpacity(0.70)),
                    const SizedBox(width: 6),
                    Text(
                      scheda.livelloDifficolta ?? 'Standard',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: c.onSurface.withOpacity(0.70),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatoPill extends StatelessWidget {
  const _StatoPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.18 : 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(isDark ? 0.45 : 0.35)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
