import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/archivio_locale.dart';
import '../../stato/fornitori.dart';
import '../../ui/app_ui.dart';
import '../esercizi/pagina_esercizi.dart';
import 'pagina_dettaglio_scheda.dart';
import 'pagina_editor_scheda.dart';

enum FiltroSchede { tutte, attive, modelli }

class PaginaSchede extends ConsumerStatefulWidget {
  const PaginaSchede({super.key});

  @override
  ConsumerState<PaginaSchede> createState() => _PaginaSchedeState();
}

class _PaginaSchedeState extends ConsumerState<PaginaSchede> {
  FiltroSchede filtro = FiltroSchede.attive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final archivio = ref.watch(fornitoreArchivioLocale);

    final soloAttive = filtro == FiltroSchede.attive;
    final soloModelli = filtro == FiltroSchede.modelli;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _apriNuovaScheda(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuova scheda'),
      ),
      body: Stack(
        children: [
          const _SchedeBackground(),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                scrolledUnderElevation: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                expandedHeight: 152,
                actions: [
                  IconButton(
                    onPressed: () => _apriEsercizi(context),
                    icon: const Icon(Icons.fitness_center),
                    tooltip: 'Esercizi',
                  ),
                  const SizedBox(width: 6),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.md,
                      ),
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
                            'Organizza allenamenti, modelli e routine.',
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
              ),

              // Filtro (segmented) dentro card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    radius: BorderRadius.circular(AppRadius.xl),
                    child: _FiltroSchedeSegmented(
                      value: filtro,
                      onChanged: (v) => setState(() => filtro = v),
                    ),
                  ),
                ),
              ),

              StreamBuilder<List<SchedeData>>(
                stream: archivio.guardaSchede(
                  soloAttive: soloAttive,
                  soloModelli: soloModelli,
                ),
                builder: (context, snapshot) {
                  final schede = snapshot.data ?? [];

                  if (schede.isEmpty) {
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
                                Icon(
                                  Icons.view_agenda_outlined,
                                  size: 34,
                                  color: c.onSurface.withOpacity(0.70),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Nessuna scheda disponibile',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Crea una scheda o passa su “Tutte/Modelli”.',
                                  style: theme.textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                AppButton(
                                  label: 'Crea scheda',
                                  icon: Icons.add,
                                  onPressed: () => _apriNuovaScheda(context),
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
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      120,
                    ),
                    sliver: SliverList.builder(
                      itemCount: schede.length,
                      itemBuilder: (context, index) {
                        final scheda = schede[index];

                        return _SchedaTile(
                          scheda: scheda,
                          onTap: () => _apriDettaglioScheda(context, scheda.id),
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
          ),
        ],
      ),
    );
  }

  void _apriDettaglioScheda(BuildContext context, int idScheda) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaginaDettaglioScheda(schedaId: idScheda),
      ),
    );
  }

  void _apriNuovaScheda(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PaginaEditorScheda()),
    );
  }

  void _apriEsercizi(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PaginaEsercizi()),
    );
  }
}

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

    final tintTop = Color.alphaBlend(c.primary.withOpacity(isDark ? 0.08 : 0.05), base);
    final tintBottom = Color.alphaBlend(c.secondary.withOpacity(isDark ? 0.06 : 0.04), base);

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
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.transparent,
                    base.withOpacity(isDark ? 0.30 : 0.14),
                  ],
                  radius: 1.10,
                  center: Alignment.topCenter,
                ),
              ),
            ),
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
              colors: [
                color.withOpacity(opacity),
                color.withOpacity(0.0),
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

class _FiltroSchedeSegmented extends StatelessWidget {
  const _FiltroSchedeSegmented({
    required this.value,
    required this.onChanged,
  });

  final FiltroSchede value;
  final ValueChanged<FiltroSchede> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final style = ButtonStyle(
      // rende i segmenti più “app-like”
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
        if (states.contains(WidgetState.selected)) {
          return c.onSurface;
        }
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

    return SegmentedButton<FiltroSchede>(
      style: style,
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(value: FiltroSchede.tutte, label: Text('Tutte')),
        ButtonSegment(value: FiltroSchede.attive, label: Text('Attive')),
        ButtonSegment(value: FiltroSchede.modelli, label: Text('Modelli')),
      ],
      selected: {value},
      onSelectionChanged: (values) => onChanged(values.first),
    );
  }
}

class _SchedaTile extends StatelessWidget {
  const _SchedaTile({
    required this.scheda,
    required this.onTap,
  });

  final SchedeData scheda;
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
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (scheda.modello)
                      _StatoPill(label: 'Modello', color: c.secondary),
                    if (scheda.attiva)
                      _StatoPill(label: 'Attiva', color: c.primary),
                    Icon(Icons.chevron_right, color: c.onSurface.withOpacity(0.40)),
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
                    Icon(Icons.bolt_rounded, size: 18, color: c.onSurface.withOpacity(0.80)),
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
