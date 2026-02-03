enum TipoGruppoAllenamento { superset, circuito }

class InfoGruppoAllenamento {
  const InfoGruppoAllenamento({
    required this.sezione,
    this.tipo,
    this.etichetta,
  });

  final String sezione;
  final TipoGruppoAllenamento? tipo;
  final String? etichetta;

  bool get haGruppo => tipo != null;
}

const String _separatoreGruppo = '||';

InfoGruppoAllenamento decodificaSezioneConGruppo(String raw) {
  final pulita = raw.trim();
  if (pulita.isEmpty) {
    return const InfoGruppoAllenamento(sezione: 'Allenamento');
  }

  final parti = pulita.split(_separatoreGruppo);
  final base = parti.first.trim().isEmpty ? 'Allenamento' : parti.first.trim();

  if (parti.length < 2) {
    return InfoGruppoAllenamento(sezione: base);
  }

  final info = parti.sublist(1).join(_separatoreGruppo).trim();
  if (info.isEmpty) {
    return InfoGruppoAllenamento(sezione: base);
  }

  final tokenParts = info.split(':');
  final tipoToken = tokenParts.first.trim().toLowerCase();
  TipoGruppoAllenamento? tipo;
  if (tipoToken == 'superset') {
    tipo = TipoGruppoAllenamento.superset;
  } else if (tipoToken == 'circuito') {
    tipo = TipoGruppoAllenamento.circuito;
  }

  if (tipo == null) {
    return InfoGruppoAllenamento(sezione: base);
  }

  final label = tokenParts.length > 1
      ? tokenParts.sublist(1).join(':').trim()
      : '';

  return InfoGruppoAllenamento(
    sezione: base,
    tipo: tipo,
    etichetta: label.isEmpty ? null : label,
  );
}

String codificaSezioneConGruppo(
  String sezione,
  TipoGruppoAllenamento? tipo,
  String? etichetta,
) {
  final base = sezione.trim().isEmpty ? 'Allenamento' : sezione.trim();
  if (tipo == null) return base;

  final token = tipo == TipoGruppoAllenamento.superset
      ? 'superset'
      : 'circuito';
  final label = etichetta?.trim() ?? '';
  if (label.isEmpty) {
    return '$base$_separatoreGruppo$token';
  }
  return '$base$_separatoreGruppo$token:$label';
}

String testoGruppoAllenamento(TipoGruppoAllenamento? tipo, String? etichetta) {
  if (tipo == null) return '';
  final base =
      tipo == TipoGruppoAllenamento.superset ? 'Superset' : 'Circuito';
  final label = etichetta?.trim() ?? '';
  return label.isEmpty ? base : '$base $label';
}
