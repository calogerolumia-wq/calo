class SetRecordRemoto {
  const SetRecordRemoto({
    required this.id,
    required this.esercizioId,
    required this.nomeEsercizio,
    required this.serieIndex,
    required this.ripetizioni,
    this.peso,
    this.rpe,
    this.tempoSec,
    this.note,
  });

  final int id;
  final int esercizioId;
  final String nomeEsercizio;
  final int serieIndex;
  final int ripetizioni;
  final double? peso;
  final int? rpe;
  final int? tempoSec;
  final String? note;

  factory SetRecordRemoto.fromJson(Map<String, dynamic> json) =>
      SetRecordRemoto(
        id: json['id'] as int,
        esercizioId: json['esercizioId'] as int,
        nomeEsercizio: json['nomeEsercizio'] as String? ?? '',
        serieIndex: json['serieIndex'] as int,
        ripetizioni: json['ripetizioni'] as int,
        peso: (json['peso'] as num?)?.toDouble(),
        rpe: json['rpe'] as int?,
        tempoSec: json['tempoSec'] as int?,
        note: json['note'] as String?,
      );
}

class WorkoutSessioneRemota {
  const WorkoutSessioneRemota({
    required this.id,
    this.schedaId,
    this.nomeScheda,
    required this.startTime,
    this.endTime,
    this.note,
    required this.completed,
    required this.sets,
  });

  final int id;
  final int? schedaId;
  final String? nomeScheda;
  final DateTime startTime;
  final DateTime? endTime;
  final String? note;
  final bool completed;
  final List<SetRecordRemoto> sets;

  factory WorkoutSessioneRemota.fromJson(Map<String, dynamic> json) {
    final sets = (json['sets'] as List<dynamic>? ?? [])
        .map((e) => SetRecordRemoto.fromJson(e as Map<String, dynamic>))
        .toList();
    return WorkoutSessioneRemota(
      id: json['id'] as int,
      schedaId: json['schedaId'] as int?,
      nomeScheda: json['nomeScheda'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      note: json['note'] as String?,
      completed: json['completed'] as bool? ?? false,
      sets: sets,
    );
  }
}
