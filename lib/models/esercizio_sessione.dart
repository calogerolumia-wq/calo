import 'scheda_remota.dart';

class EsercizioSessione {
  const EsercizioSessione({
    required this.esercizioId,
    required this.nome,
    this.descrizione,
    this.gruppoMuscolare,
    this.urlImmagine,
    required this.sezione,
    required this.ordineSezione,
    required this.ordineEsercizio,
    required this.serie,
    required this.ripetizioni,
    this.ripetizioniPiramidali,
    this.peso,
    this.durataMinuti,
    this.noteAllenatore,
    this.recuperoSecondi,
  });

  final int esercizioId;
  final String nome;
  final String? descrizione;
  final String? gruppoMuscolare;
  final String? urlImmagine;
  final String sezione;
  final int ordineSezione;
  final int ordineEsercizio;
  final int serie;
  final int ripetizioni;
  final String? ripetizioniPiramidali;
  final double? peso;
  final int? durataMinuti;
  final String? noteAllenatore;
  final int? recuperoSecondi;

  factory EsercizioSessione.fromRemoto(EsercizioInSchedaRemota e, int ordine) {
    final sezione = e.giorno == 0 ? 'Allenamento' : 'Giorno ${e.giorno}';
    return EsercizioSessione(
      esercizioId: e.esercizioId,
      nome: e.nomeEsercizio,
      descrizione: e.gruppoMuscolare,
      gruppoMuscolare: e.gruppoMuscolare,
      urlImmagine: e.immagineUrl,
      sezione: sezione,
      ordineSezione: e.giorno,
      ordineEsercizio: ordine,
      serie: e.serie,
      ripetizioni: e.ripetizioni,
      peso: e.pesoTarget,
    );
  }
}
