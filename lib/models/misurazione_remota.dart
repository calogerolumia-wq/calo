class MisurazioneRemota {
  const MisurazioneRemota({
    required this.id,
    required this.date,
    required this.peso,
    this.bodyFatPercent,
    this.petto,
    this.vita,
    this.coscia,
    this.note,
  });

  final int id;
  final DateTime date;
  final double peso;
  final double? bodyFatPercent;
  final double? petto;
  final double? vita;
  final double? coscia;
  final String? note;

  factory MisurazioneRemota.fromJson(Map<String, dynamic> json) =>
      MisurazioneRemota(
        id: json['id'] as int,
        date: DateTime.parse(json['date'] as String),
        peso: (json['peso'] as num).toDouble(),
        bodyFatPercent: (json['bodyFatPercent'] as num?)?.toDouble(),
        petto: (json['petto'] as num?)?.toDouble(),
        vita: (json['vita'] as num?)?.toDouble(),
        coscia: (json['coscia'] as num?)?.toDouble(),
        note: json['note'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'date':
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'peso': peso,
        if (bodyFatPercent != null) 'bodyFatPercent': bodyFatPercent,
        if (petto != null) 'petto': petto,
        if (vita != null) 'vita': vita,
        if (coscia != null) 'coscia': coscia,
        if (note != null && note!.isNotEmpty) 'note': note,
      };
}
