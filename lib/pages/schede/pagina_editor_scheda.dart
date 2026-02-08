import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/archivio_locale.dart';
import '../../database/converter.dart';
import '../../stato/fornitori.dart';
import '../../utils/gruppi_allenamento.dart';
import '../../utils/navigazione.dart';
import '../esercizi/pagina_editor_esercizio.dart';
import 'pagina_schede.dart';

class PaginaEditorScheda extends ConsumerStatefulWidget {
  const PaginaEditorScheda({super.key, this.schedaId});

  final int? schedaId;

  @override
  ConsumerState<PaginaEditorScheda> createState() => _PaginaEditorSchedaState();
}

class _PaginaEditorSchedaState extends ConsumerState<PaginaEditorScheda> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descrizioneController = TextEditingController();
  final _livelloController = TextEditingController();
  final _noteController = TextEditingController();

  bool _modello = false;
  bool _attiva = true;
  DateTime? _dataAssegnazione;
  DateTime? _dataFine;

  bool _caricamento = false;

  List<ElementoSchedaModificabile> _elementi = [];
  bool _seminaEsercizi = false;

  // Sezioni predefinite (solo per schede nuove o senza sezioni)
  static const List<String> _sezioniPredefinite = [
    'Giorno A',
    'Giorno B',
    'Giorno C',
  ];
  final List<String> _sezioniDisponibili = [];
  static const EdgeInsets _tabPadding = EdgeInsets.fromLTRB(16, 16, 16, 120);

  @override
  void initState() {
    super.initState();
    Future.microtask(_assicuraEserciziPredefiniti);
    if (widget.schedaId != null) {
      _caricamento = true;
      Future.microtask(_caricaScheda);
    } else {
      _sezioniDisponibili.addAll(_sezioniPredefinite);
    }
  }

  Future<void> _caricaScheda() async {
    final archivio = ref.read(fornitoreArchivioLocale);
    final scheda = await archivio.leggiScheda(widget.schedaId!);
    final elementi = await archivio.guardaEserciziScheda(widget.schedaId!).first;

    if (!mounted) return;

    if (scheda != null) {
      _nomeController.text = scheda.nomeScheda;
      _descrizioneController.text = scheda.descrizione ?? '';
      _livelloController.text = scheda.livelloDifficolta ?? '';
      _noteController.text = scheda.noteAllenatore ?? '';
      _modello = scheda.modello;
      _attiva = scheda.attiva;
      _dataAssegnazione = scheda.dataAssegnazione;
      _dataFine = scheda.dataFine;

      _elementi = elementi
          .map((e) {
        final infoSezione = decodificaSezioneConGruppo(e.sezione);
        return ElementoSchedaModificabile(
          esercizio: e.esercizio,
          serie: e.serie,
          ripetizioni: e.ripetizioni,
          ripetizioniPiramidali: e.ripetizioniPiramidali,
          tipoRipetizioni: _tipoRipetizioniDaValore(
            e.ripetizioniPiramidali,
          ),
          peso: e.peso,
          durataMinuti: e.durataMinuti,
          noteAllenatore: e.noteAllenatore,
          sezione: infoSezione.sezione,
          ordineSezione: e.ordineSezione,
          ordineEsercizio: e.ordineEsercizio,
          tipoGruppo: infoSezione.tipo,
          gruppoEtichetta: infoSezione.etichetta,
        );
      }).toList();

      _sezioniDisponibili.clear();
      final elementiOrdinati = List<ElementoSchedaModificabile>.from(_elementi)
        ..sort((a, b) {
          final confronto = a.ordineSezione.compareTo(b.ordineSezione);
          if (confronto != 0) return confronto;
          return a.ordineEsercizio.compareTo(b.ordineEsercizio);
        });

      for (final elemento in elementiOrdinati) {
        final sezione = elemento.sezione.trim();
        if (sezione.isEmpty) continue;
        if (!_sezioniDisponibili.contains(sezione)) {
          _sezioniDisponibili.add(sezione);
        }
      }

      if (_sezioniDisponibili.isEmpty) {
        _sezioniDisponibili.addAll(_sezioniPredefinite);
      }

      for (final elemento in _elementi) {
        final sezione = elemento.sezione.trim().isEmpty
            ? _sezioniDisponibili.first
            : elemento.sezione.trim();
        if (!_sezioniDisponibili.contains(sezione)) {
          _sezioniDisponibili.add(sezione);
        }
        elemento.sezione = sezione;
        elemento.ordineSezione = _sezioniDisponibili.indexOf(sezione);
      }

    }

    setState(() => _caricamento = false);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descrizioneController.dispose();
    _livelloController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _assicuraEserciziPredefiniti() async {
    if (_seminaEsercizi) return;
    _seminaEsercizi = true;

    final archivio = ref.read(fornitoreArchivioLocale);
    final presenti = await archivio.select(archivio.esercizi).get();
    final nomiPresenti = presenti
        .map((e) => e.nome.trim().toLowerCase())
        .toSet();

    final daInserire = _eserciziBase
        .where((e) => !nomiPresenti.contains(e.nome.toLowerCase()))
        .map((e) => e.toCompanion())
        .toList();

    if (daInserire.isEmpty) return;

    await archivio.batch((batch) {
      batch.insertAll(archivio.esercizi, daInserire);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;
    final archivio = ref.watch(fornitoreArchivioLocale);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(widget.schedaId == null ? 'Nuova scheda' : 'Modifica scheda'),
          automaticallyImplyLeading: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: IconButton(
                onPressed: () => _salvaScheda(context),
                icon: const Icon(Icons.save, size: 35),
              ),
            )
          ],
          bottom: TabBar(
            indicatorWeight: 3,
            labelStyle: tema.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            labelColor: colori.primary,
            unselectedLabelColor: colori.onSurface.withOpacity(0.6),
            tabs: const [
              Tab(icon: Icon(Icons.description_outlined), text: 'Dettagli'),
              Tab(icon: Icon(Icons.tune), text: 'Impostazioni'),
              Tab(icon: Icon(Icons.view_agenda_outlined), text: 'Sezioni'),
              Tab(icon: Icon(Icons.fitness_center), text: 'Esercizi'),
            ],
          ),
        ),
        body: _caricamento
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder<List<EserciziData>>(
                stream: archivio.guardaEsercizi(),
                builder: (context, snapshot) {
                  final eserciziDisponibili = snapshot.data ?? [];

                  return Form(
                    key: _formKey,
                    child: TabBarView(
                      children: [
                        _buildTabDettagli(),
                        _buildTabImpostazioni(),
                        _buildTabSezioni(),
                        _buildTabEsercizi(eserciziDisponibili),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildTabDettagli() {
    return ListView(
      padding: _tabPadding,
      children: [
        _SezioneForm(
          titolo: 'Dettagli scheda',
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome scheda'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Inserisci un nome'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descrizioneController,
                decoration: const InputDecoration(labelText: 'Descrizione'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _livelloController,
                decoration: const InputDecoration(labelText: 'Livello difficoltà'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note allenatore'),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabImpostazioni() {
    final colori = Theme.of(context).colorScheme;
    return ListView(
      padding: _tabPadding,
      children: [
        _SezioneForm(
          titolo: 'Impostazioni',
          child: Column(
            children: [
              SwitchListTile.adaptive(
                title: const Text('Scheda attiva'),
                value: _attiva,
                onChanged: (v) => setState(() => _attiva = v),
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile.adaptive(
                title: const Text('Modello'),
                value: _modello,
                onChanged: (v) => setState(() => _modello = v),
                contentPadding: EdgeInsets.zero,
              ),
              Divider(height: 24, color: colori.onSurface.withOpacity(0.08)),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data fine'),
                subtitle: Text(
                  _dataFine == null ? 'Non impostata' : _formattaData(_dataFine!),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  onPressed: _selezionaDataFine,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabSezioni() {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return ListView(
      padding: _tabPadding,
      children: [
        _SezioneForm(
          titolo: 'Sezioni scheda',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_sezioniDisponibili.isEmpty)
                Text(
                  'Nessuna sezione disponibile',
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: colori.onSurface.withOpacity(0.7),
                  ),
                )
              else
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  onReorder: _riordinaSezioni,
                  buildDefaultDragHandles: false,
                  children: [
                    for (final sezione in _sezioniDisponibili)
                      Container(
                        key: ValueKey(sezione),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colori.primary.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colori.primary.withOpacity(0.18),
                          ),
                        ),
                        child: Row(
                          children: [
                            ReorderableDragStartListener(
                              index: _sezioniDisponibili.indexOf(sezione),
                              child: Icon(
                                Icons.drag_handle,
                                color: colori.onSurface.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                sezione,
                                style: tema.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  _rinominaSezione(context, sezione),
                              icon: const Icon(Icons.edit),
                              tooltip: 'Rinomina',
                            ),
                            IconButton(
                              onPressed: () =>
                                  _eliminaSezione(context, sezione),
                              icon: const Icon(Icons.delete_outline),
                              tooltip: 'Elimina',
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.tonalIcon(
                  onPressed: () => _creaNuovaSezione(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Aggiungi sezione'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabEsercizi(List<EserciziData> eserciziDisponibili) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return ListView(
      padding: _tabPadding,
      children: [
        _IntestazioneEsercizi(
          numeroTotale: _elementi.length,
          onAggiungi: eserciziDisponibili.isEmpty
              ? null
              : () => _apriAggiungiEsercizio(eserciziDisponibili),
        ),
        const SizedBox(height: 8),
        Divider(height: 16, color: colori.onSurface.withOpacity(0.08)),
        const SizedBox(height: 8),
        if (_elementi.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colori.primary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colori.primary.withOpacity(0.18)),
            ),
            child: Text(
              'Nessun esercizio. Aggiungine almeno uno e assegnalo a una sezione.',
              style: tema.textTheme.bodyMedium?.copyWith(
                color: colori.onSurface.withOpacity(0.75),
              ),
            ),
          )
        else
          ..._costruisciBlocchiPerSezione(),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => _salvaScheda(context),
            child: const Text('Salva scheda'),
          ),
        ),
      ],
    );
  }

  List<Widget> _costruisciBlocchiPerSezione() {
    final mappa = <String, List<ElementoSchedaModificabile>>{};
    for (final e in _elementi) {
      final nome = e.sezione.trim().isEmpty ? _sezioniDisponibili.first : e.sezione.trim();
      (mappa[nome] ??= []).add(e);
    }

    // Ordine: prima le sezioni conosciute, poi eventuali altre
    final ordine = <String>[
      ..._sezioniDisponibili.where(mappa.containsKey),
      ...mappa.keys.where((k) => !_sezioniDisponibili.contains(k)).toList(),
    ];

    final blocchi = <Widget>[];

    for (final nomeSezione in ordine) {
      final lista = List<ElementoSchedaModificabile>.from(mappa[nomeSezione] ?? [])
        ..sort((a, b) => a.ordineEsercizio.compareTo(b.ordineEsercizio));
      if (lista.isEmpty) continue;

      blocchi.add(
        _BloccoSezioneEditor(
          titolo: nomeSezione,
          elementi: lista,
          sezioniDisponibili: _sezioniDisponibili,
          onRimuovi: (elemento) {
            setState(() {
              _elementi.remove(elemento);
              _normalizzaOrdini(nomeSezione);
            });
          },
          onSposta: (indice, delta) =>
              _spostaElementoInSezione(nomeSezione, indice, delta),
          onCambiaSezione: (elemento, nuovaSezione) =>
              _cambiaSezioneElemento(elemento, nuovaSezione),
          onAggiorna: () => setState(() {}),
        ).animate().fadeIn(duration: 220.ms),
      );

      blocchi.add(const SizedBox(height: 12));
    }

    return blocchi;
  }

  void _spostaElementoInSezione(String sezione, int indice, int delta) {
    final lista = _elementi
        .where((e) => e.sezione == sezione)
        .toList()
      ..sort((a, b) => a.ordineEsercizio.compareTo(b.ordineEsercizio));

    final nuovoIndice = (indice + delta).clamp(0, lista.length - 1);
    if (nuovoIndice == indice) return;

    final elemento = lista.removeAt(indice);
    lista.insert(nuovoIndice, elemento);

    for (int i = 0; i < lista.length; i++) {
      lista[i].ordineEsercizio = i;
    }

    setState(() {});
  }

  void _cambiaSezioneElemento(
    ElementoSchedaModificabile elemento,
    String nuovaSezione,
  ) {
    final vecchiaSezione = elemento.sezione;
    elemento.sezione = nuovaSezione;
    elemento.ordineSezione = _sezioniDisponibili.indexOf(nuovaSezione);

    final maxOrdine = _elementi
        .where((e) => e.sezione == nuovaSezione && e != elemento)
        .map((e) => e.ordineEsercizio)
        .fold<int>(-1, (a, b) => a > b ? a : b);

    elemento.ordineEsercizio = maxOrdine + 1;

    _normalizzaOrdini(vecchiaSezione);
    _normalizzaOrdini(nuovaSezione);
    setState(() {});
  }

  void _normalizzaOrdini(String sezione) {
    final lista = _elementi
        .where((e) => e.sezione == sezione)
        .toList()
      ..sort((a, b) => a.ordineEsercizio.compareTo(b.ordineEsercizio));

    for (int i = 0; i < lista.length; i++) {
      lista[i].ordineEsercizio = i;
    }
  }

  Future<void> _selezionaDataFine() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataFine ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (data != null) setState(() => _dataFine = data);
  }

  Future<void> _apriAggiungiEsercizio(List<EserciziData> esercizi) async {
    final risultato = await showModalBottomSheet<ElementoSchedaModificabile>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _PannelloAggiungiEsercizio(
        esercizi: esercizi,
        sezioniDisponibili: _sezioniDisponibili,
        onNuovaSezione: () => _creaNuovaSezione(context),
      ),
    );

    if (risultato == null) return;

    // assegna ordine automatico dentro la sezione
    final maxOrdine = _elementi
        .where((e) => e.sezione == risultato.sezione)
        .map((e) => e.ordineEsercizio)
        .fold<int>(-1, (a, b) => a > b ? a : b);

    risultato.ordineEsercizio = maxOrdine + 1;

    setState(() => _elementi.add(risultato));
  }

  Future<void> _salvaScheda(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    if (_elementi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aggiungi almeno un esercizio')),
      );
      return;
    }

    for (final elemento in _elementi) {
      final errore = _validaRipetizioniElemento(elemento);
      if (errore != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errore)),
        );
        return;
      }
    }

    final archivio = ref.read(fornitoreArchivioLocale);
    final idUtente = ref.read(fornitoreIdUtenteCorrente);
    if (idUtente == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Utente non autenticato')),
      );
      return;
    }

    final SchedeCompanion schedaCompanion = widget.schedaId == null
        ? SchedeCompanion.insert(
      nomeScheda: _nomeController.text.trim(),
      descrizione: Value(_descrizioneController.text.trim().isEmpty
          ? null
          : _descrizioneController.text.trim()),
      livelloDifficolta: Value(_livelloController.text.trim().isEmpty
          ? null
          : _livelloController.text.trim()),
      utenteId: idUtente,
      modello: Value(_modello),
      attiva: Value(_attiva),
      dataAssegnazione: Value(_dataAssegnazione ?? DateTime.now()),
      dataFine: Value(_dataFine),
      noteAllenatore: Value(_noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim()),
    )
        : SchedeCompanion(
      id: Value(widget.schedaId!),
      nomeScheda: Value(_nomeController.text.trim()),
      descrizione: Value(_descrizioneController.text.trim().isEmpty
          ? null
          : _descrizioneController.text.trim()),
      livelloDifficolta: Value(_livelloController.text.trim().isEmpty
          ? null
          : _livelloController.text.trim()),
      utenteId: Value(idUtente),
      modello: Value(_modello),
      attiva: Value(_attiva),
      dataAssegnazione: Value(_dataAssegnazione ?? DateTime.now()),
      dataFine: Value(_dataFine),
      noteAllenatore: Value(_noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim()),
    );

    // Ordina gli elementi prima di salvarli (stabilità)
    _elementi.sort((a, b) {
      final c = a.ordineSezione.compareTo(b.ordineSezione);
      if (c != 0) return c;
      return a.ordineEsercizio.compareTo(b.ordineEsercizio);
    });

    final elementi = _elementi.map((e) {
      String? ripetizioniAvanzate;
      int ripetizioniClassiche;
      final notaAllenatore = e.noteAllenatore?.trim();
      final durataMinuti =
          e.durataMinuti != null && e.durataMinuti! > 0 ? e.durataMinuti : null;

      switch (e.tipoRipetizioni) {
        case TipoRipetizioni.classiche:
          ripetizioniAvanzate = null;
          ripetizioniClassiche = e.ripetizioni;
          break;
        case TipoRipetizioni.piramidali:
          ripetizioniAvanzate =
              _normalizzaRipetizioniPiramidali(e.ripetizioniPiramidali ?? '');
          ripetizioniClassiche =
              _primoValorePiramidale(ripetizioniAvanzate) ?? e.ripetizioni;
          break;
        case TipoRipetizioni.split:
          ripetizioniAvanzate =
              _normalizzaRipetizioniSplit(e.ripetizioniPiramidali ?? '');
          ripetizioniClassiche =
              _sommaRipetizioniSplit(ripetizioniAvanzate) ?? e.ripetizioni;
          break;
      }

      return ElementoSchedaIngresso(
        esercizioId: e.esercizio.id,
        serie: e.serie,
        ripetizioni: ripetizioniClassiche,
        ripetizioniPiramidali: ripetizioniAvanzate,
        peso: e.peso,
        sezione: codificaSezioneConGruppo(
          e.sezione,
          e.tipoGruppo,
          e.gruppoEtichetta,
        ),
        ordineSezione: e.ordineSezione,
        ordineEsercizio: e.ordineEsercizio,
        durataMinuti: durataMinuti,
        noteAllenatore:
            notaAllenatore == null || notaAllenatore.isEmpty
                ? null
                : notaAllenatore,
      );
    }).toList();


    await archivio.salvaSchedaConEsercizi(
      scheda: schedaCompanion,
      elementi: elementi,
    );

    if (context.mounted) {
      vaiAllaPaginaPrincipale(
        context,
        const PaginaSchede(),
      );
    }
  }

  String _formattaData(DateTime data) {
    final g = data.day.toString().padLeft(2, '0');
    final m = data.month.toString().padLeft(2, '0');
    return '$g/$m/${data.year}';
  }

  Future<String?> _creaNuovaSezione(BuildContext context) async {
    final controller = TextEditingController();
    final nome = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuova sezione'),
        content: TextField(
          controller: controller,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'Nome sezione',
            hintText: 'Es. Sabato D (full body)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(
              controller.text.trim(),
            ),
            child: const Text('Salva'),
          ),
        ],
      ),
    );

    final pulito = nome?.trim();
    if (pulito == null || pulito.isEmpty) return null;
    if (pulito.contains('||')) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nome sezione non valido')),
        );
      }
      return null;
    }

    final giaPresente = _sezioniDisponibili
        .any((s) => s.toLowerCase() == pulito.toLowerCase());
    if (giaPresente) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sezione già presente')),
        );
      }
      return null;
    }

    if (!mounted) return null;
    setState(() => _sezioniDisponibili.add(pulito));
    return pulito;
  }

  void _riordinaSezioni(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    if (oldIndex == newIndex) return;

    setState(() {
      final sezione = _sezioniDisponibili.removeAt(oldIndex);
      _sezioniDisponibili.insert(newIndex, sezione);
      for (final elemento in _elementi) {
        elemento.ordineSezione =
            _sezioniDisponibili.indexOf(elemento.sezione);
      }
    });
  }

  Future<void> _rinominaSezione(BuildContext context, String sezione) async {
    final controller = TextEditingController(text: sezione);
    final nuovoNome = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rinomina sezione'),
        content: TextField(
          controller: controller,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'Nuovo nome',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(
              controller.text.trim(),
            ),
            child: const Text('Salva'),
          ),
        ],
      ),
    );

    final pulito = nuovoNome?.trim();
    if (pulito == null || pulito.isEmpty || pulito == sezione) return;
    if (pulito.contains('||')) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nome sezione non valido')),
        );
      }
      return;
    }

    final giaPresente = _sezioniDisponibili.any(
      (s) => s.toLowerCase() == pulito.toLowerCase(),
    );
    if (giaPresente) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sezione già presente')),
        );
      }
      return;
    }

    final indice = _sezioniDisponibili.indexOf(sezione);
    if (indice == -1) return;

    setState(() {
      _sezioniDisponibili[indice] = pulito;
      for (final elemento in _elementi) {
        if (elemento.sezione == sezione) {
          elemento.sezione = pulito;
        }
        elemento.ordineSezione =
            _sezioniDisponibili.indexOf(elemento.sezione);
      }
    });
  }

  Future<void> _eliminaSezione(BuildContext context, String sezione) async {
    if (!_sezioniDisponibili.contains(sezione)) return;

    final elementiSezione =
        _elementi.where((e) => e.sezione == sezione).toList();

    if (elementiSezione.isNotEmpty && _sezioniDisponibili.length == 1) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Crea un'altra sezione prima di eliminare questa."),
          ),
        );
      }
      return;
    }

    if (elementiSezione.isEmpty) {
      setState(() {
        _sezioniDisponibili.remove(sezione);
        for (final elemento in _elementi) {
          elemento.ordineSezione =
              _sezioniDisponibili.indexOf(elemento.sezione);
        }
      });
      return;
    }

    final sezioniAlternative =
        _sezioniDisponibili.where((s) => s != sezione).toList();
    String target = sezioniAlternative.first;

    final azione = await showDialog<_AzioneEliminaSezione>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Elimina sezione'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Questa sezione contiene ${elementiSezione.length} esercizi.',
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: target,
                isExpanded: true,
                items: sezioniAlternative
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setStateDialog(() => target = v);
                },
                decoration:
                    const InputDecoration(labelText: 'Sposta esercizi in'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(_AzioneEliminaSezione.elimina),
              child: const Text('Elimina esercizi'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(_AzioneEliminaSezione.sposta),
              child: const Text('Sposta'),
            ),
          ],
        ),
      ),
    );

    if (azione == null) return;

    setState(() {
      if (azione == _AzioneEliminaSezione.sposta) {
        for (final elemento in elementiSezione) {
          elemento.sezione = target;
          elemento.ordineSezione = _sezioniDisponibili.indexOf(target);
        }
        _normalizzaOrdini(target);
      } else {
        _elementi.removeWhere((e) => e.sezione == sezione);
      }

      _sezioniDisponibili.remove(sezione);
      for (final elemento in _elementi) {
        elemento.ordineSezione =
            _sezioniDisponibili.indexOf(elemento.sezione);
      }
      _normalizzaOrdini(sezione);
    });
  }
}

