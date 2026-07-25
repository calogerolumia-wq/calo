import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/archivio_locale.dart';
import '../models/configurazione_app.dart';
import '../models/esercizio_remoto.dart';
import '../models/notifica_remota.dart';
import '../models/scheda_remota.dart';
import '../services/esercizi_service.dart';
import '../services/notifiche_service.dart';
import '../services/schede_service.dart';
import '../services/sessioni_service.dart';
import '../services/workouts_service.dart';
import '../services/misurazioni_service.dart';
import '../models/workout_remoto.dart';
import '../models/misurazione_remota.dart';
import '../utils/auth_api.dart';
import '../utils/auth_exception.dart';

final fornitoreArchivioLocale = Provider<ArchivioLocale>((ref) {
  final archivio = ArchivioLocale();
  ref.onDispose(archivio.close);
  return archivio;
});

class StatoAutenticazione {
  const StatoAutenticazione._({
    this.utente,
    this.token,
    ConfigurazioneApp? configurazione,
    this.sessioneScaduta = false,
  }) : configurazione = configurazione ?? const ConfigurazioneApp();

  final UtentiData? utente;
  final String? token;
  final ConfigurazioneApp configurazione;
  final bool sessioneScaduta;

  /// Ha token valido → può chiamare le API.
  bool get autenticato => utente != null && token != null;

  /// Utente noto localmente ma token scaduto → può allenarsi offline.
  bool get modalitaOffline => utente != null && token == null && sessioneScaduta;

  /// Mai loggato → deve andare alla pagina di login.
  bool get maiFattoLogin => utente == null && !sessioneScaduta;

  factory StatoAutenticazione.nonAutenticato() =>
      const StatoAutenticazione._();

  factory StatoAutenticazione.autenticato(
    UtentiData utente,
    String token, {
    ConfigurazioneApp configurazione = const ConfigurazioneApp(),
  }) =>
      StatoAutenticazione._(
        utente: utente,
        token: token,
        configurazione: configurazione,
      );

  factory StatoAutenticazione.offlineConUtente(
    UtentiData utente, {
    ConfigurazioneApp configurazione = const ConfigurazioneApp(),
  }) =>
      StatoAutenticazione._(
        utente: utente,
        token: null,
        configurazione: configurazione,
        sessioneScaduta: true,
      );
}

final gestoreAutenticazione =
    AsyncNotifierProvider<GestoreAutenticazione, StatoAutenticazione>(
  GestoreAutenticazione.new,
);

class GestoreAutenticazione extends AsyncNotifier<StatoAutenticazione> {
  @override
  Future<StatoAutenticazione> build() async {
    final archivio = ref.read(fornitoreArchivioLocale);
    final sessione = await archivio.leggiSessioneAuth();
    if (sessione == null) {
      return StatoAutenticazione.nonAutenticato();
    }

    final utente = await archivio.leggiUtentePerId(sessione.utenteId);
    if (utente == null) {
      await archivio.eliminaSessioneAuth();
      return StatoAutenticazione.nonAutenticato();
    }

    final cfg = await archivio.leggiConfigurazione();
    final configurazione = ConfigurazioneApp(
      featureEsercizi: cfg['feat_esercizi'] ?? true,
      featureSchede: cfg['feat_schede'] ?? true,
      featureModelliSchede: cfg['feat_modelli_schede'] ?? true,
      featureTimer: cfg['feat_timer'] ?? true,
      featureMisurazioni: cfg['feat_misurazioni'] ?? true,
    );

    return StatoAutenticazione.autenticato(
      utente,
      sessione.token,
      configurazione: configurazione,
    );
  }

