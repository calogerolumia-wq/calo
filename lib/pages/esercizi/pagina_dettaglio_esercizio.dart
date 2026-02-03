import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/archivio_locale.dart';
import '../../database/converter.dart';
import '../../utils/immagini_esercizi.dart';
import '../../stato/fornitori.dart';
import '../../utils/navigazione.dart';
import 'pagina_editor_esercizio.dart';
import 'pagina_esercizi.dart';

class PaginaDettaglioEsercizio extends ConsumerWidget {
  const PaginaDettaglioEsercizio({super.key, required this.esercizioId});

  final int esercizioId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivio = ref.watch(fornitoreArchivioLocale);
    return FutureBuilder<EserciziData?>(
      future: archivio.leggiEsercizio(esercizioId),
      builder: (context, snapshot) {
        final esercizio = snapshot.data;
        if (esercizio == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(esercizio.nome),
            actions: [
              IconButton(
                onPressed: () => apriPagina(
                  context,
                  PaginaEditorEsercizio(esercizioId: esercizio.id),
                ),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () => _confermaEliminazione(context, ref),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (context) {
                          final percorsoImmagine =
                              percorsoImmagineEsercizio(esercizio);
                          Widget fallback() => Container(
                                height: 180,
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                child: const Icon(Icons.image, size: 48),
                              );
                          final immagine = immagineEAsset(percorsoImmagine)
                              ? Image.asset(
                                  percorsoImmagine,
                                  width: double.infinity,
                                  height: 350,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stack) => fallback(),
                                )
                              : Image.file(
                                  File(percorsoImmagine),
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stack) => fallback(),
                                );
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: immagine,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        esercizio.nome,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        esercizio.descrizione ?? 'Descrizione non disponibile',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _EtichettaInfo(
                            icona: Icons.fitness_center,
                            testo: esercizio.attrezzo.etichetta,
                          ),
                          _EtichettaInfo(
                            icona: Icons.shield,
                            testo: esercizio.gruppoMuscolare.etichetta,
                          ),
                          if (esercizio.pesoObiettivo != null)
                            _EtichettaInfo(
                              icona: Icons.scale,
                              testo: '${esercizio.pesoObiettivo} kg',
                            ),
                          if (esercizio.durataMinuti != null)
                            _EtichettaInfo(
                              icona: Icons.timer,
                              testo: '${esercizio.durataMinuti} min',
                            ),
                          if ((esercizio.intensita ?? '').isNotEmpty)
                            _EtichettaInfo(
                              icona: Icons.bolt,
                              testo: esercizio.intensita!,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if ((esercizio.obiettivi ?? '').isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Obiettivi',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(esercizio.obiettivi!),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confermaEliminazione(BuildContext context, WidgetRef ref) async {
    final conferma = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminare esercizio?'),
        content: const Text('L\'esercizio verrà rimosso dalle schede.'),
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

    if (conferma == true) {
      final archivio = ref.read(fornitoreArchivioLocale);
      await archivio.eliminaEsercizio(esercizioId);
      if (context.mounted) {
        vaiAllaPaginaPrincipale(
          context,
          const PaginaEsercizi(),
        );
      }
    }
  }
}

class _EtichettaInfo extends StatelessWidget {
  const _EtichettaInfo({required this.icona, required this.testo});

  final IconData icona;
  final String testo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icona, size: 16),
          const SizedBox(width: 6),
          Text(testo),
        ],
      ),
    );
  }
}
