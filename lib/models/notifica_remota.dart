class NotificaRemota {
  const NotificaRemota({
    required this.id,
    required this.titolo,
    required this.corpo,
    required this.tipo,
    required this.stato,
    required this.canale,
    this.destinatarioNome,
    this.dataCreazione,
    this.dataInvio,
  });

  final int id;
  final String titolo;
  final String corpo;
  final String tipo;
  final String stato;
  final String canale;
  final String? destinatarioNome;
  final DateTime? dataCreazione;
  final DateTime? dataInvio;

  bool get isBroadcast => tipo == 'BROADCAST';

  factory NotificaRemota.fromJson(Map<String, dynamic> json) {
    return NotificaRemota(
      id: (json['id'] as num).toInt(),
      titolo: json['titolo'] as String,
      corpo: json['corpo'] as String? ?? '',
      tipo: json['tipo'] as String? ?? 'SINGOLA',
      stato: json['stato'] as String? ?? 'INVIATA',
      canale: json['canale'] as String? ?? 'ENTRAMBI',
      destinatarioNome: json['destinatarioNome'] as String?,
      dataCreazione: json['dataCreazione'] != null
          ? DateTime.tryParse(json['dataCreazione'] as String)
          : null,
      dataInvio: json['dataInvio'] != null
          ? DateTime.tryParse(json['dataInvio'] as String)
          : null,
    );
  }
}
