import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/archivio_locale.dart';
import '../stato/fornitori.dart';
import '../ui/app_drawer.dart';
import '../ui/app_ui.dart';
import '../utils/immagini_esercizi.dart';
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
          const _DashboardBackground(),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: _DashboardHeader()),

              _sliverSection(const _HeroCta(), bottom: AppSpacing.md),

              // ✅ GRID principale: Schede / Esercizi / Calendario / Misure
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                sliver: SliverToBoxAdapter(
                  child: _QuickActionsGrid(),
                ),
              ),

              // ✅ Progressi sotto la grid (grande)
              _sliverSection(const _ProgressModule()),

              // ✅ Moduli “migliori”
              _sliverSection(const _CalendarioMigliorato()),
              _sliverSection(const _MisureMigliorate(), bottom: 90),
            ],
          ),
        ],
      ),
    );
  }

  static SliverPadding _sliverSection(
      Widget child, {
        double top = 0,
        double bottom = AppSpacing.lg,
      }) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, top, AppSpacing.lg, bottom),
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}

class _DashboardBackground extends StatelessWidget {
  const _DashboardBackground();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // In dark: schiarisco leggermente con surface per non “chiudere” tutto
    final base = Color.alphaBlend(
      Colors.white.withOpacity(isDark ? 0.02 : 0.00),
      c.background,
    );

    final tintTop = Color.alphaBlend(
      c.primary.withOpacity(isDark ? 0.08 : 0.06),
      base,
    );

    final tintBottom = Color.alphaBlend(
      c.secondary.withOpacity(isDark ? 0.06 : 0.05),
      base,
    );

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
            size: isDark ? 330 : 360,
            opacity: isDark ? 0.12 : 0.09,
          ),
          _GlowBlob(
            alignment: const Alignment(0.95, -0.65),
            color: c.secondary,
            size: isDark ? 290 : 320,
            opacity: isDark ? 0.10 : 0.08,
          ),
          _GlowBlob(
            alignment: const Alignment(0.20, 1.05),
            color: c.tertiary,
            size: isDark ? 360 : 420,
            opacity: isDark ? 0.08 : 0.06,
          ),

          // vignette leggera
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

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final now = DateTime.now();

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Scaffold.of(context).openDrawer(),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Ink(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    gradient: LinearGradient(
                      colors: [
                        c.primary.withOpacity(0.95),
                        c.secondary.withOpacity(0.95),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: c.primary.withOpacity(isDark ? 0.14 : 0.10),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(Icons.fitness_center, color: c.onPrimary, size: 22),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _saluto(now),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Oggi • ${_formattaDataBreve(now)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: c.onSurface.withOpacity(0.72),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            _HeaderIconButton(
              icon: Icons.settings_outlined,
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (_) => const Impostazioni()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: c.surface.withOpacity(isDark ? 0.92 : 1.0),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: c.outline.withOpacity(isDark ? 0.55 : 0.80)),
            boxShadow: [
              BoxShadow(
                color: c.shadow.withOpacity(isDark ? 0.10 : 0.06),
                blurRadius: 14,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(icon, color: c.onSurface),
        ),
      ),
    );
  }
}

class _HeroCta extends ConsumerWidget {
  const _HeroCta();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final archivio = ref.watch(fornitoreArchivioLocale);
    final sessioneAsync = ref.watch(gestoreSessioneAttiva);

    final heroGradient = LinearGradient(
      colors: [
        Color.alphaBlend(c.primary.withOpacity(isDark ? 0.14 : 0.10), c.surface),
        Color.alphaBlend(c.secondary.withOpacity(isDark ? 0.10 : 0.07), c.surface),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return AppCard(
      gradient: heroGradient,
      child: sessioneAsync.when(
        loading: () => const _HeroSkeleton(),
        error: (_, __) => const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppInlineBanner(message: 'Offline: impossibile caricare la sessione attiva.'),
          ],
        ),
        data: (sessione) {
          if (sessione != null) return _HeroInCorso(sessione: sessione);
          return _HeroPronto(archivio: archivio);
        },
      ),
    ).animate().fadeIn(duration: 240.ms).slideY(begin: 0.05, end: 0);
  }
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        AppSkeleton(width: 120, height: 22),
        SizedBox(height: AppSpacing.sm),
        AppSkeleton(width: 220, height: 26),
        SizedBox(height: AppSpacing.xs),
        AppSkeleton(width: 180, height: 16),
        SizedBox(height: AppSpacing.md),
        AppSkeleton(width: double.infinity, height: 48, radius: AppRadius.lg),
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
      children: [
        _StatusPill(label: 'IN CORSO', color: c.primary, icon: Icons.bolt),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Continua allenamento',
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          'Avviato alle ${_formattaOrario(sessione.inizio)}',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Riprendi sessione',
          icon: Icons.play_arrow,
          expand: true,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => PaginaSessioneInCorso(sessioneId: sessione.id),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _HeroPronto extends StatelessWidget {
  const _HeroPronto({required this.archivio});
  final ArchivioLocale archivio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return StreamBuilder<List<SchedeData>>(
      stream: archivio.guardaSchede(soloAttive: true),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const AppInlineBanner(message: 'Offline: schede non disponibili.');
        }

        final schede = snapshot.data ?? [];
        if (snapshot.connectionState == ConnectionState.waiting && schede.isEmpty) {
          return const _HeroSkeleton();
        }

        if (schede.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatusPill(label: 'RIPOSO', color: c.secondary, icon: Icons.self_improvement),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Crea la tua prima scheda',
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                'Definisci il tuo piano e inizia ad allenarti.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Crea scheda',
                icon: Icons.add,
                expand: true,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (_) => const PaginaSchede()),
                  );
                },
              ),
            ],
          );
        }

        final scheda = schede.first;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusPill(label: 'PRONTO', color: c.primary, icon: Icons.check_circle),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Allenamento pronto',
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              scheda.nomeScheda,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            _FocusScheda(archivio: archivio, schedaId: scheda.id),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Avvia allenamento',
              icon: Icons.play_arrow,
              expand: true,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (_) => const PaginaSessione()),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _SuggerimentoEsercizio(archivio: archivio),
          ],
        );
      },
    );
  }
}

