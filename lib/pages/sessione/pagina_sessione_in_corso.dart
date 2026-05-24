import 'dart:collection';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

import '../../database/archivio_locale.dart';
import '../../models/esercizio_sessione.dart';
import '../../models/scheda_remota.dart';
import '../../stato/fornitori.dart';
import '../../utils/gruppi_allenamento.dart';
import '../../utils/navigazione.dart';
import 'pagina_sessione.dart';

class PaginaSessioneInCorso extends ConsumerStatefulWidget {
  const PaginaSessioneInCorso({
    super.key,
    required this.sessioneId,
    this.esercizi = const [],
    this.scheda,
  });

  final int sessioneId;
  final List<EsercizioSessione> esercizi;
  final SchedaRemota? scheda;

  @override
  ConsumerState<PaginaSessioneInCorso> createState() =>
      _PaginaSessioneInCorsoState();
}

class _PaginaSessioneInCorsoState extends ConsumerState<PaginaSessioneInCorso> {
  late Future<SessioniAllenamentoData?> _futuroSessione;
  String? _sezioneAttiva;
  int? _schedaIdSezione;
  bool _inizializzazioneSezione = false;
  int? _esercizioEvidenziatoId;
  bool _focusMode = false;
  int _indiceFocus = 0;
  final Set<int> _eserciziCompletati = <int>{};
  late final PageController _focusController;
  late final GestoreTimerRecupero _gestoreTimerRecupero;
  ProviderSubscription<StatoTimerRecupero>? _recuperoDialogSubscription;
  bool _recuperoDialogAperto = false;
  bool _mostratiDettagliScheda = false;

  @override
  void initState() {
    super.initState();
    _futuroSessione = _leggiSessione();
    _focusController = PageController();
    _focusMode = true;
    _gestoreTimerRecupero = ref.read(gestoreTimerRecupero.notifier);
    _recuperoDialogSubscription =
        ref.listenManual<StatoTimerRecupero>(gestoreTimerRecupero, _onRecupero);
  }