  Future<void> login({
    required String username,
    required String password,
    String? codiceAzienda,
    int? aziendaId,
  }) async {
    final archivio = ref.read(fornitoreArchivioLocale);
    final api = AuthApi();
    final risposta = await api.login(
      username: username,
      password: password,
      codiceAzienda: codiceAzienda,
      aziendaId: aziendaId,
    );

    await archivio.salvaUtente(
      id: risposta.id,
      nome: risposta.nomeCompleto,
      email: risposta.email,
      username: risposta.username,
    );
    await archivio.salvaSessioneAuth(
      utenteId: risposta.id,
      token: risposta.token,
    );
    await archivio.salvaConfigurazione(
      featureEsercizi: risposta.featureEsercizi,
      featureSchede: risposta.featureSchede,
      featureModelliSchede: risposta.featureModelliSchede,
      featureTimer: risposta.featureTimer,
      featureMisurazioni: risposta.featureMisurazioni,
    );

    final utente = await archivio.leggiUtentePerId(risposta.id);
    if (utente == null) {
      throw AuthException('Impossibile salvare i dati utente');
    }

    final configurazione = ConfigurazioneApp.fromLogin(risposta);
    state = AsyncValue.data(
      StatoAutenticazione.autenticato(
        utente,
        risposta.token,
        configurazione: configurazione,
      ),
    );

    // Sincronizza le sessioni completate offline durante la sessione scaduta
    unawaited(
      ref
          .read(gestoreSessioneAttiva.notifier)
          .sincronizzaSessioniPendenti(risposta.token),
    );
  }

  /// Token scaduto (401): mantiene i dati locali, disabilita le chiamate API.
  Future<void> segnaSessioneScaduta() async {
    final auth = state.valueOrNull;
    final utente = auth?.utente;
    if (utente == null) {
      state = AsyncValue.data(StatoAutenticazione.nonAutenticato());
      return;
    }
    state = AsyncValue.data(
      StatoAutenticazione.offlineConUtente(
        utente,
        configurazione: auth?.configurazione ?? const ConfigurazioneApp(),
      ),
    );
  }

  Future<void> logout() async {
    final auth = state.valueOrNull;
    final token = auth?.token;
    if (token == null) {
      state = AsyncValue.data(StatoAutenticazione.nonAutenticato());
      return;
    }

    final api = AuthApi();
    try {
      await api.logout(token: token);
    } catch (_) {
      // Logout locale comunque, il server e' stateless.
    }

    final archivio = ref.read(fornitoreArchivioLocale);
    await archivio.eliminaSessioneAuth();
    state = AsyncValue.data(StatoAutenticazione.nonAutenticato());
  }
}

final fornitoreUtenteCorrente = Provider<UtentiData?>((ref) {
  final auth = ref.watch(gestoreAutenticazione).valueOrNull;
  return auth?.utente;
});

final fornitoreIdUtenteCorrente = Provider<int?>((ref) {
  return ref.watch(fornitoreUtenteCorrente)?.id;
});

final fornitoreRecuperoSecondi = FutureProvider<int>((ref) async {
  final archivio = ref.read(fornitoreArchivioLocale);
  return archivio.leggiRecuperoSecondi();
});

final fornitoreVibrazioneRecupero = FutureProvider<bool>((ref) async {
  final archivio = ref.read(fornitoreArchivioLocale);
  return archivio.leggiVibrazioneRecupero();
});

final fornitoreBeepRecupero = FutureProvider<bool>((ref) async {
  final archivio = ref.read(fornitoreArchivioLocale);
  return archivio.leggiBeepRecupero();
});

final fornitoreMemoriaPesi = FutureProvider<bool>((ref) async {
  final archivio = ref.read(fornitoreArchivioLocale);
  return archivio.leggiMemorizzaUltimiPesi();
});

final gestoreSessioneAttiva =
    AsyncNotifierProvider<GestoreSessioneAttiva, SessioniAllenamentoData?>(
  GestoreSessioneAttiva.new,
);

class GestoreSessioneAttiva extends AsyncNotifier<SessioniAllenamentoData?> {
  @override
  Future<SessioniAllenamentoData?> build() async {
    final archivio = ref.read(fornitoreArchivioLocale);
    final idUtente = ref.watch(fornitoreIdUtenteCorrente);
    if (idUtente == null) return null;
    return archivio.leggiSessioneAttiva(idUtente);
  }