enum _AzioneEliminaSezione { sposta, elimina }

/// ----------------------
/// UI HELPERS EDITOR
/// ----------------------

class _SezioneForm extends StatelessWidget {
  const _SezioneForm({required this.titolo, required this.child});

  final String titolo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colori.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colori.onSurface.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titolo,
            style: tema.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

String _etichettaSezioneBreve(String sezione) {
  final pulita = sezione.trim();
  if (pulita.isEmpty) return 'S';
  final match = RegExp(r'\b([A-Z])\b').firstMatch(pulita.toUpperCase());
  if (match != null) return match.group(1)!;
  if (pulita.length <= 2) return pulita.toUpperCase();
  return pulita.substring(0, 1).toUpperCase();
}

enum TipoRipetizioni { classiche, piramidali, split }

TipoRipetizioni _tipoRipetizioniDaValore(String? valore) {
  final pulito = valore?.trim() ?? '';
  if (pulito.isEmpty) return TipoRipetizioni.classiche;
  if (pulito.contains('+')) return TipoRipetizioni.split;
  return TipoRipetizioni.piramidali;
}

String? _normalizzaRipetizioniPiramidali(String valore) {
  final pulito = valore.trim();
  if (pulito.isEmpty) return null;
  final parti = pulito.split('/').map((e) => e.trim()).where((e) => e.isNotEmpty);
  return parti.isEmpty ? null : parti.join('/');
}

List<int>? _parseRipetizioniPiramidali(String valore) {
  final normalizzato = _normalizzaRipetizioniPiramidali(valore);
  if (normalizzato == null) return null;
  final parti = normalizzato.split('/');
  final numeri = <int>[];
  for (final parte in parti) {
    final valoreNumero = int.tryParse(parte);
    if (valoreNumero == null || valoreNumero <= 0) return null;
    numeri.add(valoreNumero);
  }
  return numeri;
}

String? _normalizzaRipetizioniSplit(String valore) {
  final pulito = valore.trim();
  if (pulito.isEmpty) return null;
  final parti = pulito.split('+').map((e) => e.trim()).where((e) => e.isNotEmpty);
  return parti.isEmpty ? null : parti.join('+');
}

List<int>? _parseRipetizioniSplit(String valore) {
  final normalizzato = _normalizzaRipetizioniSplit(valore);
  if (normalizzato == null) return null;
  final parti = normalizzato.split('+');
  final numeri = <int>[];
  for (final parte in parti) {
    final valoreNumero = int.tryParse(parte);
    if (valoreNumero == null || valoreNumero <= 0) return null;
    numeri.add(valoreNumero);
  }
  return numeri;
}

String? _erroreRipetizioniPiramidali(String valore, int serie) {
  final numeri = _parseRipetizioniPiramidali(valore);
  if (numeri == null) return 'Inserisci valori numerici positivi';
  if (numeri.length != serie) {
    return 'Inserisci $serie valori (uno per serie)';
  }
  return null;
}

String? _erroreRipetizioniSplit(String valore) {
  final numeri = _parseRipetizioniSplit(valore);
  if (numeri == null) return 'Inserisci valori numerici positivi';
  if (numeri.length < 2) {
    return 'Inserisci almeno 2 valori (es. 10+10)';
  }
  return null;
}

int? _primoValorePiramidale(String? valore) {
  if (valore == null || valore.trim().isEmpty) return null;
  final numeri = _parseRipetizioniPiramidali(valore);
  if (numeri == null || numeri.isEmpty) return null;
  return numeri.first;
}

int? _sommaRipetizioniSplit(String? valore) {
  if (valore == null || valore.trim().isEmpty) return null;
  final numeri = _parseRipetizioniSplit(valore);
  if (numeri == null || numeri.isEmpty) return null;
  return numeri.fold<int>(0, (a, b) => a + b);
}

String? _validaRipetizioniElemento(ElementoSchedaModificabile elemento) {
  if (elemento.serie <= 0) {
    return 'Numero serie non valido per ${elemento.esercizio.nome}';
  }
  if (elemento.tipoRipetizioni == TipoRipetizioni.classiche) {
    if (elemento.ripetizioni <= 0) {
      return 'Ripetizioni non valide per ${elemento.esercizio.nome}';
    }
    return null;
  }
  final valore = elemento.ripetizioniPiramidali ?? '';
  if (elemento.tipoRipetizioni == TipoRipetizioni.piramidali) {
    final errore = _erroreRipetizioniPiramidali(valore, elemento.serie);
    if (errore == null) return null;
    return '${elemento.esercizio.nome}: $errore';
  }
  final errore = _erroreRipetizioniSplit(valore);
  if (errore == null) return null;
  return '${elemento.esercizio.nome}: $errore';
}

const List<_EsercizioSeed> _eserciziBase = [
  _EsercizioSeed(
    nome: 'Alzate laterali manubri seduto',
    descrizione: 'Alzate laterali seduto con manubri',
    muscoloObiettivo: 'Deltoidi laterali',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.spalle,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/alzate-laterali-manubri-seduto.png',
  ),
  _EsercizioSeed(
    nome: 'Alzate laterali singolo cavo',
    descrizione: 'Alzate laterali al cavo, un braccio alla volta',
    muscoloObiettivo: 'Spalle',
    attrezzo: Attrezzo.cavo,
    gruppoMuscolare: GruppoMuscolare.spalle,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/alzate-laterali-singolo-cavo.png',
  ),
  _EsercizioSeed(
    nome: 'Calf machine',
    descrizione: 'Calf raise alla macchina',
    muscoloObiettivo: 'Polpacci',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.polpacci,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/calf-machine.png',
  ),
  _EsercizioSeed(
    nome: 'Chiusure cavi alti',
    descrizione: 'Chiusure ai cavi alti in piedi',
    muscoloObiettivo: 'Pettorali superiori',
    attrezzo: Attrezzo.cavo,
    gruppoMuscolare: GruppoMuscolare.pettorali,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/chiusure-cavi-alti.png',
  ),
  _EsercizioSeed(
    nome: 'Crossover cavi alti',
    descrizione: 'Crossover ai cavi alti, traiettoria controllata',
    muscoloObiettivo: 'Pettorali',
    attrezzo: Attrezzo.cavo,
    gruppoMuscolare: GruppoMuscolare.pettorali,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/crossover-cavi-alti.png',
  ),
  _EsercizioSeed(
    nome: 'French press bilanciere',
    descrizione: 'French press con bilanciere su panca',
    muscoloObiettivo: 'Tricipiti',
    attrezzo: Attrezzo.bilanciere,
    gruppoMuscolare: GruppoMuscolare.tricipiti,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/french-press-bilanciere.png',
  ),
  _EsercizioSeed(
    nome: 'Hack squat',
    descrizione: 'Hack squat alla macchina',
    muscoloObiettivo: 'Quadricipiti',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.quadricipiti,
    durataMinuti: 8,
    intensita: 'Alta',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/hack-squat.png',
  ),
  _EsercizioSeed(
    nome: 'Push cavi',
    descrizione: 'Pushdown ai cavi per tricipiti',
    muscoloObiettivo: 'Tricipiti',
    attrezzo: Attrezzo.cavo,
    gruppoMuscolare: GruppoMuscolare.tricipiti,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/push-cavi.png',
  ),
  _EsercizioSeed(
    nome: 'Spinte manubri panca piana',
    descrizione: 'Spinte con manubri su panca piana',
    muscoloObiettivo: 'Pettorali',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.pettorali,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/spinte-manubri-panca-piana.png',
  ),
  _EsercizioSeed(
    nome: 'Spinte panca alta manubri',
    descrizione: 'Spinte con manubri su panca inclinata',
    muscoloObiettivo: 'Pettorali superiori',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.pettorali,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/spinte-panca-alta-manubri.png',
  ),
  _EsercizioSeed(
    nome: 'Spinte seduto manubri',
    descrizione: 'Spinte da seduto con manubri',
    muscoloObiettivo: 'Spalle',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.spalle,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/spinte-seduto-manubri.png',
  ),
  _EsercizioSeed(
    nome: 'Lat machine inverso',
    descrizione: 'Remata inversa alla macchina',
    muscoloObiettivo: 'Dorsali',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.dorsali,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/at-machine-inverso.png',
  ),
  _EsercizioSeed(
    nome: 'Burpees',
    descrizione: 'Burpee completo a corpo libero',
    muscoloObiettivo: 'Full body',
    attrezzo: Attrezzo.corpoLibero,
    gruppoMuscolare: GruppoMuscolare.addominali,
    durataMinuti: 6,
    intensita: 'Alta',
    obiettivi: 'Resistenza',
    urlImmagine: 'assets/esercizi/burpees.png',
  ),
  _EsercizioSeed(
    nome: 'Crunch con wallball',
    descrizione: 'Crunch con palla medica',
    muscoloObiettivo: 'Addominali',
    attrezzo: Attrezzo.altro,
    gruppoMuscolare: GruppoMuscolare.addominali,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Stabilità',
    urlImmagine: 'assets/esercizi/crunch-con-wallball.png',
  ),
  _EsercizioSeed(
    nome: 'Crunch inverso',
    descrizione: 'Crunch inverso a terra',
    muscoloObiettivo: 'Addominali bassi',
    attrezzo: Attrezzo.corpoLibero,
    gruppoMuscolare: GruppoMuscolare.addominali,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Stabilità',
    urlImmagine: 'assets/esercizi/crunch-inverso.png',
  ),
  _EsercizioSeed(
    nome: 'Crunch panca reclinata',
    descrizione: 'Crunch su panca reclinata',
    muscoloObiettivo: 'Addominali',
    attrezzo: Attrezzo.altro,
    gruppoMuscolare: GruppoMuscolare.addominali,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Stabilità',
    urlImmagine: 'assets/esercizi/crunch-panca-reclinata.png',
  ),
  _EsercizioSeed(
    nome: 'Crunch terra',
    descrizione: 'Crunch a terra',
    muscoloObiettivo: 'Addominali',
    attrezzo: Attrezzo.corpoLibero,
    gruppoMuscolare: GruppoMuscolare.addominali,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Stabilità',
    urlImmagine: 'assets/esercizi/crunch-terra.png',
  ),
  _EsercizioSeed(
    nome: 'Crunch terra alternato',
    descrizione: 'Crunch alternato a terra',
    muscoloObiettivo: 'Addominali obliqui',
    attrezzo: Attrezzo.corpoLibero,
    gruppoMuscolare: GruppoMuscolare.addominali,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Stabilità',
    urlImmagine: 'assets/esercizi/crunch-terra-alternato.png',
  ),
  _EsercizioSeed(
    nome: 'Curl bilanciere',
    descrizione: 'Curl con bilanciere',
    muscoloObiettivo: 'Bicipiti',
    attrezzo: Attrezzo.bilanciere,
    gruppoMuscolare: GruppoMuscolare.bicipiti,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/curl-bilanciere.png',
  ),
  _EsercizioSeed(
    nome: 'Curl manubri martello alternato',
    descrizione: 'Curl a martello alternato',
    muscoloObiettivo: 'Bicipiti',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.bicipiti,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/curl-manubri-martello-alternato.png',
  ),
  _EsercizioSeed(
    nome: 'Curl manubri seduto',
    descrizione: 'Curl seduto con manubri',
    muscoloObiettivo: 'Bicipiti',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.bicipiti,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/curl-manubri-seduto.png',
  ),
  _EsercizioSeed(
    nome: 'Curl panca scott bilanciere',
    descrizione: 'Curl su panca Scott con bilanciere',
    muscoloObiettivo: 'Bicipiti',
    attrezzo: Attrezzo.bilanciere,
    gruppoMuscolare: GruppoMuscolare.bicipiti,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/curl-panca-scott-bilanciere.png',
  ),
  _EsercizioSeed(
    nome: 'Dips parallele',
    descrizione: 'Dips alle parallele',
    muscoloObiettivo: 'Tricipiti',
    attrezzo: Attrezzo.corpoLibero,
    gruppoMuscolare: GruppoMuscolare.tricipiti,
    durataMinuti: 5,
    intensita: 'Alta',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/dips-parallele.png',
  ),
  _EsercizioSeed(
    nome: 'French press 1 manubrio seduto',
    descrizione: 'French press seduto con un manubrio',
    muscoloObiettivo: 'Tricipiti',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.tricipiti,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/french-pres-1man-seduto.png',
  ),
  _EsercizioSeed(
    nome: 'French press 2 manubri panca',
    descrizione: 'French press su panca con due manubri',
    muscoloObiettivo: 'Tricipiti',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.tricipiti,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/french-press-2man-panca.png',
  ),
  _EsercizioSeed(
    nome: 'Lat machine avanti',
    descrizione: 'Lat machine avanti',
    muscoloObiettivo: 'Dorsali',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.dorsali,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/lat-machine-avanti.png',
  ),
  _EsercizioSeed(
    nome: 'Leg curl',
    descrizione: 'Leg curl alla macchina',
    muscoloObiettivo: 'Femorali',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.femorali,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/leg-curl.png',
  ),
  _EsercizioSeed(
    nome: 'Leg curl seduto',
    descrizione: 'Leg curl da seduto',
    muscoloObiettivo: 'Femorali',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.femorali,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/leg-curl-seduto.png',
  ),
  _EsercizioSeed(
    nome: 'Leg extension',
    descrizione: 'Leg extension alla macchina',
    muscoloObiettivo: 'Quadricipiti',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.quadricipiti,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/leg-extension.png',
  ),
  _EsercizioSeed(
    nome: 'Leg press',
    descrizione: 'Leg press alla macchina',
    muscoloObiettivo: 'Gambe',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.quadricipiti,
    durataMinuti: 7,
    intensita: 'Alta',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/leg-press.png',
  ),
  _EsercizioSeed(
    nome: 'Leg raise',
    descrizione: 'Leg raise a terra',
    muscoloObiettivo: 'Addominali',
    attrezzo: Attrezzo.corpoLibero,
    gruppoMuscolare: GruppoMuscolare.addominali,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Stabilità',
    urlImmagine: 'assets/esercizi/leg-raise.png',
  ),
  _EsercizioSeed(
    nome: 'Stacchi gambe tese',
    descrizione: 'Stacchi a gambe tese con bilanciere',
    muscoloObiettivo: 'Femorali',
    attrezzo: Attrezzo.bilanciere,
    gruppoMuscolare: GruppoMuscolare.femorali,
    durataMinuti: 7,
    intensita: 'Alta',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/stacchi-gambe-tese.png',
  ),
  _EsercizioSeed(
    nome: 'Vertical row',
    descrizione: 'Rematore verticale alla macchina',
    muscoloObiettivo: 'Dorsali',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.dorsali,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/vertical-row.png',
  ),
  _EsercizioSeed(
    nome: 'Affondi manubri',
    descrizione: 'Affondi con manubri',
    muscoloObiettivo: 'Gambe',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.quadricipiti,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/affondi-manubri.png',
  ),
  _EsercizioSeed(
    nome: 'Alzate laterali manubri',
    descrizione: 'Alzate laterali con manubri',
    muscoloObiettivo: 'Spalle',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.spalle,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/alzate-laterali-manubri.png',
  ),
  _EsercizioSeed(
    nome: 'Alzate laterali manubri busto 90',
    descrizione: 'Alzate laterali busto a 90 gradi',
    muscoloObiettivo: 'Spalle posteriori',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.spalle,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/alzate-laterali-manubri-busto-90.png',
  ),
  _EsercizioSeed(
    nome: 'Alzate laterali seduto busto 90',
    descrizione: 'Alzate laterali seduto busto a 90 gradi',
    muscoloObiettivo: 'Spalle posteriori',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.spalle,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/alzate-laterali-seduto-busto-90.png',
  ),
  _EsercizioSeed(
    nome: 'Aperture inverse',
    descrizione: 'Aperture inverse per deltoidi posteriori',
    muscoloObiettivo: 'Spalle posteriori',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.spalle,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/aperture-inverse.png',
  ),
  _EsercizioSeed(
    nome: 'Aperture panca piana manubri',
    descrizione: 'Aperture con manubri su panca piana',
    muscoloObiettivo: 'Pettorali',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.pettorali,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/aperture-panca-piana-manubri.png',
  ),
  _EsercizioSeed(
    nome: 'Arnold press',
    descrizione: 'Spinte Arnold con manubri',
    muscoloObiettivo: 'Spalle',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.spalle,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/arnold-press.png',
  ),
  _EsercizioSeed(
    nome: 'Calf machine seduto',
    descrizione: 'Calf raise da seduto alla macchina',
    muscoloObiettivo: 'Polpacci',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.polpacci,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/calf-machine-seduto.png',
  ),
  _EsercizioSeed(
    nome: 'Calf pressa orizzontale',
    descrizione: 'Calf raise alla pressa orizzontale',
    muscoloObiettivo: 'Polpacci',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.polpacci,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/calf-pressa-orizzontale.png',
  ),
  _EsercizioSeed(
    nome: 'Chest press',
    descrizione: 'Spinte alla macchina chest press',
    muscoloObiettivo: 'Pettorali',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.pettorali,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/chest-press.png',
  ),
  _EsercizioSeed(
    nome: 'Chiusure cavi bassi',
    descrizione: 'Chiusure ai cavi bassi',
    muscoloObiettivo: 'Pettorali',
    attrezzo: Attrezzo.cavo,
    gruppoMuscolare: GruppoMuscolare.pettorali,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/chiusure-cavi-bassi.png',
  ),
  _EsercizioSeed(
    nome: 'Curl cavi alti',
    descrizione: 'Curl ai cavi alti',
    muscoloObiettivo: 'Bicipiti',
    attrezzo: Attrezzo.cavo,
    gruppoMuscolare: GruppoMuscolare.bicipiti,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/curl-cavi-alti.png',
  ),
  _EsercizioSeed(
    nome: 'Pullover manubrio',
    descrizione: 'Pullover con manubrio',
    muscoloObiettivo: 'Pettorali',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.pettorali,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/PULLOVER-MANUBRIO.png',
  ),
  _EsercizioSeed(
    nome: 'Push up',
    descrizione: 'Push up a corpo libero',
    muscoloObiettivo: 'Pettorali',
    attrezzo: Attrezzo.corpoLibero,
    gruppoMuscolare: GruppoMuscolare.pettorali,
    durataMinuti: 4,
    intensita: 'Media',
    obiettivi: 'Resistenza',
    urlImmagine: 'assets/esercizi/push-up.png',
  ),
  _EsercizioSeed(
    nome: 'Squat bilanciere',
    descrizione: 'Squat con bilanciere',
    muscoloObiettivo: 'Quadricipiti',
    attrezzo: Attrezzo.bilanciere,
    gruppoMuscolare: GruppoMuscolare.quadricipiti,
    durataMinuti: 8,
    intensita: 'Alta',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/squat-bilanciere.png',
  ),
  _EsercizioSeed(
    nome: 'Squat multipower',
    descrizione: 'Squat al multipower',
    muscoloObiettivo: 'Quadricipiti',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.quadricipiti,
    durataMinuti: 8,
    intensita: 'Alta',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/squat-multipower.png',
  ),
  _EsercizioSeed(
    nome: 'Upper back',
    descrizione: 'Upper back alla macchina',
    muscoloObiettivo: 'Dorsali',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.dorsali,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/upper-back.png',
  ),
  _EsercizioSeed(
    nome: 'Rematore 1 manubrio busto 90',
    descrizione: 'Rematore con un manubrio busto a 90 gradi',
    muscoloObiettivo: 'Dorsali',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.dorsali,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/1MAN-BUSTO90.png',
  ),
  _EsercizioSeed(
    nome: 'Accosciata cavo basso',
    descrizione: 'Accosciata al cavo basso',
    muscoloObiettivo: 'Glutei',
    attrezzo: Attrezzo.cavo,
    gruppoMuscolare: GruppoMuscolare.glutei,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/ACCOSCIATA-CAVO-BASSO.png',
  ),
  _EsercizioSeed(
    nome: 'Aperture manubri panca alta',
    descrizione: 'Aperture con manubri su panca inclinata',
    muscoloObiettivo: 'Pettorali superiori',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.pettorali,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/APERTURE-MANUBRI-PANCA-ALTA.png',
  ),
  _EsercizioSeed(
    nome: 'Bayesian curl singolo cavo basso',
    descrizione: 'Bayesian curl al cavo basso, singolo braccio',
    muscoloObiettivo: 'Bicipiti',
    attrezzo: Attrezzo.cavo,
    gruppoMuscolare: GruppoMuscolare.bicipiti,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/BAYESIAN-CURL-SINGOLO-CAVO-BASSO.png',
  ),
  _EsercizioSeed(
    nome: 'Bike seduto',
    descrizione: 'Bike da seduto a ritmo costante',
    muscoloObiettivo: 'Gambe',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.quadricipiti,
    durataMinuti: 10,
    intensita: 'Media',
    obiettivi: 'Resistenza',
    urlImmagine: 'assets/esercizi/BIKE-SEDUTO.png',
  ),
  _EsercizioSeed(
    nome: 'Corsa tappeto',
    descrizione: 'Corsa su tapis roulant',
    muscoloObiettivo: 'Gambe',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.quadricipiti,
    durataMinuti: 10,
    intensita: 'Media',
    obiettivi: 'Resistenza',
    urlImmagine: 'assets/esercizi/CORSA-TAPPETO.png',
  ),
  _EsercizioSeed(
    nome: 'Cyclette',
    descrizione: 'Cyclette a ritmo costante',
    muscoloObiettivo: 'Gambe',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.quadricipiti,
    durataMinuti: 10,
    intensita: 'Media',
    obiettivi: 'Resistenza',
    urlImmagine: 'assets/esercizi/CYCLETTE.png',
  ),
  _EsercizioSeed(
    nome: 'Distensioni bilanciere panca piana multipower',
    descrizione: 'Distensioni su panca piana al multipower',
    muscoloObiettivo: 'Pettorali',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.pettorali,
    durataMinuti: 6,
    intensita: 'Alta',
    obiettivi: 'Forza',
    urlImmagine:
        'assets/esercizi/distensioni-bilanciere-panca-piana-multipower.png',
  ),
  _EsercizioSeed(
    nome: 'Hyperextension',
    descrizione: 'Estensioni del tronco alla panca',
    muscoloObiettivo: 'Lombari',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.dorsali,
    durataMinuti: 5,
    intensita: 'Media',
    obiettivi: 'Stabilità',
    urlImmagine: 'assets/esercizi/HYPEXTENSION.png',
  ),
  _EsercizioSeed(
    nome: 'Pressa 45',
    descrizione: 'Pressa a 45 gradi',
    muscoloObiettivo: 'Quadricipiti',
    attrezzo: Attrezzo.macchina,
    gruppoMuscolare: GruppoMuscolare.quadricipiti,
    durataMinuti: 7,
    intensita: 'Alta',
    obiettivi: 'Forza',
    urlImmagine: 'assets/esercizi/PRESSA-45.png',
  ),
  _EsercizioSeed(
    nome: 'Pulley triangolo',
    descrizione: 'Pulley con triangolo',
    muscoloObiettivo: 'Dorsali',
    attrezzo: Attrezzo.cavo,
    gruppoMuscolare: GruppoMuscolare.dorsali,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/PULLEY-TRIANGOLO.png',
  ),
  _EsercizioSeed(
    nome: 'Rematore bilanciere',
    descrizione: 'Rematore con bilanciere',
    muscoloObiettivo: 'Dorsali',
    attrezzo: Attrezzo.bilanciere,
    gruppoMuscolare: GruppoMuscolare.dorsali,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/REMATORE-BILANCIERE.png',
  ),
  _EsercizioSeed(
    nome: 'Rematore manubrio su panca',
    descrizione: 'Rematore con manubrio su panca',
    muscoloObiettivo: 'Dorsali',
    attrezzo: Attrezzo.manubri,
    gruppoMuscolare: GruppoMuscolare.dorsali,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/REMATORE-MANUBRIO-SU-PANCA.png',
  ),
  _EsercizioSeed(
    nome: 'Spinte bilanciere panca presa stretta',
    descrizione: 'Spinte con bilanciere a presa stretta',
    muscoloObiettivo: 'Tricipiti',
    attrezzo: Attrezzo.bilanciere,
    gruppoMuscolare: GruppoMuscolare.tricipiti,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/SPINTE-BILANCIERE-PANCA-PRESA-STRETTA.png',
  ),
  _EsercizioSeed(
    nome: 'Trazioni pulley basso',
    descrizione: 'Trazioni al pulley basso',
    muscoloObiettivo: 'Dorsali',
    attrezzo: Attrezzo.cavo,
    gruppoMuscolare: GruppoMuscolare.dorsali,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/TRAZIONI-PULLEY-BASSO.png',
  ),
  _EsercizioSeed(
    nome: 'Trazioni Tbar bilanciere',
    descrizione: 'Trazioni T-bar con bilanciere',
    muscoloObiettivo: 'Dorsali',
    attrezzo: Attrezzo.bilanciere,
    gruppoMuscolare: GruppoMuscolare.dorsali,
    durataMinuti: 6,
    intensita: 'Media',
    obiettivi: 'Ipertrofia',
    urlImmagine: 'assets/esercizi/Trazioni-Tbar_Bilanciere.png',
  ),
];

class _IntestazioneEsercizi extends StatelessWidget {
  const _IntestazioneEsercizi({
    required this.numeroTotale,
    required this.onAggiungi,
  });