  @override
  void didUpdateWidget(covariant PaginaSessioneInCorso oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sessioneId != widget.sessioneId) {
      _futuroSessione = _leggiSessione();
      _schedaIdSezione = null;
      _sezioneAttiva = null;
      _inizializzazioneSezione = false;
      _esercizioEvidenziatoId = null;
      _focusMode = true;
      _indiceFocus = 0;
      _eserciziCompletati.clear();
      _mostratiDettagliScheda = false;
    }
  }

  @override
  void dispose() {
    _recuperoDialogSubscription?.close();
    _gestoreTimerRecupero.salta();
    _focusController.dispose();
    super.dispose();
  }

  void _onRecupero(
    StatoTimerRecupero? precedente,
    StatoTimerRecupero successivo,
  ) {
    final eraAttivo = precedente?.attivo ?? false;
    if (!eraAttivo && successivo.attivo) {
      _mostraDialogRecupero();
      return;
    }
    if (eraAttivo && !successivo.attivo) {
      _chiudiDialogRecupero();
    }
  }

  Future<void> _mostraDialogRecupero() async {
    if (_recuperoDialogAperto || !mounted) return;
    _recuperoDialogAperto = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.transparent,
          child: PannelloRecupero(overlay: true),
        );
      },
    );
    _recuperoDialogAperto = false;
  }

  void _chiudiDialogRecupero() {
    if (!_recuperoDialogAperto || !mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    _recuperoDialogAperto = false;
  }

  Future<SessioniAllenamentoData?> _leggiSessione() {
    final archivio = ref.read(fornitoreArchivioLocale);
    return archivio.leggiSessionePerId(widget.sessioneId);
    // Nota: se vuoi che si aggiorni in tempo reale, conviene farlo via stream.
  }

  String? _formattaDurataScheda(DateTime? inizio, DateTime? fine) {
    if (inizio == null || fine == null) return null;
    var diffGiorni = fine.difference(inizio).inDays;
    if (diffGiorni < 0) diffGiorni = -diffGiorni;
    var settimane = (diffGiorni / 7).ceil();
    if (settimane <= 0) settimane = 1;
    return '$settimane ${settimane == 1 ? 'settimana' : 'settimane'}';
  }

  Future<void> _mostraDettagliSchedaSeNecessario() async {
    if (_mostratiDettagliScheda || !mounted) return;
    _mostratiDettagliScheda = true;
    final scheda = widget.scheda;
    if (!mounted || scheda == null) return;
    const durataScheda = null;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final tema = Theme.of(context);
        final colori = tema.colorScheme;
        final descrizione = scheda.descrizione?.trim();
        final difficolta = scheda.livelloDifficolta?.trim();
        final noteAllenatore = scheda.noteAllenatore?.trim();
        final testoDescrizione =
            (descrizione == null || descrizione.isEmpty)
                ? 'Nessuna descrizione inserita.'
                : descrizione;
        final testoDifficolta = (difficolta == null || difficolta.isEmpty)
            ? 'Difficoltà: non specificata'
            : 'Difficoltà: $difficolta';
        final testoDurata = durataScheda == null
            ? 'Durata: non specificata'
            : 'Durata: $durataScheda';
        final testoNote = (noteAllenatore == null || noteAllenatore.isEmpty)
            ? 'Nessuna nota allenatore.'
            : noteAllenatore;

        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: colori.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colori.onSurface.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scheda.nomeScheda,
                        style: tema.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        testoDescrizione,
                        style: tema.textTheme.bodyMedium?.copyWith(
                          color: colori.onSurface.withOpacity(0.75),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _ChipTarget(
                            icona: Icons.bolt,
                            testo: testoDifficolta,
                          ),
                          _ChipTarget(
                            icona: Icons.timer_outlined,
                            testo: testoDurata,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colori.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colori.onSurface.withOpacity(0.08),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Note allenatore',
                              style: tema.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colori.onSurface.withOpacity(0.75),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              testoNote,
                              style: tema.textTheme.bodyMedium?.copyWith(
                                color: colori.onSurface.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: colori.surface.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _chiaveSezioneAttiva(int schedaId) =>
      'sezione_attiva_scheda_$schedaId';

  Future<String?> _leggiSezioneAttivaScheda(int schedaId) async {
    final archivio = ref.read(fornitoreArchivioLocale);
    final voce = await (archivio.select(archivio.impostazioni)
          ..where((tbl) => tbl.chiave.equals(_chiaveSezioneAttiva(schedaId))))
        .getSingleOrNull();
    return voce?.valore;
  }

  Future<void> _salvaSezioneAttivaScheda(
    int schedaId,
    String sezione,
  ) async {
    final archivio = ref.read(fornitoreArchivioLocale);
    await archivio.into(archivio.impostazioni).insertOnConflictUpdate(
          ImpostazioniCompanion(
            chiave: Value(_chiaveSezioneAttiva(schedaId)),
            valore: Value(sezione),
          ),
        );
  }

  void _richiediInizializzazioneSezione(
    int schedaId,
    List<_SezioneInfo> sezioni,
  ) {
    if (sezioni.isEmpty) return;

    if (_schedaIdSezione != schedaId) {
      _schedaIdSezione = schedaId;
      _sezioneAttiva = null;
      _inizializzazioneSezione = false;
    }

    if (_sezioneAttiva == null && !_inizializzazioneSezione) {
      _inizializzazioneSezione = true;
      Future.microtask(() => _inizializzaSezioneAttiva(schedaId, sezioni));
      return;
    }

    _assicuraSezioneValida(schedaId, sezioni);
  }

  Future<void> _inizializzaSezioneAttiva(
    int schedaId,
    List<_SezioneInfo> sezioni,
  ) async {
    try {
      final salvata = await _leggiSezioneAttivaScheda(schedaId);
      final valida =
          salvata != null && sezioni.any((s) => s.valore == salvata);
      final selezionata = valida ? salvata! : sezioni.first.valore;
      if (!mounted) return;
      setState(() => _sezioneAttiva = selezionata);
      if (!valida) {
        await _salvaSezioneAttivaScheda(schedaId, selezionata);
      }
    } finally {
      _inizializzazioneSezione = false;
    }
  }

  void _assicuraSezioneValida(int schedaId, List<_SezioneInfo> sezioni) {
    final attiva = _sezioneAttiva;
    if (attiva == null) return;
    final esiste = sezioni.any((s) => s.valore == attiva);
    if (esiste) return;
    final fallback = sezioni.first.valore;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _sezioneAttiva = fallback);
    });
    _salvaSezioneAttivaScheda(schedaId, fallback);
  }

  void _onSezioneSelezionata(int schedaId, String sezione) {
    if (_sezioneAttiva == sezione) return;
    setState(() {
      _sezioneAttiva = sezione;
      _indiceFocus = 0;
    });
    _salvaSezioneAttivaScheda(schedaId, sezione);
    _saltaAllaPaginaFocus(0);
  }

  void _saltaAllaPaginaFocus(int indice) {
    if (!_focusController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_focusController.hasClients) return;
        _focusController.jumpToPage(indice);
      });
      return;
    }
    _focusController.jumpToPage(indice);
  }

  void _segnaEsercizioCompletato(int esercizioId) {
    if (_eserciziCompletati.contains(esercizioId)) return;
    setState(() => _eserciziCompletati.add(esercizioId));
  }

  Future<void> _completaEAvviaRecupero(EsercizioSessione esercizio) async {
    _segnaEsercizioCompletato(esercizio.esercizioId);
    final cfg = ref.read(fornitoreConfigurazioneApp);
    if (!cfg.featureTimer) return;
    final recuperoDefault = await ref.read(fornitoreRecuperoSecondi.future);
    if (!mounted) return;
    final recuperoSecondi = esercizio.recuperoSecondi ?? recuperoDefault;
    ref
        .read(gestoreTimerRecupero.notifier)
        .avvia(Duration(seconds: recuperoSecondi));
  }

  @override
  Widget build(BuildContext context) {
    final archivio = ref.watch(fornitoreArchivioLocale);

    return FutureBuilder<SessioniAllenamentoData?>(
      future: _futuroSessione,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: _StatoMessaggio(
              titolo: 'Errore di caricamento',
              descrizione: 'Non riesco a recuperare la sessione.',
            ),
          );
        }

        final sessione = snapshot.data;
        if (sessione == null) {
          return const Scaffold(
            body: _StatoMessaggio(
              titolo: 'Sessione non trovata',
              descrizione: 'Avvia una nuova sessione dalla lista schede.',
            ),
          );
        }

        final puoTornare = Navigator.of(context).canPop();
        if (widget.scheda != null && !_mostratiDettagliScheda) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _mostraDettagliSchedaSeNecessario();
          });
        }

        // Determine if this is a scheda session or a free session
        final schedaSessioneId = sessione.schedaId;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Sessione in corso'),
            automaticallyImplyLeading: true,
            actions: [
              if (!puoTornare)
                TextButton(
                  onPressed: () => vaiAllaPaginaPrincipale(
                    context,
                    const PaginaSessione(),
                  ),
                  child: const Text('Chiudi'),
                ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: () => _completaSessione(context, sessione.id),
                  child: const Text('Completa'),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              if (schedaSessioneId == null)
                _ContenutoSessioneLibera(
                  onTorna: () => vaiAllaPaginaPrincipale(
                    context,
                    const PaginaSessione(),
                  ),
                )
              else
                Builder(
                  builder: (context) {
                    // When esercizi not provided (resume), fetch from REST
                    final List<EsercizioSessione> elementi;
                    if (widget.esercizi.isNotEmpty) {
                      elementi = widget.esercizi;
                    } else {
                      final eserciziAsync = ref.watch(
                        fornitoreEserciziSchedaRemota(schedaSessioneId),
                      );
                      if (eserciziAsync.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (eserciziAsync.hasError) {
                        return const _StatoMessaggio(
                          titolo: 'Errore caricamento',
                          descrizione:
                              'Non riesco a caricare gli esercizi della scheda.',
                        );
                      }
                      final remoti = eserciziAsync.value ?? [];
                      elementi = remoti
                          .asMap()
                          .entries
                          .map(
                            (e) => EsercizioSessione.fromRemoto(
                              e.value,
                              e.key + 1,
                            ),
                          )
                          .toList();
                    }

                    if (elementi.isEmpty) {
                      return const _StatoMessaggio(
                        titolo: 'Scheda vuota',
                        descrizione:
                            'Aggiungi esercizi alla scheda per iniziare.',
                      );
                    }

                    final sezioni = _costruisciSezioni(elementi);
                    if (sezioni.isEmpty) {
                      return const _StatoMessaggio(
                        titolo: 'Sezioni mancanti',
                        descrizione:
                            'Imposta una sezione per gli esercizi della scheda.',
                      );
                    }

                    final schedaId = widget.scheda?.id ?? schedaSessioneId;
                    _richiediInizializzazioneSezione(schedaId, sezioni);

                    final sezioneAttiva = _sezioneAttiva;
                    if (sezioneAttiva == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final infoSezione = sezioni.firstWhere(
                      (sezione) => sezione.valore == sezioneAttiva,
                      orElse: () => sezioni.first,
                    );

                    final elementiSezione = elementi
                        .where(
                          (elemento) =>
                              _normalizzaSezione(elemento.sezione) ==
                              infoSezione.valore,
                        )
                        .toList()
                      ..sort(
                        (a, b) =>
                            a.ordineEsercizio.compareTo(b.ordineEsercizio),
                      );

                    if (elementiSezione.isNotEmpty &&
                        _indiceFocus >= elementiSezione.length) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        setState(() => _indiceFocus = 0);
                        _saltaAllaPaginaFocus(0);
                      });
                    }

                    if (_focusMode && _esercizioEvidenziatoId != null) {
                      final targetIndex = elementiSezione.indexWhere(
                        (e) => e.esercizioId == _esercizioEvidenziatoId,
                      );
                      if (targetIndex >= 0 && targetIndex != _indiceFocus) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;
                          setState(() => _indiceFocus = targetIndex);
                          _saltaAllaPaginaFocus(targetIndex);
                        });
                      }
                    }

                    return _ContenutoSessioneDaScheda(
                      sessioneId: sessione.id,
                      archivio: archivio,
                      sezioni: sezioni,
                      sezioneAttiva: infoSezione,
                      elementi: elementiSezione,
                      esercizioEvidenziatoId: _esercizioEvidenziatoId,
                      eserciziCompletati: _eserciziCompletati,
                      focusMode: _focusMode,
                      focusController: _focusController,
                      indiceFocus: _indiceFocus,
                      onFocusChanged: (valore) {
                        setState(() => _focusMode = valore);
                        if (valore) {
                          _saltaAllaPaginaFocus(_indiceFocus);
                        }
                      },
                      onFocusIndexChanged: (indice) {
                        setState(() {
                          _indiceFocus = indice;
                          if (indice >= 0 &&
                              indice < elementiSezione.length) {
                            _esercizioEvidenziatoId =
                                elementiSezione[indice].esercizioId;
                          }
                        });
                      },
                      onSezioneChanged: (sezione) =>
                          _onSezioneSelezionata(schedaId, sezione),
                      onCompletaEsercizio: _completaEAvviaRecupero,
                      onRegistraSet: (esercizio) =>
                          _aggiungiSerie(context, sessione.id, esercizio),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _completaSessione(BuildContext context, int sessioneId) async {
    final conferma = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Completa scheda'),
          content: const Text(
            'Sei sicuro di voler completare la sessione? Non potrai più modificarla.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Completa'),
            ),
          ],
        );
      },
    );

    if (conferma != true) return;

    await ref.read(gestoreSessioneAttiva.notifier).completaSessione(sessioneId);
    if (!context.mounted) return;
    vaiAllaPaginaPrincipale(
      context,
      const PaginaSessione(),
    );
  }

  Future<void> _aggiungiSerie(
    BuildContext context,
    int sessioneId,
    EsercizioSessione esercizio,
  ) async {
    final archivio = ref.read(fornitoreArchivioLocale);
    final numeroSerieGiaFatte = await archivio.contaSerieInSessione(
      sessioneId,
      esercizio.esercizioId,
    );
    final memoriaPesi = await ref.read(fornitoreMemoriaPesi.future);
    final ultimoPeso = memoriaPesi
        ? await archivio.leggiUltimoPesoEsercizio(esercizio.esercizioId)
        : null;

    if (!context.mounted) return;

    final dati = await showModalBottomSheet<DatiSerieIngresso>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _PannelloSerie(
        nomeEsercizio: esercizio.nome,
        indiceSerie: numeroSerieGiaFatte + 1,
        pesoPrecompilato: ultimoPeso,
      ),
    );

    if (dati == null || !context.mounted) return;

    await archivio.registraSerie(
      sessioneId: sessioneId,
      esercizioId: esercizio.esercizioId,
      indiceSerie: dati.indiceSerie,
      ripetizioni: dati.ripetizioni,
      peso: dati.peso,
      rpe: dati.rpe,
      secondiTempo: dati.secondiTempo,
      note: dati.note,
    );

    if (!mounted) return;

    final cfg = ref.read(fornitoreConfigurazioneApp);
    if (!cfg.featureTimer) return;

    final recuperoDefault = await ref.read(fornitoreRecuperoSecondi.future);
    if (!mounted) return;
    final recuperoSecondi = esercizio.recuperoSecondi ?? recuperoDefault;
    if (mounted) {
      setState(() => _esercizioEvidenziatoId = esercizio.esercizioId);
    }
    if (!mounted) return;
    ref
        .read(gestoreTimerRecupero.notifier)
        .avvia(Duration(seconds: recuperoSecondi));
  }
}

