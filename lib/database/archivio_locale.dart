import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/scheda_remota.dart';
import 'converter.dart';
import 'tabelle.dart';

part 'archivio_locale.g.dart';

class EsercizioInScheda {
  EsercizioInScheda({
    required this.esercizio,
    required this.serie,
    required this.ripetizioni,
    this.ripetizioniPiramidali,
    required this.sezione,
    required this.ordineSezione,
    required this.ordineEsercizio,
    this.peso,
    this.durataMinuti,
    this.noteAllenatore,
  });

  final EserciziData esercizio;
  final int serie;
  final int ripetizioni;
  final String? ripetizioniPiramidali;
  final double? peso;
  final int? durataMinuti;
  final String? noteAllenatore;

  final String sezione;
  final int ordineSezione;
  final int ordineEsercizio;
}

class SessioneCalendario {
  const SessioneCalendario({
    required this.sessione,
    required this.nomeScheda,
  });

  final SessioniAllenamentoData sessione;
  final String nomeScheda;
}

class SerieRegistrataConEsercizio {
  const SerieRegistrataConEsercizio({
    required this.serie,
    required this.esercizio,
  });

  final SerieRegistrateData serie;
  final EserciziData esercizio;
}

class SessioneAuth {
  const SessioneAuth({
    required this.utenteId,
    required this.token,
  });

  final int utenteId;
  final String token;
}


class ElementoSchedaIngresso {
  const ElementoSchedaIngresso({
    required this.esercizioId,
    required this.serie,
    required this.ripetizioni,
    this.ripetizioniPiramidali,
    required this.sezione,
    required this.ordineSezione,
    required this.ordineEsercizio,
    this.peso,
    this.durataMinuti,
    this.noteAllenatore,
  });

  final int esercizioId;
  final int serie;
  final int ripetizioni;
  final String? ripetizioniPiramidali;
  final double? peso;
  final int? durataMinuti;
  final String? noteAllenatore;

  final String sezione;
  final int ordineSezione;
  final int ordineEsercizio;
}