class _SuggerimentoEsercizio extends StatelessWidget {
  const _SuggerimentoEsercizio({required this.archivio});
  final ArchivioLocale archivio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return StreamBuilder<List<EserciziData>>(
      stream: archivio.guardaEsercizi(),
      builder: (context, snapshot) {
        final esercizi = snapshot.data ?? [];
        if (esercizi.isEmpty) return const SizedBox.shrink();

        final esercizio = esercizi.first;
        final percorso = percorsoImmagineEsercizio(esercizio);
        final usaAsset = immagineEAsset(percorso);

        Widget fallback() => Container(
          width: 46,
          height: 46,
          color: c.surfaceVariant,
          child: Icon(Icons.image, color: c.onSurface.withOpacity(0.75)),
        );

        final immagine = usaAsset
            ? Image.asset(
          percorso,
          width: 46,
          height: 46,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback(),
        )
            : Image.file(
          File(percorso),
          width: 46,
          height: 46,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback(),
        );

        return Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: immagine,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Esercizio suggerito: ${esercizio.nome}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FocusScheda extends StatelessWidget {
  const _FocusScheda({required this.archivio, required this.schedaId});
  final ArchivioLocale archivio;
  final int schedaId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<EsercizioInScheda>>(
      stream: archivio.guardaEserciziScheda(schedaId),
      builder: (context, snapshot) {
        final elementi = snapshot.data ?? [];
        final focus = elementi.isEmpty
            ? 'Focus principale'
            : _normalizzaSezione(elementi.first.sezione);

        return Text('Focus: $focus', style: theme.textTheme.bodySmall);
      },
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.18 : 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(isDark ? 0.45 : 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ Grid tap principali (niente più “metriche rapide”)
class _QuickActionsGrid extends StatelessWidget {
  _QuickActionsGrid();

  void _open(BuildContext context, Widget page) {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final items = <_ActionItem>[
      _ActionItem(
        title: 'Schede',
        subtitle: 'Piani e modelli',
        icon: Icons.view_agenda,
        onTap: () => _open(context, const PaginaSchede()),
      ),
      _ActionItem(
        title: 'Esercizi',
        subtitle: 'Database',
        icon: Icons.list_alt,
        onTap: () => _open(context, const PaginaEsercizi()),
      ),
      _ActionItem(
        title: 'Calendario',
        subtitle: 'Sessioni',
        icon: Icons.calendar_month,
        onTap: () => _open(context, const PaginaCalendarioAllenamenti()),
      ),
      _ActionItem(
        title: 'Misure',
        subtitle: 'Check-in',
        icon: Icons.monitor_weight_outlined,
        onTap: () => _open(context, const PaginaMisure()),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final spacing = AppSpacing.sm;
        final crossAxisCount = w < 360 ? 2 : 2; // phone: 2x2 pulito
        final tileWidth = (w - (crossAxisCount - 1) * spacing) / crossAxisCount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Dashboard',
              subtitle: 'Vai dritto al punto.',
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: items
                  .map((it) => SizedBox(
                width: tileWidth,
                child: _ActionTile(item: it),
              ))
                  .toList(),
            ),
          ],
        ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.04, end: 0);
      },
    );
  }
}

class _ActionItem {
  const _ActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.item});
  final _ActionItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final borderGlow = LinearGradient(
      colors: [
        c.primary.withOpacity(isDark ? 0.55 : 0.45),
        c.secondary.withOpacity(isDark ? 0.40 : 0.30),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Ink(
          decoration: BoxDecoration(
            gradient: borderGlow,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.4),
            child: AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              radius: BorderRadius.circular(AppRadius.lg - 2),
              useShadow: true,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.arrow_outward_rounded,
                      size: 18,
                      color: c.onSurface.withOpacity(0.55),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: c.primary.withOpacity(isDark ? 0.18 : 0.14),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(color: c.primary.withOpacity(isDark ? 0.25 : 0.20)),
                        ),
                        child: Icon(item.icon, color: c.primary),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressModule extends ConsumerWidget {
  const _ProgressModule();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final archivio = ref.watch(fornitoreArchivioLocale);
    final idUtente = ref.watch(fornitoreIdUtenteCorrente);

    if (idUtente == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Progressi',
          subtitle: 'Frequenza degli ultimi allenamenti.',
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
              return const AppSkeleton(height: 180, radius: AppRadius.xl);
            }

            final sessioni = snapshot.data ?? [];
            if (sessioni.isEmpty) {
              return AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nessun dato disponibile',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Completa un allenamento per vedere i tuoi trend.',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Avvia allenamento',
                      icon: Icons.play_arrow,
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(builder: (_) => const PaginaSessione()),
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            final valori = _calcolaTrendSettimanale(sessioni, 6);
            final maxValore = max(1, valori.reduce(max));

            return AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ultime 6 settimane',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: valori.map((valore) {
                        final h = (valore / maxValore) * 120;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: c.surfaceVariant.withOpacity(isDark ? 0.55 : 1.0),
                                    borderRadius: BorderRadius.circular(AppRadius.sm),
                                    border: Border.all(
                                      color: c.outline.withOpacity(isDark ? 0.35 : 0.55),
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 280),
                                  curve: Curves.easeOutCubic,
                                  height: max(8, h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppRadius.sm),
                                    gradient: LinearGradient(
                                      colors: [
                                        c.primary,
                                        c.secondary.withOpacity(0.85),
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ).animate().fadeIn(duration: 240.ms, delay: 40.ms).slideY(begin: 0.05, end: 0);
  }
}

class _CalendarioMigliorato extends ConsumerWidget {
  const _CalendarioMigliorato();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivio = ref.watch(fornitoreArchivioLocale);
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final idUtente = ref.watch(fornitoreIdUtenteCorrente);

    if (idUtente == null) {
      return const SizedBox.shrink();
    }

    if (idUtente == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Calendario allenamenti',
          subtitle: 'Le ultime sessioni completate.',
          trailing: TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const PaginaCalendarioAllenamenti()),
              );
            },
            child: const Text('Apri'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: StreamBuilder<List<SessioneCalendario>>(
            stream: archivio.guardaSessioniCompletate(idUtente),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const AppInlineBanner(message: 'Cronologia non disponibile.');
              }

              final list = (snapshot.data ?? []).toList();
              list.sort((a, b) {
                final da = a.sessione.fine ?? a.sessione.inizio;
                final db = b.sessione.fine ?? b.sessione.inizio;
                return db.compareTo(da);
              });

              if (snapshot.connectionState == ConnectionState.waiting && list.isEmpty) {
                return const AppSkeleton(height: 110, radius: AppRadius.lg);
              }

              if (list.isEmpty) {
                return _EmptyState(
                  icon: Icons.calendar_month,
                  title: 'Nessuna sessione ancora',
                  subtitle: 'Avvia e completa un allenamento per popolare lo storico.',
                  actionLabel: 'Avvia allenamento',
                  onAction: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (_) => const PaginaSessione()),
                    );
                  },
                );
              }

              final items = list.take(2).toList();
              return Column(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    _TimelineRow(
                      icon: Icons.fitness_center,
                      title: items[i].nomeScheda,
                      subtitle:
                      '${_formattaDataBreve(items[i].sessione.fine ?? items[i].sessione.inizio)} • ${_formattaOrario(items[i].sessione.fine ?? items[i].sessione.inizio)}',
                      trailing: Icon(Icons.chevron_right, color: c.onSurface.withOpacity(0.50)),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(builder: (_) => const PaginaCalendarioAllenamenti()),
                        );
                      },
                    ),
                    if (i != items.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Divider(height: 1, color: c.outline.withOpacity(0.55)),
                      ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 240.ms, delay: 60.ms).slideY(begin: 0.05, end: 0);
  }
}