  Future<int> avviaDaScheda(int schedaId) async {
    final archivio = ref.read(fornitoreArchivioLocale);
    final idUtente = ref.read(fornitoreIdUtenteCorrente);
    if (idUtente == null) {
      throw StateError('Utente non autenticato');
    }
    final idSessione =
        await archivio.avviaSessione(schedaId: schedaId, utenteId: idUtente);
    final sessione = await archivio.leggiSessionePerId(idSessione);
    state = AsyncValue.data(sessione);
    return idSessione;
  }

  Future<int> avviaDaSchedaRemota(
    SchedaRemota scheda,
    List<EsercizioInSchedaRemota> esercizi,
  ) async {
    final archivio = ref.read(fornitoreArchivioLocale);
    final idUtente = ref.read(fornitoreIdUtenteCorrente);
    if (idUtente == null) throw StateError('Utente non autenticato');

    final idSessione = await archivio.avviaSessione(
      schedaId: scheda.id,
      utenteId: idUtente,
    );
    final sessione = await archivio.leggiSessionePerId(idSessione);
    state = AsyncValue.data(sessione);
    return idSessione;
  }

  Future<void> completaSessione(int sessioneId) async {
    final archivio = ref.read(fornitoreArchivioLocale);
    await archivio.completaSessione(sessioneId);
    state = const AsyncValue.data(null);
    unawaited(_sincronizzaSessioneRemota(sessioneId, archivio));
  }

  Future<void> _sincronizzaSessioneRemota(
    int sessioneId,
    ArchivioLocale archivio,
  ) async {
    try {
      final auth = ref.read(gestoreAutenticazione).valueOrNull;
      if (auth == null || !auth.autenticato || auth.token == null) return;

      final sessione = await archivio.leggiSessionePerId(sessioneId);
      if (sessione == null) return;

      final serie = await archivio.leggiTutteSerieDiSessione(sessioneId);

      final sets = serie
          .map((s) => <String, dynamic>{
                'esercizioId': s.esercizioId,
                'serieIndex': s.indiceSerie,
                'ripetizioni': s.ripetizioni,
                if (s.peso != null) 'peso': s.peso,
                if (s.rpe != null) 'rpe': s.rpe!.round(),
                if (s.secondiTempo != null) 'secondiTempo': s.secondiTempo,
                if (s.note != null && s.note!.isNotEmpty) 'note': s.note,
              })
          .toList();

      await SessioniService(token: auth.token!).sincronizzaSessione(
        schedaId: sessione.schedaId,
        inizio: sessione.inizio,
        fine: sessione.fine ?? DateTime.now(),
        note: sessione.note,
        serie: sets,
      );
      await archivio.segnaSessioneSincronizzata(sessioneId);
    } on UnauthorizedException {
      await ref.read(gestoreAutenticazione.notifier).segnaSessioneScaduta();
    } catch (_) {
      // fire-and-forget: sync errors are non-fatal
    }
  }

  Future<void> sincronizzaSessioniPendenti(String token) async {
    final archivio = ref.read(fornitoreArchivioLocale);
    final idUtente = ref.read(fornitoreIdUtenteCorrente);
    if (idUtente == null) return;

    final pendenti = await archivio.leggiSessioniDaSincronizzare(idUtente);
    for (final sessione in pendenti) {
      try {
        final serie = await archivio.leggiTutteSerieDiSessione(sessione.id);
        final sets = serie
            .map((s) => <String, dynamic>{
                  'esercizioId': s.esercizioId,
                  'serieIndex': s.indiceSerie,
                  'ripetizioni': s.ripetizioni,
                  if (s.peso != null) 'peso': s.peso,
                  if (s.rpe != null) 'rpe': s.rpe!.round(),
                  if (s.secondiTempo != null) 'secondiTempo': s.secondiTempo,
                  if (s.note != null && s.note!.isNotEmpty) 'note': s.note,
                })
            .toList();

        await SessioniService(token: token).sincronizzaSessione(
          schedaId: sessione.schedaId,
          inizio: sessione.inizio,
          fine: sessione.fine ?? DateTime.now(),
          note: sessione.note,
          serie: sets,
        );
        await archivio.segnaSessioneSincronizzata(sessione.id);
      } catch (_) {
        // Se una sessione fallisce, continua con le successive
      }
    }
  }
}

