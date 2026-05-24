class SchedaRemota {
  const SchedaRemota({
    required this.id,
    required this.nomeScheda,
    this.descrizione,
    this.livelloDifficolta,
    required this.attiva,
    this.noteAllenatore,
    this.modello = false,
  });

  final int id;
  final String nomeScheda;
  final String? descrizione;
  final String? livelloDifficolta;
  final bool attiva;
  final String? noteAllenatore;
  final bool modello;

  factory SchedaRemota.fromJson(Map<String, dynamic> json) {
    return SchedaRemota(
      id: (json['id'] as num).toInt(),
      nomeScheda: json['nomeScheda'] as String,
      descrizione: json['descrizione'] as String?,
      livelloDifficolta: json['livelloDifficolta'] as String?,
      attiva: (json['attiva'] as bool?) ?? false,
      noteAllenatore: json['noteAllenatore'] as String?,
      modello: (json['modello'] as bool?) ?? false,
    );
  }
}

class EsercizioInSchedaRemota {
  const EsercizioInSchedaRemota({
    required this.id,
    required this.schedaId,
    required this.esercizioId,
    required this.serie,
    required this.ripetizioni,
    this.pesoTarget,
    required this.giorno,
    required this.nomeEsercizio,
    this.immagineUrl,
    this.gruppoMuscolare,
  });

  final int id;
  final int schedaId;
  final int esercizioId;
  final int serie;
  final int ripetizioni;
  final double? pesoTarget;
  final int giorno;
  final String nomeEsercizio;
  final String? immagineUrl;
  final String? gruppoMuscolare;

  String get sezione => giorno == 0 ? 'Allenamento' : 'Giorno $giorno';

  factory EsercizioInSchedaRemota.fromJson(Map<String, dynamic> json) {
    return EsercizioInSchedaRemota(
      id: (json['id'] as num).toInt(),
      schedaId: (json['schedaId'] as num).toInt(),
      esercizioId: (json['esercizioId'] as num).toInt(),
      serie: (json['serie'] as num).toInt(),
      ripetizioni: (json['ripetizioni'] as num).toInt(),
      pesoTarget: (json['pesoTarget'] as num?)?.toDouble(),
      giorno: (json['giorno'] as num).toInt(),
      nomeEsercizio: json['nomeEsercizio'] as String,
      immagineUrl: json['immagineUrl'] as String?,
      gruppoMuscolare: json['gruppoMuscolare'] as String?,
    );
  }
}
