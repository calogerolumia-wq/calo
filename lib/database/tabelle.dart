import 'package:drift/drift.dart';

import 'converter.dart';

class Utenti extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get email => text().nullable()();
  TextColumn get username => text().nullable()();
}

class Esercizi extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get descrizione => text().nullable()();
  TextColumn get muscoloObiettivo => text().named('muscoloTarget').nullable()();
  TextColumn get attrezzo => text().map(const AttrezzoConverter())();
  TextColumn get gruppoMuscolare => text().map(const GruppoMuscolareConverter())();
  RealColumn get pesoObiettivo => real().named('pesoTarget').nullable()();
  IntColumn get durataMinuti => integer().nullable()();
  TextColumn get intensita => text().nullable()();
  TextColumn get obiettivi => text().nullable()();
  TextColumn get urlImmagine => text().named('immagineUrl').nullable()();
  IntColumn get recuperoSecondi =>
      integer().named('recuperoSec').nullable()();

  List<Index> get indexes => [
        Index('idx_esercizi_nome', 'nome'),
        Index('idx_esercizi_gruppo', 'gruppo_muscolare'),
        Index('idx_esercizi_attrezzo', 'attrezzo'),
      ];
}

class Schede extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nomeScheda => text()();
  TextColumn get descrizione => text().nullable()();
  TextColumn get livelloDifficolta => text().nullable()();
  IntColumn get utenteId => integer().references(Utenti, #id)();
  BoolColumn get modello => boolean().named('template').withDefault(const Constant(false))();
  BoolColumn get attiva => boolean().withDefault(const Constant(true))();
  DateTimeColumn get dataAssegnazione => dateTime().nullable()();
  DateTimeColumn get dataFine => dateTime().nullable()();
  TextColumn get noteAllenatore => text().nullable()();

  List<Index> get indexes => [
        Index('idx_schede_utente', 'utente_id'),
        Index('idx_schede_attiva', 'attiva'),
      ];
}

class SchedeEsercizi extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get schedaId => integer().references(Schede, #id)();
  IntColumn get esercizioId => integer().references(Esercizi, #id)();

  // NUOVI CAMPI: per A/B/C (o Lunedì/Mercoledì/Venerdì)
  TextColumn get sezione => text().withDefault(const Constant('Allenamento'))();
  IntColumn get ordineSezione =>
      integer().withDefault(const Constant(0))(); // 0=A, 1=B, 2=C
  IntColumn get ordineEsercizio =>
      integer().withDefault(const Constant(0))(); // ordine dentro la sezione

  IntColumn get serie => integer().withDefault(const Constant(3))();
  IntColumn get ripetizioni => integer().withDefault(const Constant(10))();
  TextColumn get ripetizioniPiramidali =>
      text().named('repsPyramid').nullable()();
  RealColumn get peso => real().nullable()();
  IntColumn get durataMinuti => integer().nullable()();
  TextColumn get noteAllenatore => text().nullable()();

  List<Index> get indexes => [
    Index('idx_schede_esercizi_scheda', 'scheda_id'),
    Index('idx_schede_esercizi_esercizio', 'esercizio_id'),

    // NUOVO INDICE: lista ordinata e raggruppata per sezione
    Index(
      'idx_schede_esercizi_sezione_ordine',
      'scheda_id, ordine_sezione, ordine_esercizio',
    ),
  ];
}


class SessioniAllenamento extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get schedaId => integer().nullable().references(Schede, #id)();
  IntColumn get utenteId => integer().references(Utenti, #id)();
  DateTimeColumn get inizio => dateTime().named('startTime')();
  DateTimeColumn get fine => dateTime().named('endTime').nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get completata => boolean().withDefault(const Constant(false))();
  BoolColumn get sincronizzata => boolean().withDefault(const Constant(false))();

  List<Index> get indexes => [
        Index('idx_sessioni_utente', 'utente_id'),
        Index('idx_sessioni_completata', 'completata'),
      ];
}

class SerieRegistrate extends Table {
  @override
  String get tableName => 'recordSet';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessioneId => integer().references(SessioniAllenamento, #id)();
  IntColumn get esercizioId => integer().references(Esercizi, #id)();
  IntColumn get indiceSerie => integer().named('serieIndex')();
  IntColumn get ripetizioni => integer()();
  TextColumn get ripetizioniTesto => text().nullable()();
  RealColumn get peso => real().nullable()();
  RealColumn get rpe => real().nullable()();
  IntColumn get secondiTempo => integer().named('tempoSec').nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get dataOra =>
      dateTime().named('timestamp').withDefault(currentDateAndTime)();

  List<Index> get indexes => [
        Index('idx_record_set_sessione', 'sessione_id'),
        Index('idx_record_set_esercizio', 'esercizio_id'),
      ];
}

class Misurazioni extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get utenteId => integer().references(Utenti, #id)();
  RealColumn get peso => real()();
  RealColumn get percentualeMassaGrassa => real().named('bodyFatPercent').nullable()();
  RealColumn get petto => real().nullable()();
  RealColumn get vita => real().nullable()();
  RealColumn get coscia => real().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get data => dateTime()();

  List<Index> get indexes => [
        Index('idx_misure_utente', 'utente_id'),
        Index('idx_misure_data', 'data'),
      ];
}

class Impostazioni extends Table {
  TextColumn get chiave => text()();
  TextColumn get valore => text()();

  @override
  Set<Column> get primaryKey => {chiave};
}

class CredenzialeSalvate extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text()();
  TextColumn get password => text()();
  TextColumn get nomeVisualizzato => text().nullable()();
  IntColumn get aziendaId => integer().nullable()();
  TextColumn get codiceAzienda => text().nullable()();
  DateTimeColumn get ultimoUso =>
      dateTime().withDefault(currentDateAndTime)();
}
