import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/esercizio_sessione.dart';
import '../../models/scheda_remota.dart';
import '../../stato/fornitori.dart';
import '../../utils/api_config.dart';
import '../../utils/navigazione.dart';
import '../sessione/pagina_sessione_in_corso.dart';

class PaginaDettaglioScheda extends ConsumerWidget {
  const PaginaDettaglioScheda({super.key, required this.scheda});

  final SchedaRemota scheda;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;
    final eserciziAsync = ref.watch(fornitoreEserciziSchedaRemota(scheda.id));

    return Scaffold(
      body: eserciziAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 38, color: colori.error),
                const SizedBox(height: 12),
                Text(
                  'Errore nel caricamento degli esercizi',
                  style: tema.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString().replaceFirst('Exception: ', ''),
                  style: tema.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        data: (esercizi) {
          if (esercizi.isEmpty) {
            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(context, colori, tema),
                _buildCtaSessione(context, ref, esercizi),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _BoxVuoto(
                      titolo: 'Scheda senza esercizi',
                      descrizione:
                          'Aggiungi esercizi a questa scheda dal pannello web.',
                      icona: Icons.playlist_add,
                    ),
                  ),
                ),
              ],
            );
          }

          final gruppi = _raggruppaPerGiorno(esercizi);

          return DefaultTabController(
            length: gruppi.length,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                _buildSliverAppBar(
                  context,
                  colori,
                  tema,
                  tabBar: TabBar(
                    isScrollable: true,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 4,
                        color: colori.primary,
                      ),
                      borderRadius: BorderRadius.circular(999),
                      insets: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: tema.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    labelColor: colori.primary,
                    unselectedLabelColor: colori.onSurface.withOpacity(0.6),
                    tabs: gruppi
                        .map((g) => Tab(text: g.nome))
                        .toList(),
                  ),
                ),
                _buildCtaSessione(context, ref, esercizi),
              ],
              body: TabBarView(
                children: gruppi
                    .map(
                      (g) => _TabSezioneEsercizi(
                        key: PageStorageKey('sezione_${g.nome}'),
                        gruppo: g,
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(
    BuildContext context,
    ColorScheme colori,
    ThemeData tema, {
    PreferredSizeWidget? tabBar,
  }) {
    final tabBarHeight = tabBar == null ? 0.0 : kTextTabBarHeight + 6;
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: true,
      expandedHeight: tabBar == null ? 170 : 210,
      title: const Text('Scheda'),
      bottom: tabBar == null
          ? null
          : PreferredSize(
              preferredSize: Size.fromHeight(tabBarHeight),
              child: Container(
                decoration: BoxDecoration(
                  color: colori.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: colori.onSurface.withOpacity(0.08),
                    ),
                  ),
                ),
                child: tabBar,
              ),
            ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: colori.primary.withOpacity(0.12),
            border: Border(
              bottom: BorderSide(
                color: colori.onSurface.withOpacity(0.08),
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scheda.nomeScheda,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tema.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      scheda.descrizione ?? 'Piano di allenamento personalizzato',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: colori.onSurface.withOpacity(0.75),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ChipInfo(
                          icona: Icons.bolt,
                          testo: scheda.livelloDifficolta ?? 'Standard',
                        ),
                        _ChipInfo(
                          icona: Icons.check_circle_outline,
                          testo: scheda.attiva ? 'Attiva' : 'Inattiva',
                        ),
                      ],
                    ),
                    SizedBox(height: tabBarHeight),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildCtaSessione(
    BuildContext context,
    WidgetRef ref,
    List<EsercizioInSchedaRemota> esercizi,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () async {
              try {
                final idSessione = await ref
                    .read(gestoreSessioneAttiva.notifier)
                    .avviaDaSchedaRemota(scheda, esercizi);
                if (!context.mounted) return;
                apriPagina(
                  context,
                  PaginaSessioneInCorso(
                    sessioneId: idSessione,
                    esercizi: esercizi
                        .asMap()
                        .entries
                        .map(
                          (e) => EsercizioSessione.fromRemoto(
                            e.value,
                            e.key + 1,
                          ),
                        )
                        .toList(),
                    scheda: scheda,
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Errore: $e')),
                );
              }
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Avvia sessione'),
          ),
        ),
      ),
    );
  }

  List<_GruppoSezione> _raggruppaPerGiorno(
      List<EsercizioInSchedaRemota> esercizi) {
    final mappa = <int, List<EsercizioInSchedaRemota>>{};
    for (final e in esercizi) {
      (mappa[e.giorno] ??= []).add(e);
    }
    final giorni = mappa.keys.toList()..sort();
    return giorni.map((g) {
      final nome = g == 0 ? 'Allenamento' : 'Giorno $g';
      return _GruppoSezione(nome: nome, elementi: mappa[g]!);
    }).toList();
  }
}

List<Widget> _buildListaConSuperset(List<EsercizioInSchedaRemota> elementi) {
  final sorted = [...elementi]..sort((a, b) {
      final ga = a.supersetGruppo ?? 999;
      final gb = b.supersetGruppo ?? 999;
      return ga - gb;
    });

  final result = <Widget>[];
  int? lastGruppo;
  for (final e in sorted) {
    if (e.supersetGruppo != null && e.supersetGruppo != lastGruppo) {
      result.add(_SupersetHeader(gruppo: e.supersetGruppo!));
      lastGruppo = e.supersetGruppo;
    } else if (e.supersetGruppo == null) {
      lastGruppo = null;
    }
    result.add(_RigaEsercizio(elemento: e));
  }
  return result;
}