/// ---------------------------
/// CONTENUTI PRINCIPALI
/// ---------------------------

class _ContenutoSessioneLibera extends StatelessWidget {
  const _ContenutoSessioneLibera({required this.onTorna});

  final VoidCallback onTorna;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colori.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colori.primary.withOpacity(0.18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sessione libera',
                style: tema.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Questa sessione non è collegata a una scheda: non posso mostrarti gli esercizi preimpostati.',
                style: tema.textTheme.bodyMedium?.copyWith(
                  color: colori.onSurface.withOpacity(0.75),
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: onTorna,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Torna'),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.06, end: 0),
      ],
    );
  }
}

class _ContenutoSessioneDaScheda extends StatelessWidget {
  const _ContenutoSessioneDaScheda({
    required this.sessioneId,
    required this.archivio,
    required this.sezioni,
    required this.sezioneAttiva,
    required this.elementi,
    required this.esercizioEvidenziatoId,
    required this.eserciziCompletati,
    required this.focusMode,
    required this.focusController,
    required this.indiceFocus,
    required this.onFocusChanged,
    required this.onFocusIndexChanged,
    required this.onSezioneChanged,
    required this.onCompletaEsercizio,
    required this.onRegistraSet,
  });

  final int sessioneId;
  final ArchivioLocale archivio;
  final List<_SezioneInfo> sezioni;
  final _SezioneInfo sezioneAttiva;
  final List<EsercizioSessione> elementi;
  final int? esercizioEvidenziatoId;
  final Set<int> eserciziCompletati;
  final bool focusMode;
  final PageController focusController;
  final int indiceFocus;
  final ValueChanged<bool> onFocusChanged;
  final ValueChanged<int> onFocusIndexChanged;
  final ValueChanged<String> onSezioneChanged;
  final ValueChanged<EsercizioSessione> onCompletaEsercizio;
  final void Function(EsercizioSessione esercizio) onRegistraSet;

