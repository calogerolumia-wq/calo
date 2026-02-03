import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../stato/fornitori.dart';

class Impostazioni extends ConsumerStatefulWidget {
  const Impostazioni({super.key});

  @override
  ConsumerState<Impostazioni> createState() =>
      _impostazioniState();
}

class _impostazioniState extends ConsumerState<Impostazioni> {
  double _recuperoSecondi = 90;
  bool _vibrazioneRecupero = true;
  bool _beepRecupero = false;
  bool _memorizzaPesi = false;
  bool _inizializzato = false;

  @override
  Widget build(BuildContext context) {
    final recuperoAsync = ref.watch(fornitoreRecuperoSecondi);
    final vibrazioneAsync = ref.watch(fornitoreVibrazioneRecupero);
    final beepAsync = ref.watch(fornitoreBeepRecupero);
    final memoriaPesiAsync = ref.watch(fornitoreMemoriaPesi);
    if (!_inizializzato) {
      final recupero = recuperoAsync.asData?.value;
      final vibrazione = vibrazioneAsync.asData?.value;
      final beep = beepAsync.asData?.value;
      final memoriaPesi = memoriaPesiAsync.asData?.value;
      if (recupero != null &&
          vibrazione != null &&
          beep != null &&
          memoriaPesi != null) {
        _recuperoSecondi = recupero.toDouble();
        _vibrazioneRecupero = vibrazione;
        _beepRecupero = beep;
        _memorizzaPesi = memoriaPesi;
        _inizializzato = true;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Impostazioni')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Timer recupero',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Durata predefinita: ${_recuperoSecondi.round()} s',
                  ),
                  Slider(
                    value: _recuperoSecondi,
                    min: 30,
                    max: 180,
                    divisions: 30,
                    label: '${_recuperoSecondi.round()} s',
                    onChanged: (valore) {
                      setState(() => _recuperoSecondi = valore);
                    },
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Vibrazione a 10s e fine recupero'),
                    value: _vibrazioneRecupero,
                    onChanged: (valore) =>
                        setState(() => _vibrazioneRecupero = valore),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Beep a fine recupero'),
                    value: _beepRecupero,
                    onChanged: (valore) =>
                        setState(() => _beepRecupero = valore),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Memorizza ultimi pesi'),
                    value: _memorizzaPesi,
                    onChanged: (valore) =>
                        setState(() => _memorizzaPesi = valore),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () async {
                      final archivio = ref.read(fornitoreArchivioLocale);
                      await archivio
                          .salvaRecuperoSecondi(_recuperoSecondi.round());
                      await archivio
                          .salvaVibrazioneRecupero(_vibrazioneRecupero);
                      await archivio.salvaBeepRecupero(_beepRecupero);
                      await archivio.salvaMemorizzaUltimiPesi(_memorizzaPesi);
                      ref.invalidate(fornitoreRecuperoSecondi);
                      ref.invalidate(fornitoreVibrazioneRecupero);
                      ref.invalidate(fornitoreBeepRecupero);
                      ref.invalidate(fornitoreMemoriaPesi);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Impostazioni salvate')),
                        );
                      }
                    },
                    child: const Text('Salva preferenza'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
