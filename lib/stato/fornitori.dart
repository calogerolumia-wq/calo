import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/archivio_locale.dart';
import '../models/scheda_remota.dart';
import '../services/schede_service.dart';
import '../utils/auth_api.dart';

final fornitoreArchivioLocale = Provider<ArchivioLocale>((ref) {
  final archivio = ArchivioLocale();
  ref.onDispose(archivio.close);
  return archivio;
});

class StatoAutenticazione {
  const StatoAutenticazione._({this.utente, this.token});

  final UtentiData? utente;
  final String? token;

  bool get autenticato => utente != null && token != null;

  factory StatoAutenticazione.nonAutenticato() =>
      const StatoAutenticazione._();

  factory StatoAutenticazione.autenticato(
    UtentiData utente,
    String token,
  ) =>
      StatoAutenticazione._(utente: utente, token: token);
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

    return StatoAutenticazione.autenticato(utente, sessione.token);
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
    );
    await archivio.salvaSessioneAuth(
      utenteId: risposta.id,
      token: risposta.token,
    );

    final utente = await archivio.leggiUtentePerId(risposta.id);
    if (utente == null) {
      throw AuthException('Impossibile salvare i dati utente');
    }

    state = AsyncValue.data(
      StatoAutenticazione.autenticato(utente, risposta.token),
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

    await archivio.sincronizzaSchedaRemota(
      utenteId: idUtente,
      scheda: scheda,
      eserciziRemoti: esercizi,
    );

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
    if (auth == null || !auth.autenticato || auth.token == null) return [];
    return SchedeService(token: auth.token!).getSchede();
  }

  Future<void> ricarica() async {
    ref.invalidateSelf();
  }
}

final fornitoreEserciziSchedaRemota = FutureProvider.autoDispose
    .family<List<EsercizioInSchedaRemota>, int>((ref, schedaId) async {
  final auth = ref.watch(gestoreAutenticazione).valueOrNull;
  if (auth == null || !auth.autenticato || auth.token == null) return [];
  return SchedeService(token: auth.token!).getEserciziScheda(schedaId);
});