class _MisureMigliorate extends ConsumerWidget {
  const _MisureMigliorate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivio = ref.watch(fornitoreArchivioLocale);
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    final idUtente = ref.watch(fornitoreIdUtenteCorrente);

    if (idUtente == null) {
      return const SizedBox.shrink();
    }

    if (idUtente == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Misure',
          subtitle: 'Ultimo check-in e variazione.',
          trailing: TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const PaginaMisure()),
              );
            },
            child: const Text('Apri'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: StreamBuilder<List<MisurazioniData>>(
            stream: archivio.guardaMisure(idUtente),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const AppInlineBanner(message: 'Misure non disponibili.');
              }

              final misure = (snapshot.data ?? []).toList();
              misure.sort((a, b) => b.data.compareTo(a.data));

              if (snapshot.connectionState == ConnectionState.waiting && misure.isEmpty) {
                return const AppSkeleton(height: 120, radius: AppRadius.lg);
              }

              if (misure.isEmpty) {
                return _EmptyState(
                  icon: Icons.monitor_weight_outlined,
                  title: 'Nessuna misura registrata',
                  subtitle: 'Fai un check-in per tracciare i progressi.',
                  actionLabel: 'Vai alle misure',
                  onAction: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (_) => const PaginaMisure()),
                    );
                  },
                );
              }

              final last = misure.first;
              final prev = misure.length > 1 ? misure[1] : null;
              final delta = prev == null ? null : (last.peso - prev.peso);

              String fmtDelta(double v) {
                final sign = v >= 0 ? '+' : '';
                return '$sign${v.toStringAsFixed(1)} kg';
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${last.peso.toStringAsFixed(1)}',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          'kg',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: c.onSurface.withOpacity(0.75),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (delta != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: c.surfaceVariant.withOpacity(0.70),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: c.outline.withOpacity(0.55)),
                          ),
                          child: Text(
                            'Δ ${fmtDelta(delta)}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: c.onSurface.withOpacity(0.85),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Ultima misura: ${_formattaDataBreve(last.data)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (prev != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Confronto: ${_formattaDataBreve(prev.data)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: c.onSurface.withOpacity(0.72),
                      ),
                    ),
                  ],
                  if (last.percentualeMassaGrassa != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _TimelineRow(
                      icon: Icons.water_drop_outlined,
                      title: 'Massa grassa',
                      subtitle: '${last.percentualeMassaGrassa!.toStringAsFixed(1)}%',
                      trailing: Icon(Icons.chevron_right, color: c.onSurface.withOpacity(0.50)),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(builder: (_) => const PaginaMisure()),
                        );
                      },
                    ),
                  ] else ...[
                    const SizedBox(height: AppSpacing.md),
                    _TimelineRow(
                      icon: Icons.insights_outlined,
                      title: 'Dettagli e storico',
                      subtitle: 'Apri le misure per vedere tutto.',
                      trailing: Icon(Icons.chevron_right, color: c.onSurface.withOpacity(0.50)),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(builder: (_) => const PaginaMisure()),
                        );
                      },
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 240.ms, delay: 80.ms).slideY(begin: 0.05, end: 0);
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c.primary.withOpacity(isDark ? 0.18 : 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: c.primary.withOpacity(isDark ? 0.25 : 0.20)),
                ),
                child: Icon(icon, color: c.primary, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 28, color: c.onSurface.withOpacity(0.75)),
        const SizedBox(height: AppSpacing.sm),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(subtitle, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: actionLabel,
          icon: Icons.arrow_forward,
          filled: false,
          onPressed: onAction,
        ),
      ],
    );
  }
}

