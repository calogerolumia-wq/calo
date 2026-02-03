import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/archivio_locale.dart';

const int idUtenteDemo = 1;

final fornitoreArchivioLocale = Provider<ArchivioLocale>((ref) {
  final archivio = ArchivioLocale();
  ref.onDispose(archivio.close);
  return archivio;
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
    return archivio.leggiSessioneAttiva(idUtenteDemo);
  }

  Future<int> avviaDaScheda(int schedaId) async {
    final archivio = ref.read(fornitoreArchivioLocale);
    final idSessione =
        await archivio.avviaSessione(schedaId: schedaId, utenteId: idUtenteDemo);
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