  final int numeroTotale;
  final VoidCallback? onAggiungi;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            'Esercizi in scheda ($numeroTotale)',
            style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        FilledButton.icon(
          onPressed: onAggiungi,
          icon: const Icon(Icons.add),
          label: const Text('Aggiungi'),
        ),
      ],
    );
  }
}

class _BloccoSezioneEditor extends StatelessWidget {
  const _BloccoSezioneEditor({
    required this.titolo,
    required this.elementi,
    required this.sezioniDisponibili,
    required this.onRimuovi,
    required this.onSposta,
    required this.onCambiaSezione,
    required this.onAggiorna,
  });

  final String titolo;
  final List<ElementoSchedaModificabile> elementi;
  final List<String> sezioniDisponibili;
  final void Function(ElementoSchedaModificabile elemento) onRimuovi;
  final void Function(int indice, int delta) onSposta;
  final void Function(ElementoSchedaModificabile elemento, String nuovaSezione)
      onCambiaSezione;
  final VoidCallback onAggiorna;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colori.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colori.primary.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.view_agenda, color: colori.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  titolo,
                  style: tema.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '${elementi.length}',
                style: tema.textTheme.labelLarge?.copyWith(
                  color: colori.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < elementi.length; i++)
            _CardElementoEditor(
              elemento: elementi[i],
              etichettaOrdine: '${_etichettaSezioneBreve(titolo)}${i + 1}',
              indice: i,
              totale: elementi.length,
              sezioniDisponibili: sezioniDisponibili,
              onRimuovi: () => onRimuovi(elementi[i]),
              onSposta: (delta) => onSposta(i, delta),
              onCambiaSezione: (sezione) =>
                  onCambiaSezione(elementi[i], sezione),
              onAggiorna: onAggiorna,
            ),
        ],
      ),
    );
  }
}