class StatoTimerRecupero {
  const StatoTimerRecupero({
    required this.durataConsigliata,
    required this.durataTotale,
    required this.rimanente,
    required this.inPausa,
  });

  final Duration durataConsigliata;
  final Duration durataTotale;
  final Duration rimanente;
  final bool inPausa;

  bool get attivo => rimanente > Duration.zero;

  StatoTimerRecupero copiaCon({
    Duration? durataConsigliata,
    Duration? durataTotale,
    Duration? rimanente,
    bool? inPausa,
  }) {
    return StatoTimerRecupero(
      durataConsigliata: durataConsigliata ?? this.durataConsigliata,
      durataTotale: durataTotale ?? this.durataTotale,
      rimanente: rimanente ?? this.rimanente,
      inPausa: inPausa ?? this.inPausa,
    );
  }

  factory StatoTimerRecupero.iniziale() => const StatoTimerRecupero(
        durataConsigliata: Duration.zero,
        durataTotale: Duration.zero,
        rimanente: Duration.zero,
        inPausa: false,
      );
}

final gestoreTimerRecupero =
    StateNotifierProvider<GestoreTimerRecupero, StatoTimerRecupero>(
  (ref) => GestoreTimerRecupero(),
);

class GestoreTimerRecupero extends StateNotifier<StatoTimerRecupero> {
  GestoreTimerRecupero() : super(StatoTimerRecupero.iniziale());

  Timer? _timer;

