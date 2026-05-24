class EsercizioRemoto {
  const EsercizioRemoto({
    required this.id,
    required this.nome,
    this.descrizione,
    this.gruppoMuscolare,
    this.muscoloTarget,
    this.attrezzo,
    this.immagineUrl,
    this.intensita,
  });

  final int id;
  final String nome;
  final String? descrizione;
  final String? gruppoMuscolare;
  final String? muscoloTarget;
  final String? attrezzo;
  final String? immagineUrl;
  final String? intensita;

  factory EsercizioRemoto.fromJson(Map<String, dynamic> json) {
    return EsercizioRemoto(
      id: (json['id'] as num).toInt(),
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String?,
      gruppoMuscolare: json['gruppoMuscolare'] as String?,
      muscoloTarget: json['muscoloTarget'] as String?,
      attrezzo: json['attrezzo'] as String?,
      immagineUrl: json['immagineUrl'] as String?,
      intensita: json['intensita'] as String?,
    );
  }
}
