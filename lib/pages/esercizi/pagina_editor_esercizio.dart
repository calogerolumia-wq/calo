import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/archivio_locale.dart';
import '../../database/converter.dart';
import '../../utils/immagini_esercizi.dart';
import '../../stato/fornitori.dart';
import '../../utils/navigazione.dart';
import 'pagina_esercizi.dart';

class PaginaEditorEsercizio extends ConsumerStatefulWidget {
  const PaginaEditorEsercizio({super.key, this.esercizioId});

  final int? esercizioId;

  @override
  ConsumerState<PaginaEditorEsercizio> createState() =>
      _PaginaEditorEsercizioState();
}

class _PaginaEditorEsercizioState extends ConsumerState<PaginaEditorEsercizio> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descrizioneController = TextEditingController();
  final _muscoloController = TextEditingController();
  final _pesoController = TextEditingController();
  final _durataController = TextEditingController();
  final _recuperoController = TextEditingController();
  final _intensitaController = TextEditingController();
  final _obiettiviController = TextEditingController();
  final _selettoreImmagini = ImagePicker();

  Attrezzo _attrezzo = Attrezzo.corpoLibero;
  GruppoMuscolare _gruppo = GruppoMuscolare.pettorali;
  bool _caricamento = false;
  String? _percorsoImmagine;

  @override
  void initState() {
    super.initState();
    if (widget.esercizioId != null) {
      _caricamento = true;
      Future.microtask(_caricaEsercizio);
    }
  }

  Future<void> _caricaEsercizio() async {
    final archivio = ref.read(fornitoreArchivioLocale);
    final esercizio = await archivio.leggiEsercizio(widget.esercizioId!);
    if (!mounted) return;
    if (esercizio != null) {
      _nomeController.text = esercizio.nome;
      _descrizioneController.text = esercizio.descrizione ?? '';
      _muscoloController.text = esercizio.muscoloObiettivo ?? '';
      _pesoController.text = esercizio.pesoObiettivo?.toString() ?? '';
      _durataController.text = esercizio.durataMinuti?.toString() ?? '';
      _recuperoController.text = esercizio.recuperoSecondi?.toString() ?? '';
      _intensitaController.text = esercizio.intensita ?? '';
      _obiettiviController.text = esercizio.obiettivi ?? '';
      _percorsoImmagine = esercizio.urlImmagine;
      _attrezzo = esercizio.attrezzo;
      _gruppo = esercizio.gruppoMuscolare;
    }
    setState(() => _caricamento = false);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descrizioneController.dispose();
    _muscoloController.dispose();
    _pesoController.dispose();
    _durataController.dispose();
    _recuperoController.dispose();
    _intensitaController.dispose();
    _obiettiviController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titolo = widget.esercizioId == null
        ? 'Nuovo esercizio'
        : 'Modifica esercizio';
    return Scaffold(
      appBar: AppBar(title: Text(titolo)),
      body: _caricamento
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (valore) => valore == null || valore.isEmpty
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
                    controller: _muscoloController,
                    decoration: const InputDecoration(labelText: 'Muscolo target'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Attrezzo>(
                    value: _attrezzo,
                    decoration: const InputDecoration(labelText: 'Attrezzo'),
                    items: Attrezzo.values
                        .map(
                          (attrezzo) => DropdownMenuItem(
                            value: attrezzo,
                            child: Text(attrezzo.etichetta),
                          ),
                        )
                        .toList(),
                    onChanged: (valore) {
                      if (valore != null) setState(() => _attrezzo = valore);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<GruppoMuscolare>(
                    value: _gruppo,
                    decoration:
                        const InputDecoration(labelText: 'Gruppo muscolare'),
                    items: GruppoMuscolare.values
                        .map(
                          (gruppo) => DropdownMenuItem(
                            value: gruppo,
                            child: Text(gruppo.etichetta),
                          ),
                        )
                        .toList(),
                    onChanged: (valore) {
                      if (valore != null) setState(() => _gruppo = valore);
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _pesoController,
                          decoration:
                              const InputDecoration(labelText: 'Peso target'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _durataController,
                          decoration:
                              const InputDecoration(labelText: 'Durata (min)'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _recuperoController,
                    decoration: const InputDecoration(
                      labelText: 'Recupero consigliato (sec)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _intensitaController,
                    decoration: const InputDecoration(labelText: 'Intensità'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _obiettiviController,
                    decoration: const InputDecoration(labelText: 'Obiettivi'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _SezioneImmagineEsercizio(
                    percorsoImmagine: _percorsoImmagine,
                    nomeEsercizio: _nomeController.text,
                    onSelezionaGalleria: _selezionaImmagineDaGalleria,
                    onScattaFoto: _scattaFoto,
                    onRimuovi: _rimuoviImmagine,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => _salvaEsercizio(context),
                    child: const Text('Salva esercizio'),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _salvaEsercizio(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final archivio = ref.read(fornitoreArchivioLocale);
    final peso = double.tryParse(_pesoController.text);
    final durata = int.tryParse(_durataController.text);
    final recupero = int.tryParse(_recuperoController.text);

    final EserciziCompanion dati;
    if (widget.esercizioId == null) {
      dati = EserciziCompanion.insert(
        nome: _nomeController.text,
        descrizione: Value(_descrizioneController.text.isEmpty
            ? null
            : _descrizioneController.text),
        muscoloObiettivo: Value(_muscoloController.text.isEmpty
            ? null
            : _muscoloController.text),
        attrezzo: _attrezzo,
        gruppoMuscolare: _gruppo,
        pesoObiettivo: Value(peso),
        durataMinuti: Value(durata),
        recuperoSecondi: Value(recupero),
        intensita: Value(_intensitaController.text.isEmpty
            ? null
            : _intensitaController.text),
        obiettivi: Value(_obiettiviController.text.isEmpty
            ? null
            : _obiettiviController.text),
      urlImmagine: Value(_percorsoImmagine?.isEmpty ?? true
          ? null
          : _percorsoImmagine),
    );
    } else {
      dati = EserciziCompanion(
        id: Value(widget.esercizioId!),
        nome: Value(_nomeController.text),
        descrizione: Value(_descrizioneController.text.isEmpty
            ? null
            : _descrizioneController.text),
        muscoloObiettivo: Value(_muscoloController.text.isEmpty
            ? null
            : _muscoloController.text),
        attrezzo: Value(_attrezzo),
        gruppoMuscolare: Value(_gruppo),
        pesoObiettivo: Value(peso),
        durataMinuti: Value(durata),
        recuperoSecondi: Value(recupero),
        intensita: Value(_intensitaController.text.isEmpty
            ? null
            : _intensitaController.text),
        obiettivi: Value(_obiettiviController.text.isEmpty
            ? null
            : _obiettiviController.text),
        urlImmagine: Value(_percorsoImmagine?.isEmpty ?? true
            ? null
            : _percorsoImmagine),
      );
    }

    if (widget.esercizioId == null) {
      await archivio.creaEsercizio(dati);
    } else {
      await archivio.aggiornaEsercizio(dati);
    }

    if (context.mounted) {
      vaiAllaPaginaPrincipale(
        context,
        const PaginaEsercizi(),
      );
    }
  }

  Future<void> _selezionaImmagineDaGalleria() async {
    await _selezionaImmagine(ImageSource.gallery);
  }

  Future<void> _scattaFoto() async {
    await _selezionaImmagine(ImageSource.camera);
  }

  Future<void> _selezionaImmagine(ImageSource sorgente) async {
    final immagineSelezionata = await _selettoreImmagini.pickImage(
      source: sorgente,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (immagineSelezionata == null) return;

    final percorsoLocale = await _copiaInArchivioLocale(immagineSelezionata);
    if (!mounted) return;
    setState(() => _percorsoImmagine = percorsoLocale.path);
  }

  Future<File> _copiaInArchivioLocale(XFile immagine) async {
    final cartellaDocumenti = await getApplicationDocumentsDirectory();
    final cartellaEsercizi =
        Directory(p.join(cartellaDocumenti.path, 'esercizi'));
    if (!await cartellaEsercizi.exists()) {
      await cartellaEsercizi.create(recursive: true);
    }
    final estensione = p.extension(immagine.path);
    final nomeFile =
        'esercizio_${DateTime.now().millisecondsSinceEpoch}$estensione';
    final destinazione = p.join(cartellaEsercizi.path, nomeFile);
    return File(immagine.path).copy(destinazione);
  }

  void _rimuoviImmagine() {
    setState(() => _percorsoImmagine = null);
  }
}

class _SezioneImmagineEsercizio extends StatelessWidget {
  const _SezioneImmagineEsercizio({
    required this.percorsoImmagine,
    required this.nomeEsercizio,
    required this.onSelezionaGalleria,
    required this.onScattaFoto,
    required this.onRimuovi,
  });

  final String? percorsoImmagine;
  final String nomeEsercizio;
  final VoidCallback onSelezionaGalleria;
  final VoidCallback onScattaFoto;
  final VoidCallback onRimuovi;

  @override
  Widget build(BuildContext context) {
    final percorsoAsset =
        mappaImmaginiEsercizi[nomeEsercizio] ?? immagineEsercizioPlaceholder;
    final percorso = percorsoImmagine ?? percorsoAsset;
    final usaAsset = immagineEAsset(percorso);
    Widget fallback() => Container(
          height: 160,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.image, size: 48),
        );
    final immagine = usaAsset
        ? Image.asset(
            percorso,
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => fallback(),
          )
        : Image.file(
            File(percorso),
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => fallback(),
          );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Immagine esercizio',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: immagine,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onSelezionaGalleria,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Galleria'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onScattaFoto,
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text('Scatta'),
                  ),
                ),
              ],
            ),
            if (percorsoImmagine != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: onRimuovi,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Rimuovi immagine'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