String _formatRecupero(int sec) {
  final m = sec ~/ 60;
  final s = sec % 60;
  if (m > 0 && s > 0) return '${m}m ${s}s';
  if (m > 0) return '$m min';
  return '${s}s';
}

Color _supersetColor(int gruppo) {
  const colors = [
    Color(0xFF3B82F6),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFF8B5CF6),
  ];
  return colors[(gruppo - 1) % colors.length];
}

String _supersetLabel(int gruppo) {
  const labels = ['A', 'B', 'C', 'D'];
  return labels[(gruppo - 1) % labels.length];
}

class _GruppoSezione {
  const _GruppoSezione({required this.nome, required this.elementi});
  final String nome;
  final List<EsercizioInSchedaRemota> elementi;
}

class _TabSezioneEsercizi extends StatelessWidget {
  const _TabSezioneEsercizi({super.key, required this.gruppo});

  final _GruppoSezione gruppo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: colori.primary.withOpacity(0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colori.primary.withOpacity(0.18)),
          ),
          child: Row(
            children: [
              Icon(Icons.view_agenda, color: colori.primary),
              const SizedBox(width: 10),
              Text(
                'Esercizi (${gruppo.elementi.length})',
                style: tema.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ..._buildListaConSuperset(gruppo.elementi),
      ],
    );
  }
}

class _SupersetHeader extends StatelessWidget {
  const _SupersetHeader({required this.gruppo});
  final int gruppo;

  @override
  Widget build(BuildContext context) {
    final colore = _supersetColor(gruppo);
    final label = _supersetLabel(gruppo);
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colore.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: colore.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.swap_horiz_rounded, size: 14, color: colore),
                const SizedBox(width: 5),
                Text(
                  'Superset $label',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colore,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: colore.withOpacity(0.3), thickness: 1)),
        ],
      ),
    );
  }
}

class _RigaEsercizio extends StatelessWidget {
  const _RigaEsercizio({required this.elemento});

  final EsercizioInSchedaRemota elemento;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;
    final haSuperset = elemento.supersetGruppo != null;
    final coloreSuperset = haSuperset ? _supersetColor(elemento.supersetGruppo!) : null;

    final ripsText = (elemento.ripetizioniSchema?.isNotEmpty == true)
        ? elemento.ripetizioniSchema!
        : '${elemento.ripetizioni} rep';
    final pesoText = (elemento.pesoSchema?.isNotEmpty == true)
        ? elemento.pesoSchema!
        : (elemento.pesoTarget != null && elemento.pesoTarget! > 0
            ? '${elemento.pesoTarget} kg'
            : null);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: haSuperset
              ? coloreSuperset!.withOpacity(0.4)
              : colori.onSurface.withOpacity(0.08),
          width: haSuperset ? 1.5 : 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (haSuperset)
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: coloreSuperset,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: _ImmagineEsercizio(url: elemento.immagineUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                elemento.nomeEsercizio,
                                style: tema.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              if (elemento.gruppoMuscolare != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  elemento.gruppoMuscolare!,
                                  style: tema.textTheme.bodySmall?.copyWith(
                                    color: colori.onSurface.withOpacity(0.65),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ChipInfo(icona: Icons.repeat, testo: '${elemento.serie} serie'),
                        _ChipInfo(icona: Icons.refresh, testo: ripsText),
                        if (pesoText != null)
                          _ChipInfo(icona: Icons.scale, testo: pesoText),
                        if (elemento.recuperoSecondi != null)
                          _ChipInfo(
                            icona: Icons.timer_outlined,
                            testo: _formatRecupero(elemento.recuperoSecondi!),
                          ),
                      ],
                    ),
                    if (elemento.note?.isNotEmpty == true) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.notes_rounded, size: 13, color: colori.onSurface.withOpacity(0.5)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              elemento.note!,
                              style: tema.textTheme.bodySmall?.copyWith(
                                color: colori.onSurface.withOpacity(0.6),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImmagineEsercizio extends StatelessWidget {
  const _ImmagineEsercizio({this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    final colori = Theme.of(context).colorScheme;

    Widget fallback() => Container(
          width: 52,
          height: 52,
          color: colori.surfaceContainerHighest,
          alignment: Alignment.center,
          child:
              Icon(Icons.fitness_center, color: colori.onSurface.withOpacity(0.55)),
        );

    if (url == null || url!.isEmpty) return fallback();

    final String resolvedUrl;
    if (url!.startsWith('http')) {
      resolvedUrl = url!;
    } else if (url!.startsWith('assets/')) {
      return Image.asset(
        url!,
        width: 52,
        height: 52,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback(),
      );
    } else {
      resolvedUrl = '$apiBaseUrl/${url!.replaceAll(RegExp(r'^/'), '')}';
    }

    return Image.network(
      resolvedUrl,
      width: 52,
      height: 52,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          width: 52,
          height: 52,
          color: colori.surfaceContainerHighest,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }
}

class _ChipInfo extends StatelessWidget {
  const _ChipInfo({required this.icona, required this.testo});

  final IconData icona;
  final String testo;

  @override
  Widget build(BuildContext context) {
    final colori = Theme.of(context).colorScheme;
    final tema = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colori.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colori.onSurface.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icona, size: 16, color: colori.onSurface.withOpacity(0.75)),
          const SizedBox(width: 6),
          Text(
            testo,
            style: tema.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BoxVuoto extends StatelessWidget {
  const _BoxVuoto({
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colori.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colori.primary.withOpacity(0.18)),
      ),
      child: Column(
        children: [
          Icon(icona, size: 28, color: colori.primary),
          const SizedBox(height: 10),
          Text(
            titolo,
            textAlign: TextAlign.center,
            style: tema.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            descrizione,
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyMedium?.copyWith(
              color: colori.onSurface.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }
}
