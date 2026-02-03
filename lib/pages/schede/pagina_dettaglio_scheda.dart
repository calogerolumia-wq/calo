import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/archivio_locale.dart';
import '../../stato/fornitori.dart';
import '../../utils/gruppi_allenamento.dart';
import '../../utils/immagini_esercizi.dart';
import '../../utils/navigazione.dart';
import '../sessione/pagina_sessione_in_corso.dart';
import 'pagina_editor_scheda.dart';
import 'pagina_schede.dart';

class PaginaDettaglioScheda extends ConsumerWidget {
  const PaginaDettaglioScheda({super.key, required this.schedaId});

  final int schedaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;
    final archivio = ref.watch(fornitoreArchivioLocale);

    return Scaffold(
      body: StreamBuilder<SchedeData?>(
        stream: archivio.guardaScheda(schedaId),
        builder: (context, snapshot) {
          final scheda = snapshot.data;
          if (scheda == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return StreamBuilder<List<EsercizioInScheda>>(
            stream: archivio.guardaEserciziScheda(scheda.id),
            builder: (context, snapshot) {
              final elementi = snapshot.data ?? [];

              if (elementi.isEmpty) {
                return CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(context, ref, scheda, colori, tema),
                    _buildCtaSessione(context, ref, scheda),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: _BoxVuoto(
                          titolo: 'Scheda vuota',
                          descrizione:
                              'Aggiungi esercizi dall’editor della scheda.',
                          icona: Icons.playlist_add,
                          azione: FilledButton.icon(
                            onPressed: () => apriPagina(
                              context,
                              PaginaEditorScheda(schedaId: scheda.id),
                            ),
                            icon: const Icon(Icons.edit),
                            label: const Text('Modifica scheda'),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              final gruppi = _raggruppaPerSezione(elementi);

              return DefaultTabController(
                length: gruppi.length,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    _buildSliverAppBar(
                      context,
                      ref,
                      scheda,
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
                        unselectedLabelColor:
                            colori.onSurface.withOpacity(0.6),
                        tabs: gruppi
                            .map((gruppo) => Tab(text: gruppo.nome))
                            .toList(),
                      ),
                    ),
                    _buildCtaSessione(context, ref, scheda),
                  ],
                  body: TabBarView(
                    children: gruppi
                        .map(
                          (gruppo) => _TabSezioneEsercizi(
                            key: PageStorageKey('sezione_${gruppo.nome}'),
                            gruppo: gruppo,
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(
    BuildContext context,
    WidgetRef ref,
    SchedeData scheda,
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
      actions: [
        IconButton(
          onPressed: () => apriPagina(
            context,
            PaginaEditorScheda(schedaId: scheda.id),
          ),
          icon: const Icon(Icons.edit_outlined),
          tooltip: 'Modifica',
        ),
        IconButton(
          onPressed: () => _confermaEliminazione(context, ref),
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Elimina',
        ),
      ],
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
                      scheda.descrizione ??
                          'Piano di allenamento personalizzato',
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
                        if (scheda.modello)
                          const _ChipInfo(
                            icona: Icons.layers_outlined,
                            testo: 'Modello',
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
    SchedeData scheda,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () async {
              final idSessione =
                  await ref.read(gestoreSessioneAttiva.notifier).avviaDaScheda(
                        scheda.id,
                      );
              if (!context.mounted) return;
              apriPagina(
                context,
                PaginaSessioneInCorso(sessioneId: idSessione),
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Avvia sessione'),
          ),
        ),
      ),
    );
  }

  List<_GruppoSezione> _raggruppaPerSezione(List<EsercizioInScheda> elementi) {
    // Mantieni ordine già definito in query (ordineSezione + ordineEsercizio)
    final mappa = <String, List<EsercizioInScheda>>{};
    final ordine = <String>[];

    for (final e in elementi) {
      final infoSezione = decodificaSezioneConGruppo(e.sezione);
      final nome = infoSezione.sezione.trim().isEmpty
          ? 'Allenamento'
          : infoSezione.sezione.trim();
      if (!mappa.containsKey(nome)) ordine.add(nome);
      (mappa[nome] ??= []).add(e);
    }

    return ordine.map((nome) => _GruppoSezione(nome: nome, elementi: mappa[nome]!)).toList();
  }

  Future<void> _confermaEliminazione(BuildContext context, WidgetRef ref) async {
    final conferma = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminare scheda?'),
        content: const Text('Questa azione rimuoverà la scheda e gli esercizi associati.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (conferma != true) return;

    final archivio = ref.read(fornitoreArchivioLocale);
    await archivio.eliminaScheda(schedaId);
    if (context.mounted) {
      vaiAllaPaginaPrincipale(
        context,
        const PaginaSchede(),
      );
    }
  }
}

class _GruppoSezione {
  const _GruppoSezione({required this.nome, required this.elementi});
  final String nome;
  final List<EsercizioInScheda> elementi;
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
              Expanded(
                child: Text(
                  'Esercizi (${gruppo.elementi.length})',
                  style: tema.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < gruppo.elementi.length; i++)
          _RigaEsercizioScheda(elemento: gruppo.elementi[i]),
      ],
    );
  }
}

class _RigaEsercizioScheda extends StatelessWidget {
  const _RigaEsercizioScheda({required this.elemento});

  final EsercizioInScheda elemento;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    final percorso = percorsoImmagineEsercizio(elemento.esercizio);
    final descrizione = elemento.esercizio.descrizione ??
        elemento.esercizio.muscoloObiettivo ??
        'Esercizio mirato';
    final notaAllenatore = elemento.noteAllenatore?.trim();
    final durataMinuti = elemento.durataMinuti;
    final infoGruppo = decodificaSezioneConGruppo(elemento.sezione);
    final testoGruppo = testoGruppoAllenamento(
      infoGruppo.tipo,
      infoGruppo.etichetta,
    );

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colori.onSurface.withOpacity(0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: _ImmagineCompatta(percorsoImmagine: percorso),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    elemento.esercizio.nome,
                    style: tema.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              descrizione,
              style: tema.textTheme.bodyMedium?.copyWith(
                color: colori.onSurface.withOpacity(0.75),
              ),
            ),
            if (notaAllenatore != null && notaAllenatore.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                'Note: $notaAllenatore',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: colori.onSurface.withOpacity(0.7),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ChipInfo(icona: Icons.repeat, testo: '${elemento.serie} serie'),
                _ChipInfo(
                  icona: Icons.refresh,
                  testo: '${_testoRipetizioni(elemento)} rep',
                ),
                if (durataMinuti != null && durataMinuti > 0)
                  _ChipInfo(
                    icona: Icons.timer_outlined,
                    testo: '$durataMinuti min',
                  ),
                if (elemento.peso != null)
                  _ChipInfo(icona: Icons.scale, testo: '${elemento.peso} kg'),
                if (testoGruppo.isNotEmpty)
                  _ChipInfo(
                    icona: infoGruppo.tipo == TipoGruppoAllenamento.superset
                        ? Icons.link
                        : Icons.loop,
                    testo: testoGruppo,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _testoRipetizioni(EsercizioInScheda elemento) {
  final piramidali = elemento.ripetizioniPiramidali;
  if (piramidali != null && piramidali.trim().isNotEmpty) {
    return piramidali;
  }
  return elemento.ripetizioni.toString();
}

class _ImmagineCompatta extends StatelessWidget {
  const _ImmagineCompatta({required this.percorsoImmagine});

  final String percorsoImmagine;

  @override
  Widget build(BuildContext context) {
    final colori = Theme.of(context).colorScheme;

    Widget fallback() => Container(
      width: 52,
      height: 52,
      color: colori.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(Icons.image, color: colori.onSurface.withOpacity(0.55)),
    );

    if (percorsoImmagine.trim().isEmpty) return fallback();

    final usaAsset = immagineEAsset(percorsoImmagine);

    return usaAsset
        ? Image.asset(
      percorsoImmagine,
      width: 52,
      height: 52,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => fallback(),
    )
        : Image.file(
      File(percorsoImmagine),
      width: 52,
      height: 52,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => fallback(),
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
          const SizedBox(height: 14),
          azione,
        ],
      ),
    );
  }
}
