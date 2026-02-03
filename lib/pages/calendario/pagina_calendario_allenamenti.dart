import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../database/archivio_locale.dart';
import '../../stato/fornitori.dart';

class PaginaCalendarioAllenamenti extends ConsumerStatefulWidget {
  const PaginaCalendarioAllenamenti({super.key});

  @override
  ConsumerState<PaginaCalendarioAllenamenti> createState() =>
      _PaginaCalendarioAllenamentiState();
}

class _PaginaCalendarioAllenamentiState
    extends ConsumerState<PaginaCalendarioAllenamenti> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  DateTime _soloData(DateTime data) => DateTime(data.year, data.month, data.day);

  @override
  Widget build(BuildContext context) {
    final archivio = ref.watch(fornitoreArchivioLocale);
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario allenamenti'),
      ),
      body: StreamBuilder<List<SessioneCalendario>>(
        stream: archivio.guardaSessioniCompletate(idUtenteDemo),
        builder: (context, snapshot) {
          final sessioni = snapshot.data ?? [];
          final eventi = <DateTime, List<SessioneCalendario>>{};

          for (final elemento in sessioni) {
            final riferimento = elemento.sessione.fine ?? elemento.sessione.inizio;
            final giorno = _soloData(riferimento);
            final lista = eventi.putIfAbsent(giorno, () => []);
            lista.add(elemento);
          }

          final giornoSelezionato = _soloData(_selectedDay);
          final eventiGiorno = eventi[giornoSelezionato] ?? [];

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colori.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colori.primary.withOpacity(0.2)),
                ),
                child: TableCalendar<SessioneCalendario>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2035, 12, 31),
                  focusedDay: _focusedDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  eventLoader: (day) => eventi[_soloData(day)] ?? [],
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: colori.primary.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: colori.primary,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: colori.primary,
                      shape: BoxShape.circle,
                    ),
                    markersMaxCount: 3,
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: colori.primary),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: colori.primary),
                    titleTextStyle: tema.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colori.primary,
                        ) ??
                        const TextStyle(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Sessioni del giorno',
                      style: tema.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    _formattaDataBreve(giornoSelezionato),
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: colori.primary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (eventiGiorno.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colori.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colori.primary.withOpacity(0.2)),
                  ),
                  child: Text(
                    'Nessuna sessione completata in questo giorno.',
                    style: tema.textTheme.bodyMedium?.copyWith(
                      color: colori.primary.withOpacity(0.7),
                    ),
                  ),
                )
              else
                for (final evento in eventiGiorno)
                  _CardSessioneCalendario(
                    evento: evento,
                    archivio: archivio,
                  ),
            ],
          );
        },
      ),
    );
  }

  String _formattaDataBreve(DateTime data) {
    final giorno = data.day.toString().padLeft(2, '0');
    final mese = data.month.toString().padLeft(2, '0');
    return '$giorno/$mese/${data.year}';
  }
}

class _CardSessioneCalendario extends StatelessWidget {
  const _CardSessioneCalendario({
    required this.evento,
    required this.archivio,
  });

  final SessioneCalendario evento;
  final ArchivioLocale archivio;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;
    final sessione = evento.sessione;
    final inizio = sessione.inizio;
    final fine = sessione.fine ?? sessione.inizio;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colori.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colori.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: StreamBuilder<List<SerieRegistrataConEsercizio>>(
        stream: archivio.guardaSerieSessione(sessione.id),
        builder: (context, snapshot) {
          final serie = snapshot.data ?? [];
          final raggruppate = _raggruppaSerie(serie);
          final totaleSet = serie.length;
          final totaleEsercizi = raggruppate.length;

          return Theme(
            data: tema.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(top: 8),
              title: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colori.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.fitness_center, color: colori.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          evento.nomeScheda,
                          style: tema.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_formattaOrario(inizio)} - ${_formattaOrario(fine)}',
                          style: tema.textTheme.bodySmall?.copyWith(
                            color: colori.primary.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$totaleSet set • $totaleEsercizi esercizi',
                          style: tema.textTheme.bodySmall?.copyWith(
                            color: colori.primary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              children: [
                if (serie.isEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nessun set registrato.',
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: colori.primary.withOpacity(0.7),
                      ),
                    ),
                  )
                else
                  for (final gruppo in raggruppate)
                    _DettaglioEsercizio(
                      esercizio: gruppo.esercizio,
                      serie: gruppo.serie,
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formattaOrario(DateTime data) {
    final ore = data.hour.toString().padLeft(2, '0');
    final minuti = data.minute.toString().padLeft(2, '0');
    return '$ore:$minuti';
  }
}

class _DettaglioEsercizio extends StatelessWidget {
  const _DettaglioEsercizio({
    required this.esercizio,
    required this.serie,
  });

  final EserciziData esercizio;
  final List<SerieRegistrateData> serie;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colori = tema.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            esercizio.nome,
            style: tema.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: serie
                .map(
                  (record) => _ChipSerieCalendario(
                    testo: _testoSerie(record),
                    colore: colori.primary,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  String _testoSerie(SerieRegistrateData record) {
    final peso = record.peso == null ? null : '${record.peso} kg';
    final rpe = record.rpe == null ? null : 'RPE ${record.rpe}';
    final tempo = record.secondiTempo == null
        ? null
        : '${record.secondiTempo}s';
    final parti = <String>[
      'S${record.indiceSerie}',
      '${record.ripetizioni} rep',
      if (peso != null) peso,
      if (rpe != null) rpe,
      if (tempo != null) tempo,
    ];
    return parti.join(' • ');
  }
}

class _ChipSerieCalendario extends StatelessWidget {
  const _ChipSerieCalendario({
    required this.testo,
    required this.colore,
  });

  final String testo;
  final Color colore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colore.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colore.withOpacity(0.25)),
      ),
      child: Text(
        testo,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colore,
            ),
      ),
    );
  }
}

class _GruppoSerieEsercizio {
  _GruppoSerieEsercizio(this.esercizio);

  final EserciziData esercizio;
  final List<SerieRegistrateData> serie = [];
}

List<_GruppoSerieEsercizio> _raggruppaSerie(
  List<SerieRegistrataConEsercizio> serie,
) {
  final mappa = <int, _GruppoSerieEsercizio>{};
  for (final record in serie) {
    final id = record.esercizio.id;
    final gruppo = mappa.putIfAbsent(
      id,
      () => _GruppoSerieEsercizio(record.esercizio),
    );
    gruppo.serie.add(record.serie);
  }
  final lista = mappa.values.toList()
    ..sort((a, b) => a.esercizio.nome.compareTo(b.esercizio.nome));
  return lista;
}
