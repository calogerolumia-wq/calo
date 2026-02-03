import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/archivio_locale.dart';
import '../../stato/fornitori.dart';
import '../../utils/navigazione.dart';
import 'pagina_misure.dart';

class PaginaEditorMisura extends ConsumerStatefulWidget {
  const PaginaEditorMisura({super.key});

  @override
  ConsumerState<PaginaEditorMisura> createState() => _PaginaEditorMisuraState();
}

class _PaginaEditorMisuraState extends ConsumerState<PaginaEditorMisura> {
  final _formKey = GlobalKey<FormState>();
  final _pesoController = TextEditingController();
  final _massaGrassaController = TextEditingController();
  final _pettoController = TextEditingController();
  final _vitaController = TextEditingController();
  final _cosciaController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _data = DateTime.now();

  @override
  void dispose() {
    _pesoController.dispose();
    _massaGrassaController.dispose();
    _pettoController.dispose();
    _vitaController.dispose();
    _cosciaController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuova misura')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            TextFormField(
              controller: _pesoController,
              decoration: const InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: TextInputType.number,
              validator: (valore) => valore == null || valore.isEmpty
                  ? 'Inserisci il peso'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _massaGrassaController,
              decoration:
                  const InputDecoration(labelText: 'Massa grassa (%)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _pettoController,
                    decoration: const InputDecoration(labelText: 'Petto (cm)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _vitaController,
                    decoration: const InputDecoration(labelText: 'Vita (cm)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cosciaController,
              decoration: const InputDecoration(labelText: 'Coscia (cm)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Note'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data'),
              subtitle: Text(_formattaData(_data)),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today_outlined),
                onPressed: _selezionaData,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => _salvaMisura(context),
              child: const Text('Salva misura'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selezionaData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (data != null) {
      setState(() => _data = data);
    }
  }

  Future<void> _salvaMisura(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final archivio = ref.read(fornitoreArchivioLocale);
    final peso = double.tryParse(_pesoController.text);
    if (peso == null) return;

    final misura = MisurazioniCompanion.insert(
      utenteId: idUtenteDemo,
      peso: peso,
      percentualeMassaGrassa:
          Value(double.tryParse(_massaGrassaController.text)),
      petto: Value(double.tryParse(_pettoController.text)),
      vita: Value(double.tryParse(_vitaController.text)),
      coscia: Value(double.tryParse(_cosciaController.text)),
      note: Value(_noteController.text.isEmpty ? null : _noteController.text),
      data: _data,
    );

    await archivio.creaMisura(misura);
    if (context.mounted) {
      vaiAllaPaginaPrincipale(
        context,
        const PaginaMisure(),
      );
    }
  }

  String _formattaData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}
