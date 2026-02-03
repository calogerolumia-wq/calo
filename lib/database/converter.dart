import 'package:drift/drift.dart';

enum Attrezzo {
  corpoLibero,
  manubri,
  bilanciere,
  macchina,
  kettlebell,
  elastici,
  cavo,
  altro,
}

enum GruppoMuscolare {
  spalle,
  avambracci,
  pettorali,
  bicipiti,
  tricipiti,
  addominali,
  quadricipiti,
  abduttori,
  dorsali,
  trapezi,
  femorali,
  glutei,
  polpacci,
  adduttori,
}

class AttrezzoConverter extends TypeConverter<Attrezzo, String> {
  const AttrezzoConverter();

  @override
  Attrezzo fromSql(String fromDb) =>
      Attrezzo.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(Attrezzo value) => value.name;
}

class GruppoMuscolareConverter extends TypeConverter<GruppoMuscolare, String> {
  const GruppoMuscolareConverter();

  @override
  GruppoMuscolare fromSql(String fromDb) =>
      GruppoMuscolare.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(GruppoMuscolare value) => value.name;
}

extension EtichetteAttrezzo on Attrezzo {
  String get etichetta {
    switch (this) {
      case Attrezzo.corpoLibero:
        return 'Corpo libero';
      case Attrezzo.manubri:
        return 'Manubri';
      case Attrezzo.bilanciere:
        return 'Bilanciere';
      case Attrezzo.macchina:
        return 'Macchina';
      case Attrezzo.kettlebell:
        return 'Kettlebell';
      case Attrezzo.elastici:
        return 'Elastici';
      case Attrezzo.cavo:
        return 'Cavo';
      case Attrezzo.altro:
        return 'Altro';
    }
  }
}

extension EtichetteGruppoMuscolare on GruppoMuscolare {
  String get etichetta {
    switch (this) {
      case GruppoMuscolare.spalle:
        return 'Spalle';
      case GruppoMuscolare.avambracci:
        return 'Avambracci';
      case GruppoMuscolare.pettorali:
        return 'Pettorali';
      case GruppoMuscolare.bicipiti:
        return 'Bicipiti';
      case GruppoMuscolare.tricipiti:
        return 'Tricipiti';
      case GruppoMuscolare.addominali:
        return 'Addominali';
      case GruppoMuscolare.quadricipiti:
        return 'Quadricipiti';
      case GruppoMuscolare.abduttori:
        return 'Abduttori';
      case GruppoMuscolare.dorsali:
        return 'Dorsali';
      case GruppoMuscolare.trapezi:
        return 'Trapezi';
      case GruppoMuscolare.femorali:
        return 'Femorali';
      case GruppoMuscolare.glutei:
        return 'Glutei';
      case GruppoMuscolare.polpacci:
        return 'Polpacci';
      case GruppoMuscolare.adduttori:
        return 'Adduttori';
    }
  }
}