String _saluto(DateTime data) {
  final ora = data.hour;
  if (ora < 12) return 'Buongiorno';
  if (ora < 18) return 'Buon pomeriggio';
  return 'Buonasera';
}

String _formattaOrario(DateTime data) {
  final ore = data.hour.toString().padLeft(2, '0');
  final minuti = data.minute.toString().padLeft(2, '0');
  return '$ore:$minuti';
}

String _formattaDataBreve(DateTime data) {
  const giorni = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
  const mesi = ['Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu', 'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic'];
  final giorno = giorni[data.weekday - 1];
  final mese = mesi[data.month - 1];
  return '$giorno ${data.day} $mese';
}

List<int> _calcolaTrendSettimanale(List<SessioneCalendario> sessioni, int settimane) {
  final now = DateTime.now();
  final valori = List<int>.filled(settimane, 0);

  for (final sessione in sessioni) {
    final data = sessione.sessione.fine ?? sessione.sessione.inizio;
    final diff = now.difference(data).inDays;
    if (diff < 0) continue;
    final indice = (settimane - 1) - (diff ~/ 7);
    if (indice >= 0 && indice < settimane) valori[indice] += 1;
  }

  return valori;
}

String _normalizzaSezione(String sezione) {
  final pulita = sezione.trim();
  return pulita.isEmpty ? 'Allenamento' : pulita;
}