  @override
  Widget build(BuildContext context) {
    final colori = Theme.of(context).colorScheme;

    if (focusMode) {
      final dimensioniSchermo = MediaQuery.of(context).size;
      final larghezzaCard = (dimensioniSchermo.width - 32).clamp(280.0, 900.0);
      final altezzaStimata = larghezzaCard + 260;
      final altezzaFocus = altezzaStimata
          .clamp(420.0, dimensioniSchermo.height * 0.95)
          .toDouble();
      final totale = elementi.length;
      final indiceCorrente = totale == 0
          ? 0
          : indiceFocus.clamp(0, totale - 1).toInt();
      final elementoCorrente =
          totale == 0 ? null : elementi[indiceCorrente];
      final completato = elementoCorrente != null &&
          eserciziCompletati.contains(elementoCorrente.esercizioId);

      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  sezioneAttiva.descrizione,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colori.primary,
                      ),
                ),
              ),
              Switch.adaptive(
                value: focusMode,
                onChanged: onFocusChanged,
              ),
              IconButton(
                tooltip: completato
                    ? 'Esercizio completato'
                    : 'Segna esercizio completato',
                onPressed: elementoCorrente == null
                    ? null
                    : () {
                        onCompletaEsercizio(elementoCorrente);
                        final prossimoIndice = indiceCorrente + 1;
                        if (prossimoIndice < totale) {
                          onFocusIndexChanged(prossimoIndice);
                          if (focusController.hasClients) {
                            focusController.animateToPage(
                              prossimoIndice,
                              duration: const Duration(milliseconds: 240),
                              curve: Curves.easeOutCubic,
                            );
                          }
                        }
                      },
                icon: Icon(
                  completato
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  size: 35,
                ),
                color: completato
                    ? colori.primary
                    : colori.onSurface.withOpacity(0.6),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (elementi.isEmpty)
            const _StatoMessaggio(
              titolo: 'Sezione vuota',
              descrizione: 'Non ci sono esercizi in questa sezione.',
            )
          else
            SizedBox(
              height: altezzaFocus,
              child: PageView.builder(
                controller: focusController,
                itemCount: elementi.length,
                onPageChanged: onFocusIndexChanged,
                itemBuilder: (context, index) {
                  final elemento = elementi[index];
                  return _CardEsercizioSessione(
                    sessioneId: sessioneId,
                    elemento: elemento,
                    archivio: archivio,
                    etichettaOrdine:
                        '${sezioneAttiva.etichettaBreve}${index + 1}',
                    inEvidenza: esercizioEvidenziatoId == elemento.esercizioId,
                    completato: eserciziCompletati
                        .contains(elemento.esercizioId),
                    focusMode: true,
                    onRegistraSet: () => onRegistraSet(elemento),
                  );
                },
              ),
            ),
          const SizedBox(height: 10),
          _IndicatoreFocus(
            totale: totale,
            indice: indiceCorrente,
          ),
          const SizedBox(height: 12),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
      children: [
        _HeaderSezioneScheda(
          titolo: 'Sezione ${sezioneAttiva.etichettaBreve}',
          sottotitolo: sezioneAttiva.descrizione,
        ),
        const SizedBox(height: 12),
        _SelettoreSezione(
          sezioni: sezioni,
          sezioneAttiva: sezioneAttiva.valore,
          descrizioneAttiva: sezioneAttiva.descrizione,
          onChanged: onSezioneChanged,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                'Modalità Focus',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colori.primary,
                    ),
              ),
            ),
            Switch.adaptive(
              value: focusMode,
              onChanged: onFocusChanged,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (elementi.isEmpty)
          const _StatoMessaggio(
            titolo: 'Sezione vuota',
            descrizione: 'Non ci sono esercizi in questa sezione.',
          )
        else
          for (int i = 0; i < elementi.length; i++)
            _CardEsercizioSessione(
              sessioneId: sessioneId,
              elemento: elementi[i],
              archivio: archivio,
              etichettaOrdine:
                  '${sezioneAttiva.etichettaBreve}${i + 1}',
              inEvidenza: esercizioEvidenziatoId == elementi[i].esercizioId,
              completato:
                  eserciziCompletati.contains(elementi[i].esercizioId),
              focusMode: false,
              onRegistraSet: () => onRegistraSet(elementi[i]),
            ).animate().fadeIn(
                  duration: 180.ms,
                  delay: (30 * i).ms,
                ),
        const SizedBox(height: 8),
        Text(
          'Totale esercizi: ${elementi.length}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colori.primary.withOpacity(0.7),
              ),
        ),
      ],
    );
  }
}

class _HeaderSezioneScheda extends StatelessWidget {
  const _HeaderSezioneScheda({
    required this.titolo,
    required this.sottotitolo,
  });