  void avvia(Duration durata) {
    _timer?.cancel();
    state = StatoTimerRecupero(
      durataConsigliata: durata,
      durataTotale: durata,
      rimanente: durata,
      inPausa: false,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer timer) {
    if (state.inPausa) return;
    final nuova = state.rimanente - const Duration(seconds: 1);
    if (nuova <= Duration.zero) {
      timer.cancel();
      state = state.copiaCon(rimanente: Duration.zero, inPausa: false);
      return;
    }
    state = state.copiaCon(rimanente: nuova);
  }

  void pausa() {
    if (!state.attivo) return;
    state = state.copiaCon(inPausa: true);
  }

  void riprendi() {
    if (!state.attivo) return;
    state = state.copiaCon(inPausa: false);
  }

  void aggiungiSecondi(int secondi) {
    if (!state.attivo) return;
    final durata = state.durataTotale + Duration(seconds: secondi);
    final rimanente = state.rimanente + Duration(seconds: secondi);
    state = state.copiaCon(durataTotale: durata, rimanente: rimanente);
  }

  void sottraiSecondi(int secondi) {
    if (!state.attivo) return;
    final rimanente = state.rimanente - Duration(seconds: secondi);
    if (rimanente <= Duration.zero) {
      salta();
      return;
    }
    state = state.copiaCon(rimanente: rimanente);
  }

  void salta() {
    _timer?.cancel();
    state = StatoTimerRecupero.iniziale();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Schede remote (dal backend)
// ---------------------------------------------------------------------------

final fornitoreSchedeRemote =
    AsyncNotifierProvider.autoDispose<GestoreSchedeRemote, List<SchedaRemota>>(
  GestoreSchedeRemote.new,
);

class GestoreSchedeRemote extends AutoDisposeAsyncNotifier<List<SchedaRemota>> {
  @override
  Future<List<SchedaRemota>> build() async {
    final auth = ref.watch(gestoreAutenticazione).valueOrNull;
    if (auth == null) return [];

    // Modalità offline: usa le schede già salvate in SQLite
    if (auth.modalitaOffline) {
      final archivio = ref.read(fornitoreArchivioLocale);
      final utenteId = auth.utente?.id;
      if (utenteId == null) return [];
      final locali = await archivio.leggiSchedePerUtente(utenteId);
      return locali
          .map((s) => SchedaRemota(
                id: s.id,
                nomeScheda: s.nomeScheda,
                descrizione: s.descrizione,
                livelloDifficolta: s.livelloDifficolta,
                attiva: s.attiva,
                noteAllenatore: s.noteAllenatore,
                modello: s.modello,
              ))
          .toList();
    }

    if (!auth.autenticato || auth.token == null) return [];

    try {
      return await SchedeService(token: auth.token!).getSchede();
    } on UnauthorizedException {
      await ref.read(gestoreAutenticazione.notifier).segnaSessioneScaduta();
      return [];
    }
  }

  Future<void> ricarica() async {
    ref.invalidateSelf();
  }
}

final fornitoreModelliSchede =
    FutureProvider.autoDispose<List<SchedaRemota>>((ref) async {
  final auth = ref.watch(gestoreAutenticazione).valueOrNull;
  if (auth == null || !auth.autenticato || auth.token == null) return [];
  try {
    return await SchedeService(token: auth.token!).getModelliSchede();
  } on UnauthorizedException {
    await ref.read(gestoreAutenticazione.notifier).segnaSessioneScaduta();
    return [];
  }
});

final fornitoreEserciziSchedaRemota = FutureProvider.autoDispose
    .family<List<EsercizioInSchedaRemota>, int>((ref, schedaId) async {
  final auth = ref.watch(gestoreAutenticazione).valueOrNull;
  if (auth == null || !auth.autenticato || auth.token == null) return [];
  try {
    return await SchedeService(token: auth.token!).getEserciziScheda(schedaId);
  } on UnauthorizedException {
    await ref.read(gestoreAutenticazione.notifier).segnaSessioneScaduta();
    return [];
  }
});

final fornitoreEserciziRemoti =
    FutureProvider.autoDispose<List<EsercizioRemoto>>((ref) async {
  final auth = ref.watch(gestoreAutenticazione).valueOrNull;
  if (auth == null || !auth.autenticato || auth.token == null) return [];
  try {
    return await EserciziService(token: auth.token!).getEsercizi();
  } on UnauthorizedException {
    await ref.read(gestoreAutenticazione.notifier).segnaSessioneScaduta();
    return [];
  }
});

final fornitoreConfigurazioneApp = Provider<ConfigurazioneApp>((ref) {
  final auth = ref.watch(gestoreAutenticazione).valueOrNull;
  return auth?.configurazione ?? const ConfigurazioneApp();
});

final fornitoreStoricoRemoto =
    FutureProvider.autoDispose<List<WorkoutSessioneRemota>>((ref) async {
  final auth = ref.watch(gestoreAutenticazione).valueOrNull;
  if (auth == null || !auth.autenticato || auth.token == null) return [];
  try {
    return await WorkoutsService(token: auth.token!).getStorico();
  } on UnauthorizedException {
    await ref.read(gestoreAutenticazione.notifier).segnaSessioneScaduta();
    return [];
  }
});

// ---------------------------------------------------------------------------
// Misurazioni remote (dal backend)
// ---------------------------------------------------------------------------

final fornitureMisurazioniRemote = AsyncNotifierProvider.autoDispose<
    GestoreMisurazioniRemote,
    List<MisurazioneRemota>>(GestoreMisurazioniRemote.new);

class GestoreMisurazioniRemote
    extends AutoDisposeAsyncNotifier<List<MisurazioneRemota>> {
  @override
  Future<List<MisurazioneRemota>> build() async {
    final auth = ref.watch(gestoreAutenticazione).valueOrNull;
    if (auth == null || auth.utente == null) return [];

    final utenteId = auth.utente!.id;
    final archivio = ref.read(fornitoreArchivioLocale);

    if (auth.modalitaOffline || auth.token == null) {
      return _daCacheLocale(archivio, utenteId);
    }

    try {
      final misure = await MisurazioniService(token: auth.token!)
          .getMisurazioni(utenteId);
      // Aggiorna la cache locale per il Dashboard e la modalità offline
      await archivio.sincronizzaMisureDaServer(misure, utenteId);

      return misure;
    } on UnauthorizedException {
      await ref.read(gestoreAutenticazione.notifier).segnaSessioneScaduta();
      return _daCacheLocale(archivio, utenteId);
    } catch (_) {
      return _daCacheLocale(archivio, utenteId);
    }
  }

  Future<List<MisurazioneRemota>> _daCacheLocale(
      ArchivioLocale archivio, int utenteId) async {
    final locali = await archivio.leggiMisurePerUtente(utenteId);
    return locali
        .map((m) => MisurazioneRemota(
              id: 0,
              date: m.data,
              peso: m.peso,
              bodyFatPercent: m.percentualeMassaGrassa,
              petto: m.petto,
              vita: m.vita,
              coscia: m.coscia,
              note: m.note,
            ))
        .toList();
  }

  Future<void> crea(MisurazioneRemota misura) async {
    final auth = ref.read(gestoreAutenticazione).valueOrNull;
    if (auth == null || auth.utente == null) return;
    final utenteId = auth.utente!.id;
    final archivio = ref.read(fornitoreArchivioLocale);

    // Salva subito in locale (per Dashboard e offline)
    await archivio.creaMisura(MisurazioniCompanion.insert(
      utenteId: utenteId,
      peso: misura.peso,
      percentualeMassaGrassa: Value(misura.bodyFatPercent),
      petto: Value(misura.petto),
      vita: Value(misura.vita),
      coscia: Value(misura.coscia),
      note: Value(misura.note?.isEmpty == true ? null : misura.note),
      data: misura.date,
    ));

    // Sincronizza con il server se online
    if (auth.token != null) {
      try {
        await MisurazioniService(token: auth.token!)
            .creaMisurazione(utenteId, misura);
      } on UnauthorizedException {
        await ref.read(gestoreAutenticazione.notifier).segnaSessioneScaduta();
      } catch (_) {
        // Rimane in locale
      }
    }

    ref.invalidateSelf();
  }

  Future<void> elimina(MisurazioneRemota misura) async {
    final auth = ref.read(gestoreAutenticazione).valueOrNull;
    if (auth == null || auth.utente == null) return;
    final utenteId = auth.utente!.id;
    final archivio = ref.read(fornitoreArchivioLocale);

    // Elimina dal server se ha un ID remoto valido
    if (auth.token != null && misura.id > 0) {
      try {
        await MisurazioniService(token: auth.token!)
            .eliminaMisurazione(utenteId, misura.id);
      } on UnauthorizedException {
        await ref.read(gestoreAutenticazione.notifier).segnaSessioneScaduta();
      } catch (_) {
        // Continua con l'eliminazione locale
      }
    }

    // Elimina dalla cache locale per data (dedup per data)
    await archivio.eliminaMisuraPerData(utenteId, misura.date);
    ref.invalidateSelf();
  }
}

final fornitoreNotifiche =
    FutureProvider.autoDispose<List<NotificaRemota>>((ref) async {
  final auth = ref.watch(gestoreAutenticazione).valueOrNull;
  if (auth == null || !auth.autenticato || auth.token == null) return [];
  try {
    return await NotificheService(token: auth.token!).getMie();
  } on UnauthorizedException {
    await ref.read(gestoreAutenticazione.notifier).segnaSessioneScaduta();
    return [];
  }
});