class _CardElementoEditor extends StatelessWidget {
  const _CardElementoEditor({
    required this.elemento,
    required this.etichettaOrdine,
    required this.indice,
    required this.totale,
    required this.sezioniDisponibili,
    required this.onRimuovi,
    required this.onSposta,
    required this.onCambiaSezione,
    required this.onAggiorna,
  });

  final ElementoSchedaModificabile elemento;
  final String etichettaOrdine;
  final int indice;
  final int totale;
  final List<String> sezioniDisponibili;
  final VoidCallback onRimuovi;
  final void Function(int delta) onSposta;
  final ValueChanged<String> onCambiaSezione;
  final VoidCallback onAggiorna;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colori.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    etichettaOrdine,
                    style: tema.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colori.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    elemento.esercizio.nome,
                    style: tema.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: indice == 0 ? null : () => onSposta(-1),
                  icon: const Icon(Icons.arrow_upward),
                  tooltip: 'Sposta su',
                ),
                IconButton(
                  onPressed: indice >= totale - 1 ? null : () => onSposta(1),
                  icon: const Icon(Icons.arrow_downward),
                  tooltip: 'Sposta giù',
                ),
                IconButton(
                  onPressed: onRimuovi,
                  icon: const Icon(Icons.close),
                  tooltip: 'Rimuovi',
                ),
              ],
            ),
            if (elemento.tipoGruppo != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: _ChipGruppo(
                  testo: testoGruppoAllenamento(
                    elemento.tipoGruppo,
                    elemento.gruppoEtichetta,
                  ),
                ),
              ),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: elemento.sezione,
              isExpanded: true,
              items: sezioniDisponibili
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                onCambiaSezione(v);
              },
              decoration: const InputDecoration(labelText: 'Sezione'),
            ),

            const SizedBox(height: 12),
            DropdownButtonFormField<TipoGruppoAllenamento?>(
              value: elemento.tipoGruppo,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: null,
                  child: Text('Nessun gruppo'),
                ),
                DropdownMenuItem(
                  value: TipoGruppoAllenamento.superset,
                  child: Text('Superset'),
                ),
                DropdownMenuItem(
                  value: TipoGruppoAllenamento.circuito,
                  child: Text('Circuito'),
                ),
              ],
              onChanged: (v) {
                elemento.tipoGruppo = v;
                if (v == null) {
                  elemento.gruppoEtichetta = null;
                }
                onAggiorna();
              },
              decoration: const InputDecoration(
                labelText: 'Gruppo',
                helperText: 'Usa lo stesso gruppo per creare superset/circuiti',
              ),
            ),
            if (elemento.tipoGruppo != null) ...[
              const SizedBox(height: 8),
              TextFormField(
                initialValue: elemento.gruppoEtichetta ?? '',
                decoration: const InputDecoration(
                  labelText: 'Etichetta gruppo (es. A, 1)',
                ),
                onChanged: (v) {
                  final pulito = v.trim();
                  elemento.gruppoEtichetta = pulito.isEmpty ? null : pulito;
                },
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: elemento.serie.toString(),
                    decoration: const InputDecoration(labelText: 'Serie'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      final x = int.tryParse(v);
                      if (x != null) {
                        elemento.serie = x;
                        onAggiorna();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: elemento.peso?.toString() ?? '',
                    decoration: const InputDecoration(labelText: 'Peso'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) {
                      elemento.peso = double.tryParse(v);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<TipoRipetizioni>(
              segments: const [
                ButtonSegment(
                  value: TipoRipetizioni.classiche,
                  label: Text('Classiche'),
                ),
                ButtonSegment(
                  value: TipoRipetizioni.piramidali,
                  label: Text('Piramidali'),
                ),
                ButtonSegment(
                  value: TipoRipetizioni.split,
                  label: Text('Split'),
                ),
              ],
              selected: {elemento.tipoRipetizioni},
              onSelectionChanged: (valori) {
                final nuovo = valori.first;
                if (nuovo == elemento.tipoRipetizioni) return;
                elemento.tipoRipetizioni = nuovo;
                if (nuovo == TipoRipetizioni.classiche) {
                  elemento.ripetizioniPiramidali = null;
                } else {
                  elemento.ripetizioniPiramidali = '';
                }
                onAggiorna();
              },
            ),
            const SizedBox(height: 10),
            if (elemento.tipoRipetizioni == TipoRipetizioni.classiche)
              TextFormField(
                initialValue: elemento.ripetizioni.toString(),
                decoration: const InputDecoration(labelText: 'Ripetizioni'),
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  final x = int.tryParse(v);
                  if (x != null) {
                    elemento.ripetizioni = x;
                  }
                },
              )
            else if (elemento.tipoRipetizioni == TipoRipetizioni.piramidali)
              TextFormField(
                initialValue: elemento.ripetizioniPiramidali ?? '',
                decoration: InputDecoration(
                  labelText: 'Ripetizioni piramidali',
                  helperText:
                      'Inserisci ${elemento.serie} valori (es. 10/8/6)',
                  errorText: _erroreRipetizioniPiramidali(
                    elemento.ripetizioniPiramidali ?? '',
                    elemento.serie,
                  ),
                ),
                keyboardType: TextInputType.text,
                onChanged: (v) {
                  elemento.ripetizioniPiramidali = v;
                  onAggiorna();
                },
              ),
            if (elemento.tipoRipetizioni == TipoRipetizioni.split)
              TextFormField(
                initialValue: elemento.ripetizioniPiramidali ?? '',
                decoration: InputDecoration(
                  labelText: 'Ripetizioni split',
                  helperText: 'Es. 10+10 (rest-pause/cluster)',
                  errorText: _erroreRipetizioniSplit(
                    elemento.ripetizioniPiramidali ?? '',
                  ),
                ),
                keyboardType: TextInputType.text,
                onChanged: (v) {
                  elemento.ripetizioniPiramidali = v;
                  onAggiorna();
                },
              ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: elemento.durataMinuti?.toString() ?? '',
              decoration: const InputDecoration(
                labelText: 'Durata (min)',
                helperText: 'Opzionale (es. isometria)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) {
                final pulito = v.trim();
                if (pulito.isEmpty) {
                  elemento.durataMinuti = null;
                  onAggiorna();
                  return;
                }
                final x = int.tryParse(pulito);
                elemento.durataMinuti = x != null && x > 0 ? x : null;
                onAggiorna();
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: elemento.noteAllenatore ?? '',
              decoration: const InputDecoration(
                labelText: 'Note allenatore',
                helperText: 'Opzionale',
              ),
              maxLines: 3,
              onChanged: (v) {
                final pulito = v.trim();
                elemento.noteAllenatore = pulito.isEmpty ? null : pulito;
                onAggiorna();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipGruppo extends StatelessWidget {
  const _ChipGruppo({required this.testo});

  final String testo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colori.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colori.primary.withOpacity(0.25)),
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

/// ----------------------
/// MODEL EDITOR
/// ----------------------

class ElementoSchedaModificabile {
  ElementoSchedaModificabile({
    required this.esercizio,
    required this.serie,
    required this.ripetizioni,
    required this.tipoRipetizioni,
    this.ripetizioniPiramidali,
    required this.sezione,
    required this.ordineSezione,
    required this.ordineEsercizio,
    this.tipoGruppo,
    this.gruppoEtichetta,
    this.peso,
    this.durataMinuti,
    this.noteAllenatore,
  });

  final EserciziData esercizio;
  int serie;
  int ripetizioni;
  TipoRipetizioni tipoRipetizioni;
  String? ripetizioniPiramidali;
  double? peso;
  int? durataMinuti;
  String? noteAllenatore;

  String sezione;
  int ordineSezione;
  int ordineEsercizio;
  TipoGruppoAllenamento? tipoGruppo;
  String? gruppoEtichetta;
}

class _EsercizioSeed {
  const _EsercizioSeed({
    required this.nome,
    required this.descrizione,
    required this.muscoloObiettivo,
    required this.attrezzo,
    required this.gruppoMuscolare,
    required this.durataMinuti,
    required this.intensita,
    required this.obiettivi,
    required this.urlImmagine,
  });

  final String nome;
  final String descrizione;
  final String muscoloObiettivo;
  final Attrezzo attrezzo;
  final GruppoMuscolare gruppoMuscolare;
  final int durataMinuti;
  final String intensita;
  final String obiettivi;
  final String urlImmagine;

  EserciziCompanion toCompanion() => EserciziCompanion.insert(
        nome: nome,
        descrizione: Value(descrizione),
        muscoloObiettivo: Value(muscoloObiettivo),
        attrezzo: attrezzo,
        gruppoMuscolare: gruppoMuscolare,
        durataMinuti: Value(durataMinuti),
        intensita: Value(intensita),
        obiettivi: Value(obiettivi),
        urlImmagine: Value(urlImmagine),
      );
}

/// ----------------------
/// BOTTOM SHEET: AGGIUNGI ESERCIZIO (con sezione)
/// ----------------------

class _PannelloAggiungiEsercizio extends StatefulWidget {
  const _PannelloAggiungiEsercizio({
    required this.esercizi,
    required this.sezioniDisponibili,
    required this.onNuovaSezione,
  });

  final List<EserciziData> esercizi;
  final List<String> sezioniDisponibili;
  final Future<String?> Function() onNuovaSezione;

  @override
  State<_PannelloAggiungiEsercizio> createState() =>
      _PannelloAggiungiEsercizioState();
}

class _PannelloAggiungiEsercizioState extends State<_PannelloAggiungiEsercizio> {
  EserciziData? _selezionato;
  String? _sezione;
  int _serie = 3;
  int _ripetizioni = 10;
  TipoRipetizioni _tipoRipetizioni = TipoRipetizioni.classiche;
  String _ripetizioniPiramidali = '';
  String _ripetizioniSplit = '';
  String? _erroreRipetizioni;
  double? _peso;
  int? _durataMinuti;
  String _noteAllenatore = '';
  TipoGruppoAllenamento? _tipoGruppo;
  String _gruppoEtichetta = '';
  String _ricerca = '';

  @override
  void initState() {
    super.initState();
    if (widget.esercizi.isNotEmpty) _selezionato = widget.esercizi.first;
    _sezione = widget.sezioniDisponibili.isEmpty ? null : widget.sezioniDisponibili.first;
  }

  List<EserciziData> get _eserciziFiltrati {
    final query = _ricerca.trim().toLowerCase();
    if (query.isEmpty) return widget.esercizi;
    return widget.esercizi.where((e) {
      final testo = [
        e.nome,
        e.muscoloObiettivo ?? '',
        e.gruppoMuscolare.etichetta,
        e.attrezzo.etichetta,
      ].join(' ').toLowerCase();
      return testo.contains(query);
    }).toList();
  }

  String _metaEsercizio(EserciziData esercizio) {
    final parti = <String>[];
    if ((esercizio.muscoloObiettivo ?? '').trim().isNotEmpty) {
      parti.add(esercizio.muscoloObiettivo!.trim());
    } else {
      parti.add(esercizio.gruppoMuscolare.etichetta);
    }
    parti.add(esercizio.attrezzo.etichetta);
    return parti.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Cerca esercizio',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _ricerca = v),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 240,
                child: _eserciziFiltrati.isEmpty
                    ? Center(
                        child: Text(
                          'Nessun esercizio trovato',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                    : ListView.separated(
                        itemCount: _eserciziFiltrati.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final esercizio = _eserciziFiltrati[index];
                          final selezionato =
                              _selezionato?.id == esercizio.id;
                          return InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => setState(() => _selezionato = esercizio),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: selezionato
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.12)
                                    : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selezionato
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.12),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.fitness_center,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          esercizio.nome,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _metaEsercizio(esercizio),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.7),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selezionato)
                                    Icon(
                                      Icons.check_circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _sezione,
                isExpanded: true,
                items: widget.sezioniDisponibili
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _sezione = v),
                decoration: const InputDecoration(labelText: 'Sezione'),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () async {
                    final nuova = await widget.onNuovaSezione();
                    if (!mounted || nuova == null) return;
                    setState(() => _sezione = nuova);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Crea nuova sezione'),
                ),
              ),

              const SizedBox(height: 4),

              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    apriPagina(
                      context,
                      const PaginaEditorEsercizio(),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Crea nuovo esercizio'),
                ),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<TipoGruppoAllenamento?>(
                value: _tipoGruppo,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                    value: null,
                    child: Text('Nessun gruppo'),
                  ),
                  DropdownMenuItem(
                    value: TipoGruppoAllenamento.superset,
                    child: Text('Superset'),
                  ),
                  DropdownMenuItem(
                    value: TipoGruppoAllenamento.circuito,
                    child: Text('Circuito'),
                  ),
                ],
                onChanged: (v) => setState(() {
                  _tipoGruppo = v;
                  if (v == null) _gruppoEtichetta = '';
                }),
                decoration: const InputDecoration(
                  labelText: 'Gruppo',
                  helperText: 'Usa lo stesso gruppo per superset/circuiti',
                ),
              ),
              if (_tipoGruppo != null) ...[
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: _gruppoEtichetta,
                  decoration: const InputDecoration(
                    labelText: 'Etichetta gruppo (es. A, 1)',
                  ),
                  onChanged: (v) =>
                      setState(() => _gruppoEtichetta = v.trim()),
                ),
              ],

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _serie.toString(),
                      decoration: const InputDecoration(labelText: 'Serie'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) {
                        final x = int.tryParse(v);
                        if (x != null) {
                          setState(() {
                            _serie = x;
                            _erroreRipetizioni = null;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Peso'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (v) =>
                          setState(() => _peso = double.tryParse(v)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SegmentedButton<TipoRipetizioni>(
                segments: const [
                  ButtonSegment(
                    value: TipoRipetizioni.classiche,
                    label: Text('Classiche'),
                  ),
                  ButtonSegment(
                    value: TipoRipetizioni.piramidali,
                    label: Text('Piramidali'),
                  ),
                  ButtonSegment(
                    value: TipoRipetizioni.split,
                    label: Text('Split'),
                  ),
                ],
                selected: {_tipoRipetizioni},
                onSelectionChanged: (valori) {
                  setState(() {
                    _tipoRipetizioni = valori.first;
                    _erroreRipetizioni = null;
                    if (_tipoRipetizioni == TipoRipetizioni.piramidali) {
                      _ripetizioniSplit = '';
                    } else if (_tipoRipetizioni == TipoRipetizioni.split) {
                      _ripetizioniPiramidali = '';
                    }
                  });
                },
              ),

              const SizedBox(height: 10),

              if (_tipoRipetizioni == TipoRipetizioni.classiche)
                TextFormField(
                  initialValue: _ripetizioni.toString(),
                  decoration: const InputDecoration(labelText: 'Ripetizioni'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    final x = int.tryParse(v);
                    if (x != null) setState(() => _ripetizioni = x);
                  },
                )
              else if (_tipoRipetizioni == TipoRipetizioni.piramidali)
                TextFormField(
                  initialValue: _ripetizioniPiramidali,
                  decoration: InputDecoration(
                    labelText: 'Ripetizioni piramidali',
                    helperText:
                        'Inserisci $_serie valori (es. 10/8/6)',
                    errorText: _erroreRipetizioni,
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (v) => setState(() {
                    _ripetizioniPiramidali = v;
                    _erroreRipetizioni = null;
                  }),
                ),
              if (_tipoRipetizioni == TipoRipetizioni.split)
                TextFormField(
                  initialValue: _ripetizioniSplit,
                  decoration: InputDecoration(
                    labelText: 'Ripetizioni split',
                    helperText: 'Es. 10+10 (rest-pause/cluster)',
                    errorText: _erroreRipetizioni,
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (v) => setState(() {
                    _ripetizioniSplit = v;
                    _erroreRipetizioni = null;
                  }),
                ),

              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Note e durata (opzionali)',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                initialValue: _durataMinuti?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Durata (min)',
                  helperText: 'Lascia vuoto se non serve',
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => setState(() {
                  final pulito = v.trim();
                  if (pulito.isEmpty) {
                    _durataMinuti = null;
                    return;
                  }
                  final x = int.tryParse(pulito);
                  _durataMinuti = x != null && x > 0 ? x : null;
                }),
              ),

              const SizedBox(height: 12),

              TextFormField(
                initialValue: _noteAllenatore,
                decoration: const InputDecoration(
                  labelText: 'Note allenatore',
                  helperText: 'Opzionale (es. isometria 30s)',
                ),
                maxLines: 3,
                onChanged: (v) => setState(() => _noteAllenatore = v),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (_selezionato == null || _sezione == null)
                      ? null
                      : () {
                    final sezione = _sezione!;
                    if (_serie <= 0) {
                      setState(() => _erroreRipetizioni = 'Inserisci valori numerici positivi');
                      return;
                    }
                    if (_tipoRipetizioni == TipoRipetizioni.piramidali) {
                      final errore = _erroreRipetizioniPiramidali(
                        _ripetizioniPiramidali,
                        _serie,
                      );
                      if (errore != null) {
                        setState(() => _erroreRipetizioni = errore);
                        return;
                      }
                    }
                    if (_tipoRipetizioni == TipoRipetizioni.split) {
                      final errore =
                          _erroreRipetizioniSplit(_ripetizioniSplit);
                      if (errore != null) {
                        setState(() => _erroreRipetizioni = errore);
                        return;
                      }
                    }
                    Navigator.pop(
                      context,
                      ElementoSchedaModificabile(
                        esercizio: _selezionato!,
                        serie: _serie,
                        ripetizioni: _ripetizioni,
                        tipoRipetizioni: _tipoRipetizioni,
                        ripetizioniPiramidali:
                            _tipoRipetizioni == TipoRipetizioni.piramidali
                                ? _normalizzaRipetizioniPiramidali(
                                    _ripetizioniPiramidali,
                                  )
                                : _tipoRipetizioni == TipoRipetizioni.split
                                    ? _normalizzaRipetizioniSplit(
                                        _ripetizioniSplit,
                                      )
                                    : null,
                        peso: _peso,
                        durataMinuti: _durataMinuti,
                        noteAllenatore: _noteAllenatore.trim().isEmpty
                            ? null
                            : _noteAllenatore.trim(),
                        sezione: sezione,
                        ordineSezione: widget.sezioniDisponibili.indexOf(sezione),
                        ordineEsercizio: 0,
                        tipoGruppo: _tipoGruppo,
                        gruppoEtichetta:
                            _gruppoEtichetta.trim().isEmpty
                                ? null
                                : _gruppoEtichetta.trim(),
                      ),
                    );
                  },
                  child: const Text('Aggiungi esercizio'),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