  final String titolo;
  final String sottotitolo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colori.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colori.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titolo,
            style: tema.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: colori.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            sottotitolo,
            style: tema.textTheme.bodyMedium?.copyWith(
              color: colori.primary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelettoreSezione extends StatelessWidget {
  const _SelettoreSezione({
    required this.sezioni,
    required this.sezioneAttiva,
    required this.descrizioneAttiva,
    required this.onChanged,
  });

  final List<_SezioneInfo> sezioni;
  final String sezioneAttiva;
  final String descrizioneAttiva;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colori = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scegli la sezione da svolgere',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colori.primary,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          descrizioneAttiva,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colori.primary.withOpacity(0.7),
              ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sezioni.map((sezione) {
            final selezionata = sezione.valore == sezioneAttiva;
            return ChoiceChip(
              label: Text(sezione.etichettaBreve),
              selected: selezionata,
              selectedColor: colori.primary.withOpacity(0.18),
              backgroundColor: colori.primary.withOpacity(0.06),
              side: BorderSide(color: colori.primary.withOpacity(0.3)),
              labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selezionata
                        ? colori.primary
                        : colori.primary.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                  ),
              onSelected: (_) => onChanged(sezione.valore),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _StatoMessaggio extends StatelessWidget {
  const _StatoMessaggio({
    required this.titolo,
    required this.descrizione,
  });

  final String titolo;
  final String descrizione;

  @override
  Widget build(BuildContext context) {
    final colori = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colori.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colori.primary.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline, color: colori.primary),
              const SizedBox(height: 8),
              Text(
                titolo,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colori.primary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                descrizione,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colori.primary.withOpacity(0.75),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardEsercizioSessione extends StatelessWidget {
  const _CardEsercizioSessione({
    required this.sessioneId,
    required this.elemento,
    required this.archivio,
    required this.etichettaOrdine,
    required this.inEvidenza,
    required this.completato,
    required this.focusMode,
    required this.onRegistraSet,
  });

  final int sessioneId;
  final EsercizioSessione elemento;
  final ArchivioLocale archivio;
  final String etichettaOrdine;
  final bool inEvidenza;
  final bool completato;
  final bool focusMode;
  final VoidCallback onRegistraSet;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    final testoSecondario = elemento.descrizione ??
        elemento.gruppoMuscolare ??
        'Esercizio mirato';

    final bordo = inEvidenza
        ? colori.primary
        : colori.primary.withOpacity(0.2);
    final sfondo = inEvidenza
        ? colori.primary.withOpacity(0.08)
        : null;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: bordo),
      ),
      color: sfondo,
      child: Padding(
        padding: EdgeInsets.all(focusMode ? 16 : 14),
        child: focusMode
            ? _ContenutoEsercizioFocus(
                sessioneId: sessioneId,
                elemento: elemento,
                archivio: archivio,
                etichettaOrdine: etichettaOrdine,
                testoSecondario: testoSecondario,
                onRegistraSet: onRegistraSet,
              )
            : _ContenutoEsercizioCompatto(
                sessioneId: sessioneId,
                elemento: elemento,
                archivio: archivio,
                etichettaOrdine: etichettaOrdine,
                testoSecondario: testoSecondario,
                completato: completato,
                onRegistraSet: onRegistraSet,
              ),
      ),
    );
  }
}

class _ContenutoEsercizioFocus extends StatelessWidget {
  const _ContenutoEsercizioFocus({
    required this.sessioneId,
    required this.elemento,
    required this.archivio,
    required this.etichettaOrdine,
    required this.testoSecondario,
    required this.onRegistraSet,
  });

  final int sessioneId;
  final EsercizioSessione elemento;
  final ArchivioLocale archivio;
  final String etichettaOrdine;
  final String testoSecondario;
  final VoidCallback onRegistraSet;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;
    final urlImmagine = elemento.urlImmagine;
    const percorsoVideo = null;
    final notaAllenatore = elemento.noteAllenatore?.trim();
    final durataMinuti = elemento.durataMinuti;
    final infoGruppo = decodificaSezioneConGruppo(elemento.sezione);
    final testoGruppo = testoGruppoAllenamento(
      infoGruppo.tipo,
      infoGruppo.etichetta,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final lato = constraints.biggest.shortestSide;
              return ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: GestureDetector(
                  onTap: percorsoVideo == null
                      ? null
                      : () => _mostraVideoEsercizio(
                            context,
                            percorsoVideo,
                          ),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: lato,
                    child: _ImmagineEsercizio(
                      urlImmagine: urlImmagine,
                      larghezza: constraints.maxWidth,
                      altezza: lato,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colori.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                etichettaOrdine,
                style: tema.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colori.primary,
                ),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: onRegistraSet,
              child: const Text('Registra set'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          elemento.nome,
          style: tema.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _rigaMetaEsercizio(elemento),
          style: tema.textTheme.bodySmall?.copyWith(
            color: colori.primary.withOpacity(0.65),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          testoSecondario,
          style: tema.textTheme.bodyMedium?.copyWith(
            color: colori.primary.withOpacity(0.75),
          ),
        ),
        if (notaAllenatore != null && notaAllenatore.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            'Note: $notaAllenatore',
            style: tema.textTheme.bodySmall?.copyWith(
              color: colori.primary.withOpacity(0.7),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ChipTarget(
              icona: Icons.repeat,
              testo: '${elemento.serie} serie',
            ),
            _ChipTarget(
              icona: Icons.refresh,
              testo: '${_testoRipetizioni(elemento)} rep',
            ),
            if (durataMinuti != null && durataMinuti > 0)
              _ChipTarget(
                icona: Icons.timer_outlined,
                testo: '$durataMinuti min',
              ),
            if (elemento.peso != null)
              _ChipTarget(
                icona: Icons.scale,
                testo: '${elemento.peso} kg',
              ),
            if (testoGruppo.isNotEmpty)
              _ChipTarget(
                icona: infoGruppo.tipo == TipoGruppoAllenamento.superset
                    ? Icons.link
                    : Icons.loop,
                testo: testoGruppo,
              ),
          ],
        ),
        const SizedBox(height: 12),
        StreamBuilder<List<SerieRegistrateData>>(
          stream: archivio.guardaSeriePerEsercizio(
            sessioneId,
            elemento.esercizioId,
          ),
          builder: (context, snapshot) {
            final serie = snapshot.data ?? [];
            if (serie.isEmpty) {
              return Text(
                'Nessun set registrato',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: colori.primary.withOpacity(0.65),
                ),
              );
            }

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: serie.map((record) => _ChipSerie(record)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ContenutoEsercizioCompatto extends StatelessWidget {
  const _ContenutoEsercizioCompatto({
    required this.sessioneId,
    required this.elemento,
    required this.archivio,
    required this.etichettaOrdine,
    required this.testoSecondario,
    required this.completato,
    required this.onRegistraSet,
  });

  final int sessioneId;
  final EsercizioSessione elemento;
  final ArchivioLocale archivio;
  final String etichettaOrdine;
  final String testoSecondario;
  final bool completato;
  final VoidCallback onRegistraSet;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;
    final notaAllenatore = elemento.noteAllenatore?.trim();
    final durataMinuti = elemento.durataMinuti;
    final infoGruppo = decodificaSezioneConGruppo(elemento.sezione);
    final testoGruppo = testoGruppoAllenamento(
      infoGruppo.tipo,
      infoGruppo.etichetta,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (completato) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colori.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colori.primary.withOpacity(0.3)),
            ),
            child: Text(
              'Completato',
              style: tema.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: colori.primary,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        _IntestazioneEsercizio(
          esercizio: elemento,
          etichettaOrdine: etichettaOrdine,
          onRegistraSet: onRegistraSet,
        ),
        const SizedBox(height: 10),
        Text(
          testoSecondario,
          style: tema.textTheme.bodyMedium?.copyWith(
            color: colori.primary.withOpacity(0.75),
          ),
        ),
        if (notaAllenatore != null && notaAllenatore.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            'Note: $notaAllenatore',
            style: tema.textTheme.bodySmall?.copyWith(
              color: colori.primary.withOpacity(0.7),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ChipTarget(
              icona: Icons.repeat,
              testo: '${elemento.serie} serie',
            ),
            _ChipTarget(
              icona: Icons.refresh,
              testo: '${_testoRipetizioni(elemento)} rep',
            ),
            if (durataMinuti != null && durataMinuti > 0)
              _ChipTarget(
                icona: Icons.timer_outlined,
                testo: '$durataMinuti min',
              ),
            if (elemento.peso != null)
              _ChipTarget(
                icona: Icons.scale,
                testo: '${elemento.peso} kg',
              ),
            if (testoGruppo.isNotEmpty)
              _ChipTarget(
                icona: infoGruppo.tipo == TipoGruppoAllenamento.superset
                    ? Icons.link
                    : Icons.loop,
                testo: testoGruppo,
              ),
          ],
        ),
        const SizedBox(height: 12),
        StreamBuilder<List<SerieRegistrateData>>(
          stream: archivio.guardaSeriePerEsercizio(
            sessioneId,
            elemento.esercizioId,
          ),
          builder: (context, snapshot) {
            final serie = snapshot.data ?? [];
            if (serie.isEmpty) {
              return Text(
                'Nessun set registrato',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: colori.primary.withOpacity(0.65),
                ),
              );
            }

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: serie.map((record) => _ChipSerie(record)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _IntestazioneEsercizio extends StatelessWidget {
  const _IntestazioneEsercizio({
    required this.esercizio,
    required this.etichettaOrdine,
    required this.onRegistraSet,
  });

  final EsercizioSessione esercizio;
  final String etichettaOrdine;
  final VoidCallback onRegistraSet;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    final urlImmagine = esercizio.urlImmagine;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: _ImmagineEsercizio(
            urlImmagine: urlImmagine,
            larghezza: 56,
            altezza: 56,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colori.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  etichettaOrdine,
                  style: tema.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colori.primary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                esercizio.nome,
                style: tema.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _rigaMetaEsercizio(esercizio),
                style: tema.textTheme.bodySmall?.copyWith(
                  color: colori.primary.withOpacity(0.65),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        FilledButton(
          onPressed: onRegistraSet,
          child: const Text('Registra set'),
        ),
      ],
    );
  }
}

String _rigaMetaEsercizio(EsercizioSessione esercizio) {
  final gruppo = (esercizio.gruppoMuscolare ?? '').trim();
  return gruppo.isEmpty ? 'Dettagli non specificati' : gruppo;
}

String _testoRipetizioni(EsercizioSessione elemento) {
  final piramidali = elemento.ripetizioniPiramidali;
  if (piramidali != null && piramidali.trim().isNotEmpty) {
    return piramidali;
  }
  return elemento.ripetizioni.toString();
}

void _mostraVideoEsercizio(BuildContext context, String percorsoVideo) {
  showDialog<void>(
    context: context,
    builder: (_) => _PopupVideoEsercizio(percorsoVideo: percorsoVideo),
  );
}

class _ImmagineEsercizio extends StatelessWidget {
  const _ImmagineEsercizio({
    required this.urlImmagine,
    required this.larghezza,
    required this.altezza,
    this.fit = BoxFit.cover,
  });

  final String? urlImmagine;
  final double larghezza;
  final double altezza;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final colori = Theme.of(context).colorScheme;

    Widget fallback() => Container(
      width: larghezza,
      height: altezza,
      color: colori.primary.withOpacity(0.12),
      alignment: Alignment.center,
      child: Icon(Icons.image, color: colori.primary.withOpacity(0.6)),
    );

    final url = urlImmagine?.trim() ?? '';
    if (url.isEmpty) return fallback();

    return Image.network(
      url,
      width: larghezza,
      height: altezza,
      fit: fit,
      errorBuilder: (context, error, stack) => fallback(),
    );
  }
}

class _IndicatoreFocus extends StatelessWidget {
  const _IndicatoreFocus({
    required this.totale,
    required this.indice,
  });

  final int totale;
  final int indice;

  @override
  Widget build(BuildContext context) {
    if (totale <= 1) return const SizedBox.shrink();

    final colori = Theme.of(context).colorScheme;
    final indiceSicuro = indice.clamp(0, totale - 1).toInt();

    return Center(
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: List.generate(totale, (i) {
          final attivo = i == indiceSicuro;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: attivo ? 12 : 8,
            height: attivo ? 12 : 8,
            decoration: BoxDecoration(
              color: attivo
                  ? colori.primary
                  : colori.primary.withOpacity(0.25),
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }),
      ),
    );
  }
}

class _PopupVideoEsercizio extends StatefulWidget {
  const _PopupVideoEsercizio({required this.percorsoVideo});

  final String percorsoVideo;

  @override
  State<_PopupVideoEsercizio> createState() => _PopupVideoEsercizioState();
}

class _PopupVideoEsercizioState extends State<_PopupVideoEsercizio> {
  late final VideoPlayerController _controller;
  late final Future<void> _inizializzazione;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.percorsoVideo);
    _inizializzazione = _controller.initialize().then((_) async {
      await _controller.setLooping(true);
      await _controller.setVolume(0);
      await _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colori = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: colori.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FutureBuilder<void>(
            future: _inizializzazione,
            builder: (context, snapshot) {
              final aspectRatio = _controller.value.isInitialized
                  ? _controller.value.aspectRatio
                  : 16 / 9;

              return AspectRatio(
                aspectRatio: aspectRatio,
                child: snapshot.connectionState == ConnectionState.done
                    ? VideoPlayer(_controller)
                    : Center(
                        child: CircularProgressIndicator(
                          color: colori.primary,
                        ),
                      ),
              );
            },
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              color: colori.onSurface,
              style: IconButton.styleFrom(
                backgroundColor: colori.surface.withOpacity(0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipTarget extends StatelessWidget {
  const _ChipTarget({required this.icona, required this.testo});

  final IconData icona;
  final String testo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colori.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colori.primary.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icona, size: 14, color: colori.primary),
          const SizedBox(width: 6),
          Text(
            testo,
            style: tema.textTheme.labelMedium?.copyWith(
              color: colori.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipSerie extends StatelessWidget {
  const _ChipSerie(this.record);

  final SerieRegistrateData record;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    final peso = record.peso == null ? null : '${record.peso} kg';
    final testo = [
      'S${record.indiceSerie}',
      '${record.ripetizioni} rep',
      if (peso != null) peso,
    ].join(' • ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colori.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colori.primary.withOpacity(0.2)),
      ),
      child: Text(
        testo,
        style: tema.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: colori.primary,
        ),
      ),
    );
  }
}

class _SezioneInfo {
  const _SezioneInfo({
    required this.valore,
    required this.ordine,
    required this.etichettaBreve,
    required this.descrizione,
  });

  final String valore;
  final int ordine;
  final String etichettaBreve;
  final String descrizione;
}

String _normalizzaSezione(String sezione) {
  final info = decodificaSezioneConGruppo(sezione);
  final pulita = info.sezione.trim();
  return pulita.isEmpty ? 'Allenamento' : pulita;
}

String _etichettaBreveSezione(String sezione) {
  final pulita = _normalizzaSezione(sezione);
  if (pulita.isEmpty) return 'Sez';
  final match = RegExp(r'\b([A-Z])\b').firstMatch(pulita.toUpperCase());
  if (match != null) return match.group(1)!;
  return pulita.length <= 3 ? pulita.toUpperCase() : pulita;
}

List<_SezioneInfo> _costruisciSezioni(List<EsercizioSessione> elementi) {
  final mappaOrdine = LinkedHashMap<String, int>();

  for (final elemento in elementi) {
    final nome = _normalizzaSezione(elemento.sezione);
    final ordine = elemento.ordineSezione;
    final ordineCorrente = mappaOrdine[nome];
    if (ordineCorrente == null || ordine < ordineCorrente) {
      mappaOrdine[nome] = ordine;
    }
  }

  final entries = mappaOrdine.entries.toList()
    ..sort((a, b) {
      final confronto = a.value.compareTo(b.value);
      if (confronto != 0) return confronto;
      return a.key.compareTo(b.key);
    });

  return entries
      .map(
        (entry) => _SezioneInfo(
          valore: entry.key,
          ordine: entry.value,
          etichettaBreve: _etichettaBreveSezione(entry.key),
          descrizione: entry.key,
        ),
      )
      .toList();
}

/// ---------------------------
/// PANNELLO RECUPERO (quasi invariato ma un po’ più “tema-driven”)
/// ---------------------------

class PannelloRecupero extends ConsumerStatefulWidget {
  const PannelloRecupero({super.key, this.overlay = false});

  final bool overlay;

  @override
  ConsumerState<PannelloRecupero> createState() => _PannelloRecuperoState();
}

class _PannelloRecuperoState extends ConsumerState<PannelloRecupero>
    with SingleTickerProviderStateMixin {
  ProviderSubscription<StatoTimerRecupero>? _subscription;
  late final AnimationController _progressController;
  Animation<double> _progressAnimation = const AlwaysStoppedAnimation(0);
  static const int _sogliaAvvisoSecondi = 5;
  static const int _durataVibrazioneAvvisoMs = 700;
  static const int _durataVibrazioneFineMs = 1300;
  static const int _durataBeepLungoMs = 1200;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this);
    _aggiornaAnimazione(null, ref.read(gestoreTimerRecupero));
    _subscription = ref.listenManual<StatoTimerRecupero>(
      gestoreTimerRecupero,
      (prev, next) {
        _aggiornaAnimazione(prev, next);
        final prevSec = prev?.rimanente.inSeconds ?? 0;
        final nextSec = next.rimanente.inSeconds;
        final durataValida = next.durataTotale > Duration.zero;

        if (durataValida &&
            prevSec != nextSec &&
            nextSec <= _sogliaAvvisoSecondi &&
            nextSec > 0) {
          _notifica(avviso: true);
        }
        if (durataValida && prevSec > 0 && nextSec == 0) {
          _notifica(avviso: false);
        }
      },
    );
  }

  double _calcolaPercentuale(StatoTimerRecupero stato) {
    final totaleMs = stato.durataTotale.inMilliseconds;
    if (totaleMs <= 0) return 0.0;
    final percentuale =
        stato.rimanente.inMilliseconds / totaleMs.toDouble();
    return percentuale.clamp(0.0, 1.0);
  }

  void _aggiornaAnimazione(
    StatoTimerRecupero? precedente,
    StatoTimerRecupero successivo,
  ) {
    final nuovo = _calcolaPercentuale(successivo);
    final precedenteAttivo = precedente?.attivo ?? false;
    final vecchio =
        (!precedenteAttivo) ? nuovo : _calcolaPercentuale(precedente!);
    if (!mounted) return;

    if (!successivo.attivo || successivo.inPausa) {
      _progressController.stop();
      setState(() {
        _progressAnimation = AlwaysStoppedAnimation(nuovo);
      });
      return;
    }

    _progressController.duration = const Duration(milliseconds: 900);
    setState(() {
      _progressAnimation = Tween<double>(begin: vecchio, end: nuovo).animate(
        CurvedAnimation(
          parent: _progressController,
          curve: Curves.easeOutCubic,
        ),
      );
    });
    _progressController.forward(from: 0);
  }

  void _notifica({required bool avviso}) {
    final vibrazione = ref.read(fornitoreVibrazioneRecupero).maybeWhen(
          data: (valore) => valore,
          orElse: () => true,
        );
    final beep = ref.read(fornitoreBeepRecupero).maybeWhen(
          data: (valore) => valore,
          orElse: () => false,
        );

    if (vibrazione) {
      final durataMs =
          avviso ? _durataVibrazioneAvvisoMs : _durataVibrazioneFineMs;
      Vibration.vibrate(duration: durataMs);
    }

    if (beep) {
      _playNotificationSound(longBeep: !avviso);
    }
  }

  void _playNotificationSound({required bool longBeep}) {
    final player = FlutterRingtonePlayer();
    if (longBeep) {
      player.play(
        android: AndroidSounds.notification,
        ios: IosSounds.triTone,
        looping: true,
      );
      Future.delayed(
        const Duration(milliseconds: _durataBeepLungoMs),
        player.stop,
      );
      return;
    }
    player.playNotification();
  }

  @override
  void dispose() {
    _subscription?.close();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    final stato = ref.watch(gestoreTimerRecupero);
    if (!stato.attivo) return const SizedBox.shrink();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        margin: widget.overlay
            ? EdgeInsets.zero
            : const EdgeInsets.fromLTRB(16, 0, 16, 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colori.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colori.onSurface.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              SizedBox(
                width: 230,
                height: 230,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          return CircularProgressIndicator(
                            value: _progressAnimation.value,
                            strokeWidth: 16,
                            strokeCap: StrokeCap.round,
                            backgroundColor: colori.primary.withOpacity(0.15),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(colori.primary),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _formattaDurata(stato.rimanente),
                          style: tema.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colori.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Recupero consigliato: ${stato.durataConsigliata.inSeconds}s',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: colori.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      final gestore = ref.read(gestoreTimerRecupero.notifier);
                    stato.inPausa ? gestore.riprendi() : gestore.pausa();
                  },
                  icon: Icon(stato.inPausa ? Icons.play_arrow : Icons.pause),
                ),
                IconButton(
                  onPressed: () => ref
                      .read(gestoreTimerRecupero.notifier)
                      .sottraiSecondi(15),
                  icon: const Icon(Icons.remove),
                ),
                IconButton(
                  onPressed: () =>
                      ref.read(gestoreTimerRecupero.notifier).aggiungiSecondi(15),
                  icon: const Icon(Icons.add),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => ref.read(gestoreTimerRecupero.notifier).salta(),
                  child: const Text('Salta'),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.15);
  }

  String _formattaDurata(Duration durata) {
    final minuti = durata.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secondi = durata.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minuti:$secondi';
  }
}

/// ---------------------------
/// BOTTOM SHEET REGISTRA SET (ripulito)
/// ---------------------------

class DatiSerieIngresso {
  const DatiSerieIngresso({
    required this.indiceSerie,
    required this.ripetizioni,
    this.peso,
    this.rpe,
    this.secondiTempo,
    this.note,
  });

  final int indiceSerie;
  final int ripetizioni;
  final double? peso;
  final double? rpe;
  final int? secondiTempo;
  final String? note;
}

class _PannelloSerie extends StatefulWidget {
  const _PannelloSerie({
    required this.nomeEsercizio,
    required this.indiceSerie,
    this.pesoPrecompilato,
  });

  final String nomeEsercizio;
  final int indiceSerie;
  final double? pesoPrecompilato;

  @override
  State<_PannelloSerie> createState() => _PannelloSerieState();
}

class _PannelloSerieState extends State<_PannelloSerie> {
  final _chiaveForm = GlobalKey<FormState>();

  late final TextEditingController _ripetizioniController;
  late final TextEditingController _pesoController;
  late final TextEditingController _rpeController;
  late final TextEditingController _tempoController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _ripetizioniController = TextEditingController(text: '10');
    _pesoController = TextEditingController(
      text: _formattaPeso(widget.pesoPrecompilato),
    );
    _rpeController = TextEditingController();
    _tempoController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _ripetizioniController.dispose();
    _pesoController.dispose();
    _rpeController.dispose();
    _tempoController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SafeArea(
        top: false,
        child: Form(
          key: _chiaveForm,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Serie ${widget.indiceSerie} • ${widget.nomeEsercizio}',
                  style: tema.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _CampoNumero(
                        controller: _ripetizioniController,
                        etichetta: 'Ripetizioni',
                        obbligatorio: true,
                        intero: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CampoNumero(
                        controller: _pesoController,
                        etichetta: 'Peso (kg)',
                        obbligatorio: false,
                        intero: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _CampoNumero(
                        controller: _rpeController,
                        etichetta: 'RPE',
                        obbligatorio: false,
                        intero: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CampoNumero(
                        controller: _tempoController,
                        etichetta: 'Tempo (sec)',
                        obbligatorio: false,
                        intero: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _salva,
                    child: const Text('Salva set'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _salva() {
    final ripetizioni = int.tryParse(_ripetizioniController.text.trim());
    if (ripetizioni == null || ripetizioni <= 0) return;

    Navigator.pop(
      context,
      DatiSerieIngresso(
        indiceSerie: widget.indiceSerie,
        ripetizioni: ripetizioni,
        peso: double.tryParse(_pesoController.text.trim()),
        rpe: double.tryParse(_rpeController.text.trim()),
        secondiTempo: int.tryParse(_tempoController.text.trim()),
        note: _noteController.text.trim().isEmpty ? null : _noteController.text,
      ),
    );
  }
}

String _formattaPeso(double? peso) {
  if (peso == null) return '';
  if (peso % 1 == 0) return peso.toStringAsFixed(0);
  return peso.toString();
}

class _CampoNumero extends StatelessWidget {
  const _CampoNumero({
    required this.controller,
    required this.etichetta,
    required this.obbligatorio,
    required this.intero,
  });

  final TextEditingController controller;
  final String etichetta;
  final bool obbligatorio;
  final bool intero;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: etichetta),
      keyboardType: intero
          ? TextInputType.number
          : const TextInputType.numberWithOptions(decimal: true),
    );
  }
}
