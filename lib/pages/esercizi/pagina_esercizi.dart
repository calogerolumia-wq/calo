import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/esercizio_remoto.dart';
import '../../stato/fornitori.dart';
import '../../ui/app_ui.dart';

class PaginaEsercizi extends ConsumerStatefulWidget {
  const PaginaEsercizi({super.key});

  @override
  ConsumerState<PaginaEsercizi> createState() => _PaginaEserciziState();
}

class _PaginaEserciziState extends ConsumerState<PaginaEsercizi> {
  final _ricercaController = TextEditingController();
  String? _attrezzo;
  String? _gruppo;

  @override
  void dispose() {
    _ricercaController.dispose();
    super.dispose();
  }

  List<EsercizioRemoto> _filtra(List<EsercizioRemoto> tutti) {
    final q = _ricercaController.text.toLowerCase().trim();
    return tutti.where((e) {
      if (q.isNotEmpty && !e.nome.toLowerCase().contains(q)) return false;
      if (_attrezzo != null &&
          e.attrezzo?.toUpperCase() != _attrezzo!.toUpperCase()) return false;
      if (_gruppo != null &&
          e.gruppoMuscolare?.toUpperCase() != _gruppo!.toUpperCase()) {
        return false;
      }
      return true;
    }).toList();
  }

  String _label(String s) => s
      .split('_')
      .map((w) =>
          w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1).toLowerCase())
      .join(' ');

  @override
  Widget build(BuildContext context) {
    final cfg = ref.watch(fornitoreConfigurazioneApp);
    if (!cfg.featureEsercizi) return const FeatureDisabilitata(titolo: 'Archivio esercizi');

    final asyncEsercizi = ref.watch(fornitoreEserciziRemoti);
    final tuttiEsercizi = asyncEsercizi.valueOrNull ?? [];

    final attrezzi = tuttiEsercizi
        .map((e) => e.attrezzo)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();
    final gruppi = tuttiEsercizi
        .map((e) => e.gruppoMuscolare)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();

    final esercizi = _filtra(tuttiEsercizi);

    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          const _EserciziBackground(),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                scrolledUnderElevation: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                expandedHeight: 168,
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
                            'Esercizi',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: c.onSurface,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Sfoglia il catalogo esercizi.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: c.onSurface
                                  .withOpacity(isDark ? 0.72 : 0.70),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _SearchField(
                            controller: _ricercaController,
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    radius: BorderRadius.circular(AppRadius.xl),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final twoCols = constraints.maxWidth >= 360;

                        final attrezzoField = DropdownButtonFormField<String?>(
                          value: attrezzi.contains(_attrezzo) ? _attrezzo : null,
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: 'Attrezzo'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Tutti'),
                            ),
                            ...attrezzi.map((a) => DropdownMenuItem<String?>(
                                  value: a,
                                  child: Text(_label(a)),
                                )),
                          ],
                          onChanged: (v) => setState(() => _attrezzo = v),
                        );

                        final gruppoField = DropdownButtonFormField<String?>(
                          value: gruppi.contains(_gruppo) ? _gruppo : null,
                          isExpanded: true,
                          decoration: const InputDecoration(
                              labelText: 'Gruppo muscolare'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Tutti'),
                            ),
                            ...gruppi.map((g) => DropdownMenuItem<String?>(
                                  value: g,
                                  child: Text(_label(g)),
                                )),
                          ],
                          onChanged: (v) => setState(() => _gruppo = v),
                        );

                        if (twoCols) {
                          return Row(children: [
                            Expanded(child: attrezzoField),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(child: gruppoField),
                          ]);
                        }
                        return Column(children: [
                          attrezzoField,
                          const SizedBox(height: AppSpacing.md),
                          gruppoField,
                        ]);
                      },
                    ),
                  ),
                ),
              ),

              asyncEsercizi.when(
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(
                        'Errore nel caricamento degli esercizi.',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                data: (_) {
                  if (esercizi.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: AppCard(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          radius: BorderRadius.circular(AppRadius.xl),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 30,
                                color: c.onSurface.withOpacity(0.70),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Nessun esercizio trovato',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Prova a cambiare filtri o ricerca.',
                                style: theme.textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 220.ms).slideY(
                            begin: 0.04, end: 0),
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
                      itemCount: esercizi.length,
                      itemBuilder: (context, index) {
                        return _EsercizioTile(
                          esercizio: esercizi[index],
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
}

class _EserciziBackground extends StatelessWidget {
  const _EserciziBackground();

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
            size: isDark ? 320 : 340,
            opacity: isDark ? 0.10 : 0.07,
          ),
          _GlowBlob(
            alignment: const Alignment(0.95, -0.65),
            color: c.secondary,
            size: isDark ? 280 : 300,
            opacity: isDark ? 0.09 : 0.06,
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

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: c.surface.withOpacity(isDark ? 0.92 : 0.96),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border:
            Border.all(color: c.outline.withOpacity(isDark ? 0.55 : 0.80)),
        boxShadow: [
          BoxShadow(
            color: c.shadow.withOpacity(isDark ? 0.10 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: 'Cerca per nome',
          prefixIcon:
              Icon(Icons.search, color: c.onSurface.withOpacity(0.70)),
          border: InputBorder.none,
          filled: false,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}

class _EsercizioTile extends StatelessWidget {
  const _EsercizioTile({required this.esercizio});

  final EsercizioRemoto esercizio;

  String _label(String s) => s
      .split('_')
      .map((w) =>
          w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1).toLowerCase())
      .join(' ');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    Widget fallback() => Container(
          width: 54,
          height: 54,
          color: c.surfaceVariant.withOpacity(0.7),
          child: Icon(Icons.fitness_center,
              color: c.onSurface.withOpacity(0.65)),
        );

    final immagine = esercizio.immagineUrl != null
        ? Image.network(
            esercizio.immagineUrl!,
            width: 54,
            height: 54,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallback(),
          )
        : fallback();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        radius: BorderRadius.circular(AppRadius.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: immagine,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    esercizio.nome,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            if (esercizio.descrizione != null ||
                esercizio.muscoloTarget != null) ...[
              const SizedBox(height: 8),
              Text(
                esercizio.descrizione ?? esercizio.muscoloTarget!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: c.onSurface.withOpacity(0.78),
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (esercizio.attrezzo != null)
                  _EtichettaEsercizio(testo: _label(esercizio.attrezzo!)),
                if (esercizio.gruppoMuscolare != null)
                  _EtichettaEsercizio(
                      testo: _label(esercizio.gruppoMuscolare!)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EtichettaEsercizio extends StatelessWidget {
  const _EtichettaEsercizio({required this.testo});
  final String testo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: c.surfaceVariant.withOpacity(isDark ? 0.55 : 1.0),
        borderRadius: BorderRadius.circular(999),
        border:
            Border.all(color: c.outline.withOpacity(isDark ? 0.40 : 0.55)),
      ),
      child: Text(
        testo,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: c.onSurface.withOpacity(0.85),
        ),
      ),
    );
  }
}