LazyDatabase _apriConnessione() {
  return LazyDatabase(() async {
    final cartella = await getApplicationDocumentsDirectory();
    final file = File(p.join(cartella.path, 'fitness.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(
  tables: [
    Utenti,
    Esercizi,
    Schede,
    SchedeEsercizi,
    SessioniAllenamento,
    SerieRegistrate,
    Misurazioni,
    Impostazioni,
  ],
)
class ArchivioLocale extends _$ArchivioLocale {
  ArchivioLocale() : super(_apriConnessione());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(esercizi, esercizi.recuperoSecondi);
          }
          if (from < 3) {
            await m.addColumn(schedeEsercizi, schedeEsercizi.ripetizioniPiramidali);
          }
          if (from < 4) {
            await m.addColumn(schedeEsercizi, schedeEsercizi.durataMinuti);
            await m.addColumn(schedeEsercizi, schedeEsercizi.noteAllenatore);
          }
        },
      );

  Future<void> inizializzaDatiDemo() async {
    final utenteEsistente = await (select(utenti)..limit(1)).getSingleOrNull();
    if (utenteEsistente != null) {
      await _assicuraImpostazioniBase();
      return;
    }

    await transaction(() async {
      await into(utenti).insert(
        const UtentiCompanion(
          id: Value(1),
          nome: Value('Luca Ferri'),
          email: Value('luca@demo.it'),
        ),
      );

      final esercizioSpinta = await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Panca piana',
          descrizione: const Value('Spinta con bilanciere su panca'),
          muscoloObiettivo: const Value('Pettorali'),
          attrezzo: Attrezzo.bilanciere,
          gruppoMuscolare: GruppoMuscolare.pettorali,
          pesoObiettivo: const Value(60),
          durataMinuti: const Value(8),
          recuperoSecondi: const Value(120),
          intensita: const Value('Media'),
          obiettivi: const Value('Forza'),
        ),
      );

      final esercizioTrazioni = await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Trazioni alla sbarra',
          descrizione: const Value('Presa prona, schiena attiva'),
          muscoloObiettivo: const Value('Dorsali'),
          attrezzo: Attrezzo.corpoLibero,
          gruppoMuscolare: GruppoMuscolare.dorsali,
          pesoObiettivo: const Value(0),
          durataMinuti: const Value(6),
          recuperoSecondi: const Value(120),
          intensita: const Value('Alta'),
          obiettivi: const Value('Resistenza'),
        ),
      );

      final esercizioSquat = await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Squat',
          descrizione: const Value('Squat con bilanciere'),
          muscoloObiettivo: const Value('Quadricipiti'),
          attrezzo: Attrezzo.bilanciere,
          gruppoMuscolare: GruppoMuscolare.quadricipiti,
          pesoObiettivo: const Value(80),
          durataMinuti: const Value(10),
          recuperoSecondi: const Value(150),
          intensita: const Value('Alta'),
          obiettivi: const Value('Forza'),
        ),
      );

      await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Curl manubri',
          descrizione: const Value('Curl alternato con manubri'),
          muscoloObiettivo: const Value('Bicipiti'),
          attrezzo: Attrezzo.manubri,
          gruppoMuscolare: GruppoMuscolare.bicipiti,
          pesoObiettivo: const Value(14),
          durataMinuti: const Value(5),
          recuperoSecondi: const Value(75),
          intensita: const Value('Media'),
          obiettivi: const Value('Ipertrofia'),
        ),
      );

      final esercizioCore = await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Plank',
          descrizione: const Value('Tenuta isometrica in plank'),
          muscoloObiettivo: const Value('Core'),
          attrezzo: Attrezzo.corpoLibero,
          gruppoMuscolare: GruppoMuscolare.addominali,
          durataMinuti: const Value(4),
          recuperoSecondi: const Value(60),
          intensita: const Value('Media'),
          obiettivi: const Value('Stabilità'),
        ),
      );

      await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Alzate laterali manubri seduto',
          descrizione: const Value('Alzate laterali seduto con manubri'),
          muscoloObiettivo: const Value('Deltoidi laterali'),
          attrezzo: Attrezzo.manubri,
          gruppoMuscolare: GruppoMuscolare.spalle,
          durataMinuti: const Value(4),
          intensita: const Value('Media'),
          obiettivi: const Value('Ipertrofia'),
          urlImmagine:
              const Value('assets/esercizi/alzate-laterali-manubri-seduto.png'),
        ),
      );

      await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Alzate laterali singolo cavo',
          descrizione: const Value('Alzate laterali al cavo, un braccio alla volta'),
          muscoloObiettivo: const Value('Spalle'),
          attrezzo: Attrezzo.cavo,
          gruppoMuscolare: GruppoMuscolare.spalle,
          durataMinuti: const Value(4),
          intensita: const Value('Media'),
          obiettivi: const Value('Ipertrofia'),
          urlImmagine:
              const Value('assets/esercizi/alzate-laterali-singolo-cavo.png'),
        ),
      );

      await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Calf machine',
          descrizione: const Value('Calf raise alla macchina'),
          muscoloObiettivo: const Value('Polpacci'),
          attrezzo: Attrezzo.macchina,
          gruppoMuscolare: GruppoMuscolare.polpacci,
          durataMinuti: const Value(4),
          intensita: const Value('Media'),
          obiettivi: const Value('Forza'),
          urlImmagine: const Value('assets/esercizi/calf-machine.png'),
        ),
      );

      await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Chiusure cavi alti',
          descrizione: const Value('Chiusure ai cavi alti in piedi'),
          muscoloObiettivo: const Value('Pettorali superiori'),
          attrezzo: Attrezzo.cavo,
          gruppoMuscolare: GruppoMuscolare.pettorali,
          durataMinuti: const Value(5),
          intensita: const Value('Media'),
          obiettivi: const Value('Ipertrofia'),
          urlImmagine: const Value('assets/esercizi/chiusure-cavi-alti.png'),
        ),
      );

      await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Crossover cavi alti',
          descrizione: const Value('Crossover ai cavi alti, traiettoria controllata'),
          muscoloObiettivo: const Value('Pettorali'),
          attrezzo: Attrezzo.cavo,
          gruppoMuscolare: GruppoMuscolare.pettorali,
          durataMinuti: const Value(5),
          intensita: const Value('Media'),
          obiettivi: const Value('Ipertrofia'),
          urlImmagine: const Value('assets/esercizi/crossover-cavi-alti.png'),
        ),
      );

      await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'French press bilanciere',
          descrizione: const Value('French press con bilanciere su panca'),
          muscoloObiettivo: const Value('Tricipiti'),
          attrezzo: Attrezzo.bilanciere,
          gruppoMuscolare: GruppoMuscolare.tricipiti,
          durataMinuti: const Value(5),
          intensita: const Value('Media'),
          obiettivi: const Value('Ipertrofia'),
          urlImmagine:
              const Value('assets/esercizi/french-press-bilanciere.png'),
        ),
      );

      await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Hack squat',
          descrizione: const Value('Hack squat alla macchina'),
          muscoloObiettivo: const Value('Quadricipiti'),
          attrezzo: Attrezzo.macchina,
          gruppoMuscolare: GruppoMuscolare.quadricipiti,
          durataMinuti: const Value(8),
          intensita: const Value('Alta'),
          obiettivi: const Value('Forza'),
          urlImmagine: const Value('assets/esercizi/hack-squat.png'),
        ),
      );

      await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Push cavi',
          descrizione: const Value('Pushdown ai cavi per tricipiti'),
          muscoloObiettivo: const Value('Tricipiti'),
          attrezzo: Attrezzo.cavo,
          gruppoMuscolare: GruppoMuscolare.tricipiti,
          durataMinuti: const Value(4),
          intensita: const Value('Media'),
          obiettivi: const Value('Ipertrofia'),
          urlImmagine: const Value('assets/esercizi/push-cavi.png'),
        ),
      );

      await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Spinte manubri panca piana',
          descrizione: const Value('Spinte con manubri su panca piana'),
          muscoloObiettivo: const Value('Pettorali'),
          attrezzo: Attrezzo.manubri,
          gruppoMuscolare: GruppoMuscolare.pettorali,
          durataMinuti: const Value(6),
          intensita: const Value('Media'),
          obiettivi: const Value('Forza'),
          urlImmagine:
              const Value('assets/esercizi/spinte-manubri-panca-piana.png'),
        ),
      );

      await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Spinte panca alta manubri',
          descrizione: const Value('Spinte con manubri su panca inclinata'),
          muscoloObiettivo: const Value('Pettorali superiori'),
          attrezzo: Attrezzo.manubri,
          gruppoMuscolare: GruppoMuscolare.pettorali,
          durataMinuti: const Value(6),
          intensita: const Value('Media'),
          obiettivi: const Value('Forza'),
          urlImmagine:
              const Value('assets/esercizi/spinte-panca-alta-manubri.png'),
        ),
      );

      await into(esercizi).insert(
        EserciziCompanion.insert(
          nome: 'Spinte seduto manubri',
          descrizione: const Value('Spinte da seduto con manubri'),
          muscoloObiettivo: const Value('Spalle'),
          attrezzo: Attrezzo.manubri,
          gruppoMuscolare: GruppoMuscolare.spalle,
          durataMinuti: const Value(5),
          intensita: const Value('Media'),
          obiettivi: const Value('Forza'),
          urlImmagine: const Value('assets/esercizi/spinte-seduto-manubri.png'),
        ),
      );

      final schedaId = await into(schede).insert(
        SchedeCompanion.insert(
          nomeScheda: 'Full body base',
          descrizione: const Value('Routine completa 3x settimana'),
          livelloDifficolta: const Value('Intermedio'),
          utenteId: 1,
          modello: const Value(false),
          attiva: const Value(true),
          dataAssegnazione: Value(DateTime.now()),
          noteAllenatore: const Value('Mantieni tecnica pulita'),
        ),
      );

      await batch((batch) {
        batch.insertAll(schedeEsercizi, [
          SchedeEserciziCompanion.insert(
            schedaId: schedaId,
            esercizioId: esercizioSpinta,
            serie: const Value(4),
            ripetizioni: const Value(8),
            peso: const Value(60),

            sezione: const Value('Lunedì A (petto e spalle)'),
            ordineSezione: const Value(0),
            ordineEsercizio: const Value(0),
          ),
          SchedeEserciziCompanion.insert(
            schedaId: schedaId,
            esercizioId: esercizioSquat,
            serie: const Value(4),
            ripetizioni: const Value(8),
            peso: const Value(80),

            sezione: const Value('Mercoledì B (gambe)'),
            ordineSezione: const Value(1),
            ordineEsercizio: const Value(0),
          ),
          SchedeEserciziCompanion.insert(
            schedaId: schedaId,
            esercizioId: esercizioTrazioni,
            serie: const Value(3),
            ripetizioni: const Value(6),
            peso: const Value(0),

            sezione: const Value('Venerdì C (dorso e braccia)'),
            ordineSezione: const Value(2),
            ordineEsercizio: const Value(0),
          ),
          SchedeEserciziCompanion.insert(
            schedaId: schedaId,
            esercizioId: esercizioCore,
            serie: const Value(3),
            ripetizioni: const Value(45),
            peso: const Value(0),

            sezione: const Value('Venerdì C (dorso e braccia)'),
            ordineSezione: const Value(2),
            ordineEsercizio: const Value(1),
          ),
        ]);
      });

    });

    await _assicuraImpostazioniBase();
  }

  Future<void> _assicuraImpostazioniBase() async {
    final voce = await (select(impostazioni)
          ..where((tbl) => tbl.chiave.equals('recuperoSecondi')))
        .getSingleOrNull();
    if (voce == null) {
      await into(impostazioni).insert(
        const ImpostazioniCompanion(
          chiave: Value('recuperoSecondi'),
          valore: Value('90'),
        ),
      );
    }

    final vibrazione = await (select(impostazioni)
          ..where((tbl) => tbl.chiave.equals('recuperoVibrazione')))
        .getSingleOrNull();
    if (vibrazione == null) {
      await into(impostazioni).insert(
        const ImpostazioniCompanion(
          chiave: Value('recuperoVibrazione'),
          valore: Value('true'),
        ),
      );
    }

    final beep = await (select(impostazioni)
          ..where((tbl) => tbl.chiave.equals('recuperoBeep')))
        .getSingleOrNull();
    if (beep == null) {
      await into(impostazioni).insert(
        const ImpostazioniCompanion(
          chiave: Value('recuperoBeep'),
          valore: Value('true'),
        ),
      );
    }

    final memoriaPesi = await (select(impostazioni)
          ..where((tbl) => tbl.chiave.equals('memorizzaUltimiPesi')))
        .getSingleOrNull();
    if (memoriaPesi == null) {
      await into(impostazioni).insert(
        const ImpostazioniCompanion(
          chiave: Value('memorizzaUltimiPesi'),
          valore: Value('false'),
        ),
      );
    }
  }

  Future<UtentiData?> leggiUtentePerId(int id) {
    return (select(utenti)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<void> salvaUtente({
    required int id,
    required String nome,
    String? email,
  }) async {
    await into(utenti).insertOnConflictUpdate(
      UtentiCompanion(
        id: Value(id),
        nome: Value(nome),
        email: Value(email),
      ),
    );
  }

  Future<void> salvaSessioneAuth({
    required int utenteId,
    required String token,
  }) async {
    await into(impostazioni).insertOnConflictUpdate(
      ImpostazioniCompanion(
        chiave: const Value('auth_user_id'),
        valore: Value(utenteId.toString()),
      ),
    );
    await into(impostazioni).insertOnConflictUpdate(
      ImpostazioniCompanion(
        chiave: const Value('auth_token'),
        valore: Value(token),
      ),
    );
  }

  Future<SessioneAuth?> leggiSessioneAuth() async {
    final idVoce = await (select(impostazioni)
          ..where((tbl) => tbl.chiave.equals('auth_user_id')))
        .getSingleOrNull();
    final tokenVoce = await (select(impostazioni)
          ..where((tbl) => tbl.chiave.equals('auth_token')))
        .getSingleOrNull();

    if (idVoce == null || tokenVoce == null) {
      return null;
    }

    final utenteId = int.tryParse(idVoce.valore);
    final token = tokenVoce.valore;
    if (utenteId == null || token.isEmpty) {
      return null;
    }
    return SessioneAuth(utenteId: utenteId, token: token);
  }

  Future<void> eliminaSessioneAuth() async {
    await (delete(impostazioni)
          ..where((tbl) => tbl.chiave.equals('auth_user_id')))
        .go();
    await (delete(impostazioni)
          ..where((tbl) => tbl.chiave.equals('auth_token')))
        .go();
  }

  Future<int> leggiRecuperoSecondi() async {
    final voce = await (select(impostazioni)
          ..where((tbl) => tbl.chiave.equals('recuperoSecondi')))
        .getSingleOrNull();
    if (voce == null) return 90;
    final valore = int.tryParse(voce.valore);
    return valore ?? 90;
  }

  Future<void> salvaRecuperoSecondi(int secondi) async {
    await into(impostazioni).insertOnConflictUpdate(
      ImpostazioniCompanion(
        chiave: const Value('recuperoSecondi'),
        valore: Value(secondi.toString()),
      ),
    );
  }

  Future<bool> leggiVibrazioneRecupero() async {
    final voce = await (select(impostazioni)
          ..where((tbl) => tbl.chiave.equals('recuperoVibrazione')))
        .getSingleOrNull();
    if (voce == null) return true;
    final valore = voce.valore.toLowerCase();
    return valore == 'true' || valore == '1';
  }

  Future<void> salvaVibrazioneRecupero(bool attivo) async {
    await into(impostazioni).insertOnConflictUpdate(
      ImpostazioniCompanion(
        chiave: const Value('recuperoVibrazione'),
        valore: Value(attivo.toString()),
      ),
    );
  }

  Future<bool> leggiBeepRecupero() async {
    final voce = await (select(impostazioni)
          ..where((tbl) => tbl.chiave.equals('recuperoBeep')))
        .getSingleOrNull();
    if (voce == null) return false;
    final valore = voce.valore.toLowerCase();
    return valore == 'true' || valore == '1';
  }

  Future<void> salvaBeepRecupero(bool attivo) async {
    await into(impostazioni).insertOnConflictUpdate(
      ImpostazioniCompanion(
        chiave: const Value('recuperoBeep'),
        valore: Value(attivo.toString()),
      ),
    );
  }

  Future<bool> leggiMemorizzaUltimiPesi() async {
    final voce = await (select(impostazioni)
          ..where((tbl) => tbl.chiave.equals('memorizzaUltimiPesi')))
        .getSingleOrNull();
    if (voce == null) return false;
    final valore = voce.valore.toLowerCase();
    return valore == 'true' || valore == '1';
  }

  Future<void> salvaMemorizzaUltimiPesi(bool attivo) async {
    await into(impostazioni).insertOnConflictUpdate(
      ImpostazioniCompanion(
        chiave: const Value('memorizzaUltimiPesi'),
        valore: Value(attivo.toString()),
      ),
    );
  }

  Stream<List<EserciziData>> guardaEsercizi({
    String? ricerca,
    Attrezzo? attrezzo,
    GruppoMuscolare? gruppoMuscolare,
  }) {
    final query = select(esercizi);
    if (ricerca != null && ricerca.trim().isNotEmpty) {
      query.where((tbl) => tbl.nome.like('%${ricerca.trim()}%'));
    }
    if (attrezzo != null) {
      query.where((tbl) => tbl.attrezzo.equalsValue(attrezzo));
    }
    if (gruppoMuscolare != null) {
      query.where((tbl) => tbl.gruppoMuscolare.equalsValue(gruppoMuscolare));
    }
    query.orderBy([(tbl) => OrderingTerm(expression: tbl.nome)]);
    return query.watch();
  }

  Future<EserciziData?> leggiEsercizio(int id) {
    return (select(esercizi)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> creaEsercizio(EserciziCompanion dati) {
    return into(esercizi).insert(dati);
  }

  Future<void> aggiornaEsercizio(EserciziCompanion dati) {
    return update(esercizi).replace(dati);
  }

  Future<void> eliminaEsercizio(int id) async {
    await (delete(schedeEsercizi)..where((tbl) => tbl.esercizioId.equals(id)))
        .go();
    await (delete(esercizi)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<SchedeData>> guardaSchede({
    bool soloAttive = false,
    bool soloModelli = false,
  }) {
    final query = select(schede);
    if (soloAttive) {
      query.where((tbl) => tbl.attiva.equals(true));
    }
    if (soloModelli) {
      query.where((tbl) => tbl.modello.equals(true));
    }
    query.orderBy([(tbl) => OrderingTerm(expression: tbl.nomeScheda)]);
    return query.watch();
  }

  Future<SchedeData?> leggiScheda(int id) {
    return (select(schede)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<SchedeData?> guardaScheda(int id) {
    return (select(schede)..where((tbl) => tbl.id.equals(id)))
        .watchSingleOrNull();
  }

  Stream<List<EsercizioInScheda>> guardaEserciziScheda(int idScheda) {
    final query = select(schedeEsercizi).join([
      innerJoin(esercizi, esercizi.id.equalsExp(schedeEsercizi.esercizioId)),
    ])
      ..where(schedeEsercizi.schedaId.equals(idScheda))
      ..orderBy([
        OrderingTerm(expression: schedeEsercizi.ordineSezione),
        OrderingTerm(expression: schedeEsercizi.ordineEsercizio),
        OrderingTerm(expression: esercizi.nome),
      ]);

    return query.watch().map((righe) {
      return righe.map((riga) {
        final rigaSchedaEsercizio = riga.readTable(schedeEsercizi);
        final rigaEsercizio = riga.readTable(esercizi);

        return EsercizioInScheda(
          esercizio: rigaEsercizio,
          serie: rigaSchedaEsercizio.serie,
          ripetizioni: rigaSchedaEsercizio.ripetizioni,
          ripetizioniPiramidali: rigaSchedaEsercizio.ripetizioniPiramidali,
          peso: rigaSchedaEsercizio.peso,
          durataMinuti: rigaSchedaEsercizio.durataMinuti,
          noteAllenatore: rigaSchedaEsercizio.noteAllenatore,
          sezione: rigaSchedaEsercizio.sezione,
          ordineSezione: rigaSchedaEsercizio.ordineSezione,
          ordineEsercizio: rigaSchedaEsercizio.ordineEsercizio,
        );
      }).toList();
    });
  }

  Stream<List<SessioneCalendario>> guardaSessioniCompletate(int utenteId) {
    final query = select(sessioniAllenamento).join([
      leftOuterJoin(schede, schede.id.equalsExp(sessioniAllenamento.schedaId)),
    ])
      ..where(
        sessioniAllenamento.utenteId.equals(utenteId) &
            sessioniAllenamento.completata.equals(true),
      )
      ..orderBy([
        OrderingTerm(
          expression: sessioniAllenamento.fine,
          mode: OrderingMode.desc,
        ),
        OrderingTerm(expression: sessioniAllenamento.inizio),
      ]);

    return query.watch().map((righe) {
      return righe.map((riga) {
        final sessione = riga.readTable(sessioniAllenamento);
        final scheda = riga.readTableOrNull(schede);
        return SessioneCalendario(
          sessione: sessione,
          nomeScheda: scheda?.nomeScheda ?? 'Sessione libera',
        );
      }).toList();
    });
  }

  Stream<List<SerieRegistrataConEsercizio>> guardaSerieSessione(
    int sessioneId,
  ) {
    final query = select(serieRegistrate).join([
      innerJoin(esercizi, esercizi.id.equalsExp(serieRegistrate.esercizioId)),
    ])
      ..where(serieRegistrate.sessioneId.equals(sessioneId))
      ..orderBy([
        OrderingTerm(expression: serieRegistrate.esercizioId),
        OrderingTerm(expression: serieRegistrate.indiceSerie),
        OrderingTerm(expression: serieRegistrate.dataOra),
      ]);

    return query.watch().map((righe) {
      return righe.map((riga) {
        final serie = riga.readTable(serieRegistrate);
        final esercizio = riga.readTable(esercizi);
        return SerieRegistrataConEsercizio(
          serie: serie,
          esercizio: esercizio,
        );
      }).toList();
    });
  }



  Future<void> salvaSchedaConEsercizi({
    required SchedeCompanion scheda,
    required List<ElementoSchedaIngresso> elementi,
  }) async {
    await transaction(() async {
      int schedaId;
      if (scheda.id.present) {
        await update(schede).replace(scheda);
        schedaId = scheda.id.value;
        await (delete(schedeEsercizi)
              ..where((tbl) => tbl.schedaId.equals(schedaId)))
            .go();
      } else {
        schedaId = await into(schede).insert(scheda);
      }

      for (final elemento in elementi) {
        await into(schedeEsercizi).insert(
          SchedeEserciziCompanion.insert(
            schedaId: schedaId,
            esercizioId: elemento.esercizioId,
            serie: Value(elemento.serie),
            ripetizioni: Value(elemento.ripetizioni),
            ripetizioniPiramidali: Value(elemento.ripetizioniPiramidali),
            peso: Value(elemento.peso),
            durataMinuti: Value(elemento.durataMinuti),
            noteAllenatore: Value(elemento.noteAllenatore),

            // nuovi campi
            sezione: Value(elemento.sezione),
            ordineSezione: Value(elemento.ordineSezione),
            ordineEsercizio: Value(elemento.ordineEsercizio),
          ),
        );
      }

    });
  }

  Future<void> eliminaScheda(int id) async {
    await transaction(() async {
      await (delete(schedeEsercizi)..where((tbl) => tbl.schedaId.equals(id)))
          .go();
      await (delete(schede)..where((tbl) => tbl.id.equals(id))).go();
    });
  }

  Future<int> avviaSessione({int? schedaId, required int utenteId}) async {
    return into(sessioniAllenamento).insert(
      SessioniAllenamentoCompanion.insert(
        schedaId: Value(schedaId),
        utenteId: utenteId,
        inizio: DateTime.now(),
        completata: const Value(false),
      ),
    );
  }

  Future<SessioniAllenamentoData?> leggiSessionePerId(int id) {
    return (select(sessioniAllenamento)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<SessioniAllenamentoData?> leggiSessioneAttiva(int utenteId) {
    return (select(sessioniAllenamento)
          ..where(
            (tbl) =>
                tbl.utenteId.equals(utenteId) & tbl.completata.equals(false),
          )
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.inizio,
                  mode: OrderingMode.desc,
                )
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> completaSessione(int sessioneId) async {
    await (update(sessioniAllenamento)..where((tbl) => tbl.id.equals(sessioneId)))
        .write(
      SessioniAllenamentoCompanion(
        fine: Value(DateTime.now()),
        completata: const Value(true),
      ),
    );
  }

  Stream<List<SerieRegistrateData>> guardaSeriePerEsercizio(
    int sessioneId,
    int esercizioId,
  ) {
    final query = select(serieRegistrate)
      ..where(
        (tbl) => tbl.sessioneId.equals(sessioneId) &
            tbl.esercizioId.equals(esercizioId),
      )
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.indiceSerie),
        (tbl) => OrderingTerm(expression: tbl.dataOra),
      ]);
    return query.watch();
  }

  Future<int> contaSerieInSessione(int sessioneId, int esercizioId) async {
    final conteggio = await (select(serieRegistrate)
          ..where(
            (tbl) => tbl.sessioneId.equals(sessioneId) &
                tbl.esercizioId.equals(esercizioId),
          ))
        .get();
    return conteggio.length;
  }

  Future<double?> leggiUltimoPesoEsercizio(int esercizioId) async {
    final record = await (select(serieRegistrate)
      ..where((tbl) =>
      tbl.esercizioId.equals(esercizioId) & tbl.peso.isNotNull())
      ..orderBy([
            (tbl) => OrderingTerm(
          expression: tbl.dataOra,
          mode: OrderingMode.desc,
        ),
            (tbl) => OrderingTerm(
          expression: tbl.id,
          mode: OrderingMode.desc,
        ),
      ])
      ..limit(1))
        .getSingleOrNull();

    return record?.peso;
  }


  Future<int> registraSerie({
    required int sessioneId,
    required int esercizioId,
    required int indiceSerie,
    required int ripetizioni,
    double? peso,
    double? rpe,
    int? secondiTempo,
    String? note,
  }) {
    return into(serieRegistrate).insert(
      SerieRegistrateCompanion.insert(
        sessioneId: sessioneId,
        esercizioId: esercizioId,
        indiceSerie: indiceSerie,
        ripetizioni: ripetizioni,
        peso: Value(peso),
        rpe: Value(rpe),
        secondiTempo: Value(secondiTempo),
        note: Value(note),
        dataOra: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<MisurazioniData>> guardaMisure(int utenteId) {
    final query = select(misurazioni)
      ..where((tbl) => tbl.utenteId.equals(utenteId))
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.data, mode: OrderingMode.desc)
      ]);
    return query.watch();
  }

  Future<int> creaMisura(MisurazioniCompanion dati) {
    return into(misurazioni).insert(dati);
  }

  Future<void> sincronizzaSchedaRemota({
    required int utenteId,
    required SchedaRemota scheda,
    required List<EsercizioInSchedaRemota> eserciziRemoti,
  }) async {
    await transaction(() async {
      await into(schede).insertOnConflictUpdate(
        SchedeCompanion(
          id: Value(scheda.id),
          nomeScheda: Value(scheda.nomeScheda),
          descrizione: Value(scheda.descrizione),
          livelloDifficolta: Value(scheda.livelloDifficolta),
          utenteId: Value(utenteId),
          attiva: Value(scheda.attiva),
          modello: const Value(false),
          noteAllenatore: Value(scheda.noteAllenatore),
        ),
      );

      for (final e in eserciziRemoti) {
        await into(esercizi).insertOnConflictUpdate(
          EserciziCompanion(
            id: Value(e.esercizioId),
            nome: Value(e.nomeEsercizio),
            muscoloObiettivo: Value(e.gruppoMuscolare),
            attrezzo: const Value(Attrezzo.altro),
            gruppoMuscolare: Value(_parseGruppoMuscolare(e.gruppoMuscolare)),
            urlImmagine: Value(e.immagineUrl),
          ),
        );
      }

      await (delete(schedeEsercizi)
            ..where((tbl) => tbl.schedaId.equals(scheda.id)))
          .go();

      for (int i = 0; i < eserciziRemoti.length; i++) {
        final e = eserciziRemoti[i];
        await into(schedeEsercizi).insert(
          SchedeEserciziCompanion.insert(
            schedaId: scheda.id,
            esercizioId: e.esercizioId,
            serie: Value(e.serie),
            ripetizioni: Value(e.ripetizioni),
            peso: Value(e.pesoTarget),
            sezione: Value(e.sezione),
            ordineSezione: Value(e.giorno),
            ordineEsercizio: Value(i),
          ),
        );
      }
    });
  }

  GruppoMuscolare _parseGruppoMuscolare(String? nome) {
    if (nome == null) return GruppoMuscolare.pettorali;
    return GruppoMuscolare.values.firstWhere(
      (g) => g.name.toLowerCase() == nome.toLowerCase(),
      orElse: () => GruppoMuscolare.pettorali,
    );
  }
}
