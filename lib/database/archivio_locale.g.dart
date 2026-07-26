// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archivio_locale.dart';

// ignore_for_file: type=lint
class $UtentiTable extends Utenti with TableInfo<$UtentiTable, UtentiData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UtentiTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, nome, email, username];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'utenti';
  @override
  VerificationContext validateIntegrity(Insertable<UtentiData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UtentiData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UtentiData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username']),
    );
  }

  @override
  $UtentiTable createAlias(String alias) {
    return $UtentiTable(attachedDatabase, alias);
  }
}

class UtentiData extends DataClass implements Insertable<UtentiData> {
  final int id;
  final String nome;
  final String? email;
  final String? username;
  const UtentiData(
      {required this.id, required this.nome, this.email, this.username});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    return map;
  }

  UtentiCompanion toCompanion(bool nullToAbsent) {
    return UtentiCompanion(
      id: Value(id),
      nome: Value(nome),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
    );
  }

  factory UtentiData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UtentiData(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      email: serializer.fromJson<String?>(json['email']),
      username: serializer.fromJson<String?>(json['username']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'email': serializer.toJson<String?>(email),
      'username': serializer.toJson<String?>(username),
    };
  }

  UtentiData copyWith(
          {int? id,
          String? nome,
          Value<String?> email = const Value.absent(),
          Value<String?> username = const Value.absent()}) =>
      UtentiData(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        email: email.present ? email.value : this.email,
        username: username.present ? username.value : this.username,
      );
  UtentiData copyWithCompanion(UtentiCompanion data) {
    return UtentiData(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      email: data.email.present ? data.email.value : this.email,
      username: data.username.present ? data.username.value : this.username,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UtentiData(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('email: $email, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, email, username);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UtentiData &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.email == this.email &&
          other.username == this.username);
}

class UtentiCompanion extends UpdateCompanion<UtentiData> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String?> email;
  final Value<String?> username;
  const UtentiCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.email = const Value.absent(),
    this.username = const Value.absent(),
  });
  UtentiCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.email = const Value.absent(),
    this.username = const Value.absent(),
  }) : nome = Value(nome);
  static Insertable<UtentiData> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? email,
    Expression<String>? username,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (email != null) 'email': email,
      if (username != null) 'username': username,
    });
  }

  UtentiCompanion copyWith(
      {Value<int>? id,
      Value<String>? nome,
      Value<String?>? email,
      Value<String?>? username}) {
    return UtentiCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UtentiCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('email: $email, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }
}

class $EserciziTable extends Esercizi
    with TableInfo<$EserciziTable, EserciziData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EserciziTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descrizioneMeta =
      const VerificationMeta('descrizione');
  @override
  late final GeneratedColumn<String> descrizione = GeneratedColumn<String>(
      'descrizione', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _muscoloObiettivoMeta =
      const VerificationMeta('muscoloObiettivo');
  @override
  late final GeneratedColumn<String> muscoloObiettivo = GeneratedColumn<String>(
      'muscoloTarget', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _attrezzoMeta =
      const VerificationMeta('attrezzo');
  @override
  late final GeneratedColumnWithTypeConverter<Attrezzo, String> attrezzo =
      GeneratedColumn<String>('attrezzo', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Attrezzo>($EserciziTable.$converterattrezzo);
  static const VerificationMeta _gruppoMuscolareMeta =
      const VerificationMeta('gruppoMuscolare');
  @override
  late final GeneratedColumnWithTypeConverter<GruppoMuscolare, String>
      gruppoMuscolare = GeneratedColumn<String>(
              'gruppo_muscolare', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<GruppoMuscolare>(
              $EserciziTable.$convertergruppoMuscolare);
  static const VerificationMeta _pesoObiettivoMeta =
      const VerificationMeta('pesoObiettivo');
  @override
  late final GeneratedColumn<double> pesoObiettivo = GeneratedColumn<double>(
      'pesoTarget', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _durataMinutiMeta =
      const VerificationMeta('durataMinuti');
  @override
  late final GeneratedColumn<int> durataMinuti = GeneratedColumn<int>(
      'durata_minuti', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _intensitaMeta =
      const VerificationMeta('intensita');
  @override
  late final GeneratedColumn<String> intensita = GeneratedColumn<String>(
      'intensita', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _obiettiviMeta =
      const VerificationMeta('obiettivi');
  @override
  late final GeneratedColumn<String> obiettivi = GeneratedColumn<String>(
      'obiettivi', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _urlImmagineMeta =
      const VerificationMeta('urlImmagine');
  @override
  late final GeneratedColumn<String> urlImmagine = GeneratedColumn<String>(
      'immagineUrl', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recuperoSecondiMeta =
      const VerificationMeta('recuperoSecondi');
  @override
  late final GeneratedColumn<int> recuperoSecondi = GeneratedColumn<int>(
      'recuperoSec', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nome,
        descrizione,
        muscoloObiettivo,
        attrezzo,
        gruppoMuscolare,
        pesoObiettivo,
        durataMinuti,
        intensita,
        obiettivi,
        urlImmagine,
        recuperoSecondi
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'esercizi';
  @override
  VerificationContext validateIntegrity(Insertable<EserciziData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('descrizione')) {
      context.handle(
          _descrizioneMeta,
          descrizione.isAcceptableOrUnknown(
              data['descrizione']!, _descrizioneMeta));
    }
    if (data.containsKey('muscoloTarget')) {
      context.handle(
          _muscoloObiettivoMeta,
          muscoloObiettivo.isAcceptableOrUnknown(
              data['muscoloTarget']!, _muscoloObiettivoMeta));
    }
    context.handle(_attrezzoMeta, const VerificationResult.success());
    context.handle(_gruppoMuscolareMeta, const VerificationResult.success());
    if (data.containsKey('pesoTarget')) {
      context.handle(
          _pesoObiettivoMeta,
          pesoObiettivo.isAcceptableOrUnknown(
              data['pesoTarget']!, _pesoObiettivoMeta));
    }
    if (data.containsKey('durata_minuti')) {
      context.handle(
          _durataMinutiMeta,
          durataMinuti.isAcceptableOrUnknown(
              data['durata_minuti']!, _durataMinutiMeta));
    }
    if (data.containsKey('intensita')) {
      context.handle(_intensitaMeta,
          intensita.isAcceptableOrUnknown(data['intensita']!, _intensitaMeta));
    }
    if (data.containsKey('obiettivi')) {
      context.handle(_obiettiviMeta,
          obiettivi.isAcceptableOrUnknown(data['obiettivi']!, _obiettiviMeta));
    }
    if (data.containsKey('immagineUrl')) {
      context.handle(
          _urlImmagineMeta,
          urlImmagine.isAcceptableOrUnknown(
              data['immagineUrl']!, _urlImmagineMeta));
    }
    if (data.containsKey('recuperoSec')) {
      context.handle(
          _recuperoSecondiMeta,
          recuperoSecondi.isAcceptableOrUnknown(
              data['recuperoSec']!, _recuperoSecondiMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EserciziData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EserciziData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      descrizione: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descrizione']),
      muscoloObiettivo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}muscoloTarget']),
      attrezzo: $EserciziTable.$converterattrezzo.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attrezzo'])!),
      gruppoMuscolare: $EserciziTable.$convertergruppoMuscolare.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}gruppo_muscolare'])!),
      pesoObiettivo: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}pesoTarget']),
      durataMinuti: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}durata_minuti']),
      intensita: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}intensita']),
      obiettivi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}obiettivi']),
      urlImmagine: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}immagineUrl']),
      recuperoSecondi: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recuperoSec']),
    );
  }

  @override
  $EserciziTable createAlias(String alias) {
    return $EserciziTable(attachedDatabase, alias);
  }

  static TypeConverter<Attrezzo, String> $converterattrezzo =
      const AttrezzoConverter();
  static TypeConverter<GruppoMuscolare, String> $convertergruppoMuscolare =
      const GruppoMuscolareConverter();
}

class EserciziData extends DataClass implements Insertable<EserciziData> {
  final int id;
  final String nome;
  final String? descrizione;
  final String? muscoloObiettivo;
  final Attrezzo attrezzo;
  final GruppoMuscolare gruppoMuscolare;
  final double? pesoObiettivo;
  final int? durataMinuti;
  final String? intensita;
  final String? obiettivi;
  final String? urlImmagine;
  final int? recuperoSecondi;
  const EserciziData(
      {required this.id,
      required this.nome,
      this.descrizione,
      this.muscoloObiettivo,
      required this.attrezzo,
      required this.gruppoMuscolare,
      this.pesoObiettivo,
      this.durataMinuti,
      this.intensita,
      this.obiettivi,
      this.urlImmagine,
      this.recuperoSecondi});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || descrizione != null) {
      map['descrizione'] = Variable<String>(descrizione);
    }
    if (!nullToAbsent || muscoloObiettivo != null) {
      map['muscoloTarget'] = Variable<String>(muscoloObiettivo);
    }
    {
      map['attrezzo'] =
          Variable<String>($EserciziTable.$converterattrezzo.toSql(attrezzo));
    }
    {
      map['gruppo_muscolare'] = Variable<String>(
          $EserciziTable.$convertergruppoMuscolare.toSql(gruppoMuscolare));
    }
    if (!nullToAbsent || pesoObiettivo != null) {
      map['pesoTarget'] = Variable<double>(pesoObiettivo);
    }
    if (!nullToAbsent || durataMinuti != null) {
      map['durata_minuti'] = Variable<int>(durataMinuti);
    }
    if (!nullToAbsent || intensita != null) {
      map['intensita'] = Variable<String>(intensita);
    }
    if (!nullToAbsent || obiettivi != null) {
      map['obiettivi'] = Variable<String>(obiettivi);
    }
    if (!nullToAbsent || urlImmagine != null) {
      map['immagineUrl'] = Variable<String>(urlImmagine);
    }
    if (!nullToAbsent || recuperoSecondi != null) {
      map['recuperoSec'] = Variable<int>(recuperoSecondi);
    }
    return map;
  }

  EserciziCompanion toCompanion(bool nullToAbsent) {
    return EserciziCompanion(
      id: Value(id),
      nome: Value(nome),
      descrizione: descrizione == null && nullToAbsent
          ? const Value.absent()
          : Value(descrizione),
      muscoloObiettivo: muscoloObiettivo == null && nullToAbsent
          ? const Value.absent()
          : Value(muscoloObiettivo),
      attrezzo: Value(attrezzo),
      gruppoMuscolare: Value(gruppoMuscolare),
      pesoObiettivo: pesoObiettivo == null && nullToAbsent
          ? const Value.absent()
          : Value(pesoObiettivo),
      durataMinuti: durataMinuti == null && nullToAbsent
          ? const Value.absent()
          : Value(durataMinuti),
      intensita: intensita == null && nullToAbsent
          ? const Value.absent()
          : Value(intensita),
      obiettivi: obiettivi == null && nullToAbsent
          ? const Value.absent()
          : Value(obiettivi),
      urlImmagine: urlImmagine == null && nullToAbsent
          ? const Value.absent()
          : Value(urlImmagine),
      recuperoSecondi: recuperoSecondi == null && nullToAbsent
          ? const Value.absent()
          : Value(recuperoSecondi),
    );
  }

  factory EserciziData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EserciziData(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      descrizione: serializer.fromJson<String?>(json['descrizione']),
      muscoloObiettivo: serializer.fromJson<String?>(json['muscoloObiettivo']),
      attrezzo: serializer.fromJson<Attrezzo>(json['attrezzo']),
      gruppoMuscolare:
          serializer.fromJson<GruppoMuscolare>(json['gruppoMuscolare']),
      pesoObiettivo: serializer.fromJson<double?>(json['pesoObiettivo']),
      durataMinuti: serializer.fromJson<int?>(json['durataMinuti']),
      intensita: serializer.fromJson<String?>(json['intensita']),
      obiettivi: serializer.fromJson<String?>(json['obiettivi']),
      urlImmagine: serializer.fromJson<String?>(json['urlImmagine']),
      recuperoSecondi: serializer.fromJson<int?>(json['recuperoSecondi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'descrizione': serializer.toJson<String?>(descrizione),
      'muscoloObiettivo': serializer.toJson<String?>(muscoloObiettivo),
      'attrezzo': serializer.toJson<Attrezzo>(attrezzo),
      'gruppoMuscolare': serializer.toJson<GruppoMuscolare>(gruppoMuscolare),
      'pesoObiettivo': serializer.toJson<double?>(pesoObiettivo),
      'durataMinuti': serializer.toJson<int?>(durataMinuti),
      'intensita': serializer.toJson<String?>(intensita),
      'obiettivi': serializer.toJson<String?>(obiettivi),
      'urlImmagine': serializer.toJson<String?>(urlImmagine),
      'recuperoSecondi': serializer.toJson<int?>(recuperoSecondi),
    };
  }

  EserciziData copyWith(
          {int? id,
          String? nome,
          Value<String?> descrizione = const Value.absent(),
          Value<String?> muscoloObiettivo = const Value.absent(),
          Attrezzo? attrezzo,
          GruppoMuscolare? gruppoMuscolare,
          Value<double?> pesoObiettivo = const Value.absent(),
          Value<int?> durataMinuti = const Value.absent(),
          Value<String?> intensita = const Value.absent(),
          Value<String?> obiettivi = const Value.absent(),
          Value<String?> urlImmagine = const Value.absent(),
          Value<int?> recuperoSecondi = const Value.absent()}) =>
      EserciziData(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        descrizione: descrizione.present ? descrizione.value : this.descrizione,
        muscoloObiettivo: muscoloObiettivo.present
            ? muscoloObiettivo.value
            : this.muscoloObiettivo,
        attrezzo: attrezzo ?? this.attrezzo,
        gruppoMuscolare: gruppoMuscolare ?? this.gruppoMuscolare,
        pesoObiettivo:
            pesoObiettivo.present ? pesoObiettivo.value : this.pesoObiettivo,
        durataMinuti:
            durataMinuti.present ? durataMinuti.value : this.durataMinuti,
        intensita: intensita.present ? intensita.value : this.intensita,
        obiettivi: obiettivi.present ? obiettivi.value : this.obiettivi,
        urlImmagine: urlImmagine.present ? urlImmagine.value : this.urlImmagine,
        recuperoSecondi: recuperoSecondi.present
            ? recuperoSecondi.value
            : this.recuperoSecondi,
      );
  EserciziData copyWithCompanion(EserciziCompanion data) {
    return EserciziData(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      descrizione:
          data.descrizione.present ? data.descrizione.value : this.descrizione,
      muscoloObiettivo: data.muscoloObiettivo.present
          ? data.muscoloObiettivo.value
          : this.muscoloObiettivo,
      attrezzo: data.attrezzo.present ? data.attrezzo.value : this.attrezzo,
      gruppoMuscolare: data.gruppoMuscolare.present
          ? data.gruppoMuscolare.value
          : this.gruppoMuscolare,
      pesoObiettivo: data.pesoObiettivo.present
          ? data.pesoObiettivo.value
          : this.pesoObiettivo,
      durataMinuti: data.durataMinuti.present
          ? data.durataMinuti.value
          : this.durataMinuti,
      intensita: data.intensita.present ? data.intensita.value : this.intensita,
      obiettivi: data.obiettivi.present ? data.obiettivi.value : this.obiettivi,
      urlImmagine:
          data.urlImmagine.present ? data.urlImmagine.value : this.urlImmagine,
      recuperoSecondi: data.recuperoSecondi.present
          ? data.recuperoSecondi.value
          : this.recuperoSecondi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EserciziData(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('descrizione: $descrizione, ')
          ..write('muscoloObiettivo: $muscoloObiettivo, ')
          ..write('attrezzo: $attrezzo, ')
          ..write('gruppoMuscolare: $gruppoMuscolare, ')
          ..write('pesoObiettivo: $pesoObiettivo, ')
          ..write('durataMinuti: $durataMinuti, ')
          ..write('intensita: $intensita, ')
          ..write('obiettivi: $obiettivi, ')
          ..write('urlImmagine: $urlImmagine, ')
          ..write('recuperoSecondi: $recuperoSecondi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      nome,
      descrizione,
      muscoloObiettivo,
      attrezzo,
      gruppoMuscolare,
      pesoObiettivo,
      durataMinuti,
      intensita,
      obiettivi,
      urlImmagine,
      recuperoSecondi);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EserciziData &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.descrizione == this.descrizione &&
          other.muscoloObiettivo == this.muscoloObiettivo &&
          other.attrezzo == this.attrezzo &&
          other.gruppoMuscolare == this.gruppoMuscolare &&
          other.pesoObiettivo == this.pesoObiettivo &&
          other.durataMinuti == this.durataMinuti &&
          other.intensita == this.intensita &&
          other.obiettivi == this.obiettivi &&
          other.urlImmagine == this.urlImmagine &&
          other.recuperoSecondi == this.recuperoSecondi);
}

class EserciziCompanion extends UpdateCompanion<EserciziData> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String?> descrizione;
  final Value<String?> muscoloObiettivo;
  final Value<Attrezzo> attrezzo;
  final Value<GruppoMuscolare> gruppoMuscolare;
  final Value<double?> pesoObiettivo;
  final Value<int?> durataMinuti;
  final Value<String?> intensita;
  final Value<String?> obiettivi;
  final Value<String?> urlImmagine;
  final Value<int?> recuperoSecondi;
  const EserciziCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.descrizione = const Value.absent(),
    this.muscoloObiettivo = const Value.absent(),
    this.attrezzo = const Value.absent(),
    this.gruppoMuscolare = const Value.absent(),
    this.pesoObiettivo = const Value.absent(),
    this.durataMinuti = const Value.absent(),
    this.intensita = const Value.absent(),
    this.obiettivi = const Value.absent(),
    this.urlImmagine = const Value.absent(),
    this.recuperoSecondi = const Value.absent(),
  });
  EserciziCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.descrizione = const Value.absent(),
    this.muscoloObiettivo = const Value.absent(),
    required Attrezzo attrezzo,
    required GruppoMuscolare gruppoMuscolare,
    this.pesoObiettivo = const Value.absent(),
    this.durataMinuti = const Value.absent(),
    this.intensita = const Value.absent(),
    this.obiettivi = const Value.absent(),
    this.urlImmagine = const Value.absent(),
    this.recuperoSecondi = const Value.absent(),
  })  : nome = Value(nome),
        attrezzo = Value(attrezzo),
        gruppoMuscolare = Value(gruppoMuscolare);
  static Insertable<EserciziData> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? descrizione,
    Expression<String>? muscoloObiettivo,
    Expression<String>? attrezzo,
    Expression<String>? gruppoMuscolare,
    Expression<double>? pesoObiettivo,
    Expression<int>? durataMinuti,
    Expression<String>? intensita,
    Expression<String>? obiettivi,
    Expression<String>? urlImmagine,
    Expression<int>? recuperoSecondi,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (descrizione != null) 'descrizione': descrizione,
      if (muscoloObiettivo != null) 'muscoloTarget': muscoloObiettivo,
      if (attrezzo != null) 'attrezzo': attrezzo,
      if (gruppoMuscolare != null) 'gruppo_muscolare': gruppoMuscolare,
      if (pesoObiettivo != null) 'pesoTarget': pesoObiettivo,
      if (durataMinuti != null) 'durata_minuti': durataMinuti,
      if (intensita != null) 'intensita': intensita,
      if (obiettivi != null) 'obiettivi': obiettivi,
      if (urlImmagine != null) 'immagineUrl': urlImmagine,
      if (recuperoSecondi != null) 'recuperoSec': recuperoSecondi,
    });
  }

  EserciziCompanion copyWith(
      {Value<int>? id,
      Value<String>? nome,
      Value<String?>? descrizione,
      Value<String?>? muscoloObiettivo,
      Value<Attrezzo>? attrezzo,
      Value<GruppoMuscolare>? gruppoMuscolare,
      Value<double?>? pesoObiettivo,
      Value<int?>? durataMinuti,
      Value<String?>? intensita,
      Value<String?>? obiettivi,
      Value<String?>? urlImmagine,
      Value<int?>? recuperoSecondi}) {
    return EserciziCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descrizione: descrizione ?? this.descrizione,
      muscoloObiettivo: muscoloObiettivo ?? this.muscoloObiettivo,
      attrezzo: attrezzo ?? this.attrezzo,
      gruppoMuscolare: gruppoMuscolare ?? this.gruppoMuscolare,
      pesoObiettivo: pesoObiettivo ?? this.pesoObiettivo,
      durataMinuti: durataMinuti ?? this.durataMinuti,
      intensita: intensita ?? this.intensita,
      obiettivi: obiettivi ?? this.obiettivi,
      urlImmagine: urlImmagine ?? this.urlImmagine,
      recuperoSecondi: recuperoSecondi ?? this.recuperoSecondi,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (descrizione.present) {
      map['descrizione'] = Variable<String>(descrizione.value);
    }
    if (muscoloObiettivo.present) {
      map['muscoloTarget'] = Variable<String>(muscoloObiettivo.value);
    }
    if (attrezzo.present) {
      map['attrezzo'] = Variable<String>(
          $EserciziTable.$converterattrezzo.toSql(attrezzo.value));
    }
    if (gruppoMuscolare.present) {
      map['gruppo_muscolare'] = Variable<String>($EserciziTable
          .$convertergruppoMuscolare
          .toSql(gruppoMuscolare.value));
    }
    if (pesoObiettivo.present) {
      map['pesoTarget'] = Variable<double>(pesoObiettivo.value);
    }
    if (durataMinuti.present) {
      map['durata_minuti'] = Variable<int>(durataMinuti.value);
    }
    if (intensita.present) {
      map['intensita'] = Variable<String>(intensita.value);
    }
    if (obiettivi.present) {
      map['obiettivi'] = Variable<String>(obiettivi.value);
    }
    if (urlImmagine.present) {
      map['immagineUrl'] = Variable<String>(urlImmagine.value);
    }
    if (recuperoSecondi.present) {
      map['recuperoSec'] = Variable<int>(recuperoSecondi.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EserciziCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('descrizione: $descrizione, ')
          ..write('muscoloObiettivo: $muscoloObiettivo, ')
          ..write('attrezzo: $attrezzo, ')
          ..write('gruppoMuscolare: $gruppoMuscolare, ')
          ..write('pesoObiettivo: $pesoObiettivo, ')
          ..write('durataMinuti: $durataMinuti, ')
          ..write('intensita: $intensita, ')
          ..write('obiettivi: $obiettivi, ')
          ..write('urlImmagine: $urlImmagine, ')
          ..write('recuperoSecondi: $recuperoSecondi')
          ..write(')'))
        .toString();
  }
}

class $SchedeTable extends Schede with TableInfo<$SchedeTable, SchedeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchedeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomeSchedaMeta =
      const VerificationMeta('nomeScheda');
  @override
  late final GeneratedColumn<String> nomeScheda = GeneratedColumn<String>(
      'nome_scheda', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descrizioneMeta =
      const VerificationMeta('descrizione');
  @override
  late final GeneratedColumn<String> descrizione = GeneratedColumn<String>(
      'descrizione', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _livelloDifficoltaMeta =
      const VerificationMeta('livelloDifficolta');
  @override
  late final GeneratedColumn<String> livelloDifficolta =
      GeneratedColumn<String>('livello_difficolta', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _utenteIdMeta =
      const VerificationMeta('utenteId');
  @override
  late final GeneratedColumn<int> utenteId = GeneratedColumn<int>(
      'utente_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES utenti (id)'));
  static const VerificationMeta _modelloMeta =
      const VerificationMeta('modello');
  @override
  late final GeneratedColumn<bool> modello = GeneratedColumn<bool>(
      'template', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("template" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _attivaMeta = const VerificationMeta('attiva');
  @override
  late final GeneratedColumn<bool> attiva = GeneratedColumn<bool>(
      'attiva', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("attiva" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _dataAssegnazioneMeta =
      const VerificationMeta('dataAssegnazione');
  @override
  late final GeneratedColumn<DateTime> dataAssegnazione =
      GeneratedColumn<DateTime>('data_assegnazione', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _dataFineMeta =
      const VerificationMeta('dataFine');
  @override
  late final GeneratedColumn<DateTime> dataFine = GeneratedColumn<DateTime>(
      'data_fine', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _noteAllenatoreMeta =
      const VerificationMeta('noteAllenatore');
  @override
  late final GeneratedColumn<String> noteAllenatore = GeneratedColumn<String>(
      'note_allenatore', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nomeScheda,
        descrizione,
        livelloDifficolta,
        utenteId,
        modello,
        attiva,
        dataAssegnazione,
        dataFine,
        noteAllenatore
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schede';
  @override
  VerificationContext validateIntegrity(Insertable<SchedeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome_scheda')) {
      context.handle(
          _nomeSchedaMeta,
          nomeScheda.isAcceptableOrUnknown(
              data['nome_scheda']!, _nomeSchedaMeta));
    } else if (isInserting) {
      context.missing(_nomeSchedaMeta);
    }
    if (data.containsKey('descrizione')) {
      context.handle(
          _descrizioneMeta,
          descrizione.isAcceptableOrUnknown(
              data['descrizione']!, _descrizioneMeta));
    }
    if (data.containsKey('livello_difficolta')) {
      context.handle(
          _livelloDifficoltaMeta,
          livelloDifficolta.isAcceptableOrUnknown(
              data['livello_difficolta']!, _livelloDifficoltaMeta));
    }
    if (data.containsKey('utente_id')) {
      context.handle(_utenteIdMeta,
          utenteId.isAcceptableOrUnknown(data['utente_id']!, _utenteIdMeta));
    } else if (isInserting) {
      context.missing(_utenteIdMeta);
    }
    if (data.containsKey('template')) {
      context.handle(_modelloMeta,
          modello.isAcceptableOrUnknown(data['template']!, _modelloMeta));
    }
    if (data.containsKey('attiva')) {
      context.handle(_attivaMeta,
          attiva.isAcceptableOrUnknown(data['attiva']!, _attivaMeta));
    }
    if (data.containsKey('data_assegnazione')) {
      context.handle(
          _dataAssegnazioneMeta,
          dataAssegnazione.isAcceptableOrUnknown(
              data['data_assegnazione']!, _dataAssegnazioneMeta));
    }
    if (data.containsKey('data_fine')) {
      context.handle(_dataFineMeta,
          dataFine.isAcceptableOrUnknown(data['data_fine']!, _dataFineMeta));
    }
    if (data.containsKey('note_allenatore')) {
      context.handle(
          _noteAllenatoreMeta,
          noteAllenatore.isAcceptableOrUnknown(
              data['note_allenatore']!, _noteAllenatoreMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SchedeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchedeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nomeScheda: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome_scheda'])!,
      descrizione: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descrizione']),
      livelloDifficolta: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}livello_difficolta']),
      utenteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}utente_id'])!,
      modello: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}template'])!,
      attiva: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}attiva'])!,
      dataAssegnazione: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}data_assegnazione']),
      dataFine: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_fine']),
      noteAllenatore: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_allenatore']),
    );
  }

  @override
  $SchedeTable createAlias(String alias) {
    return $SchedeTable(attachedDatabase, alias);
  }
}

class SchedeData extends DataClass implements Insertable<SchedeData> {
  final int id;
  final String nomeScheda;
  final String? descrizione;
  final String? livelloDifficolta;
  final int utenteId;
  final bool modello;
  final bool attiva;
  final DateTime? dataAssegnazione;
  final DateTime? dataFine;
  final String? noteAllenatore;
  const SchedeData(
      {required this.id,
      required this.nomeScheda,
      this.descrizione,
      this.livelloDifficolta,
      required this.utenteId,
      required this.modello,
      required this.attiva,
      this.dataAssegnazione,
      this.dataFine,
      this.noteAllenatore});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome_scheda'] = Variable<String>(nomeScheda);
    if (!nullToAbsent || descrizione != null) {
      map['descrizione'] = Variable<String>(descrizione);
    }
    if (!nullToAbsent || livelloDifficolta != null) {
      map['livello_difficolta'] = Variable<String>(livelloDifficolta);
    }
    map['utente_id'] = Variable<int>(utenteId);
    map['template'] = Variable<bool>(modello);
    map['attiva'] = Variable<bool>(attiva);
    if (!nullToAbsent || dataAssegnazione != null) {
      map['data_assegnazione'] = Variable<DateTime>(dataAssegnazione);
    }
    if (!nullToAbsent || dataFine != null) {
      map['data_fine'] = Variable<DateTime>(dataFine);
    }
    if (!nullToAbsent || noteAllenatore != null) {
      map['note_allenatore'] = Variable<String>(noteAllenatore);
    }
    return map;
  }

  SchedeCompanion toCompanion(bool nullToAbsent) {
    return SchedeCompanion(
      id: Value(id),
      nomeScheda: Value(nomeScheda),
      descrizione: descrizione == null && nullToAbsent
          ? const Value.absent()
          : Value(descrizione),
      livelloDifficolta: livelloDifficolta == null && nullToAbsent
          ? const Value.absent()
          : Value(livelloDifficolta),
      utenteId: Value(utenteId),
      modello: Value(modello),
      attiva: Value(attiva),
      dataAssegnazione: dataAssegnazione == null && nullToAbsent
          ? const Value.absent()
          : Value(dataAssegnazione),
      dataFine: dataFine == null && nullToAbsent
          ? const Value.absent()
          : Value(dataFine),
      noteAllenatore: noteAllenatore == null && nullToAbsent
          ? const Value.absent()
          : Value(noteAllenatore),
    );
  }

  factory SchedeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchedeData(
      id: serializer.fromJson<int>(json['id']),
      nomeScheda: serializer.fromJson<String>(json['nomeScheda']),
      descrizione: serializer.fromJson<String?>(json['descrizione']),
      livelloDifficolta:
          serializer.fromJson<String?>(json['livelloDifficolta']),
      utenteId: serializer.fromJson<int>(json['utenteId']),
      modello: serializer.fromJson<bool>(json['modello']),
      attiva: serializer.fromJson<bool>(json['attiva']),
      dataAssegnazione:
          serializer.fromJson<DateTime?>(json['dataAssegnazione']),
      dataFine: serializer.fromJson<DateTime?>(json['dataFine']),
      noteAllenatore: serializer.fromJson<String?>(json['noteAllenatore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nomeScheda': serializer.toJson<String>(nomeScheda),
      'descrizione': serializer.toJson<String?>(descrizione),
      'livelloDifficolta': serializer.toJson<String?>(livelloDifficolta),
      'utenteId': serializer.toJson<int>(utenteId),
      'modello': serializer.toJson<bool>(modello),
      'attiva': serializer.toJson<bool>(attiva),
      'dataAssegnazione': serializer.toJson<DateTime?>(dataAssegnazione),
      'dataFine': serializer.toJson<DateTime?>(dataFine),
      'noteAllenatore': serializer.toJson<String?>(noteAllenatore),
    };
  }

  SchedeData copyWith(
          {int? id,
          String? nomeScheda,
          Value<String?> descrizione = const Value.absent(),
          Value<String?> livelloDifficolta = const Value.absent(),
          int? utenteId,
          bool? modello,
          bool? attiva,
          Value<DateTime?> dataAssegnazione = const Value.absent(),
          Value<DateTime?> dataFine = const Value.absent(),
          Value<String?> noteAllenatore = const Value.absent()}) =>
      SchedeData(
        id: id ?? this.id,
        nomeScheda: nomeScheda ?? this.nomeScheda,
        descrizione: descrizione.present ? descrizione.value : this.descrizione,
        livelloDifficolta: livelloDifficolta.present
            ? livelloDifficolta.value
            : this.livelloDifficolta,
        utenteId: utenteId ?? this.utenteId,
        modello: modello ?? this.modello,
        attiva: attiva ?? this.attiva,
        dataAssegnazione: dataAssegnazione.present
            ? dataAssegnazione.value
            : this.dataAssegnazione,
        dataFine: dataFine.present ? dataFine.value : this.dataFine,
        noteAllenatore:
            noteAllenatore.present ? noteAllenatore.value : this.noteAllenatore,
      );
  SchedeData copyWithCompanion(SchedeCompanion data) {
    return SchedeData(
      id: data.id.present ? data.id.value : this.id,
      nomeScheda:
          data.nomeScheda.present ? data.nomeScheda.value : this.nomeScheda,
      descrizione:
          data.descrizione.present ? data.descrizione.value : this.descrizione,
      livelloDifficolta: data.livelloDifficolta.present
          ? data.livelloDifficolta.value
          : this.livelloDifficolta,
      utenteId: data.utenteId.present ? data.utenteId.value : this.utenteId,
      modello: data.modello.present ? data.modello.value : this.modello,
      attiva: data.attiva.present ? data.attiva.value : this.attiva,
      dataAssegnazione: data.dataAssegnazione.present
          ? data.dataAssegnazione.value
          : this.dataAssegnazione,
      dataFine: data.dataFine.present ? data.dataFine.value : this.dataFine,
      noteAllenatore: data.noteAllenatore.present
          ? data.noteAllenatore.value
          : this.noteAllenatore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchedeData(')
          ..write('id: $id, ')
          ..write('nomeScheda: $nomeScheda, ')
          ..write('descrizione: $descrizione, ')
          ..write('livelloDifficolta: $livelloDifficolta, ')
          ..write('utenteId: $utenteId, ')
          ..write('modello: $modello, ')
          ..write('attiva: $attiva, ')
          ..write('dataAssegnazione: $dataAssegnazione, ')
          ..write('dataFine: $dataFine, ')
          ..write('noteAllenatore: $noteAllenatore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      nomeScheda,
      descrizione,
      livelloDifficolta,
      utenteId,
      modello,
      attiva,
      dataAssegnazione,
      dataFine,
      noteAllenatore);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchedeData &&
          other.id == this.id &&
          other.nomeScheda == this.nomeScheda &&
          other.descrizione == this.descrizione &&
          other.livelloDifficolta == this.livelloDifficolta &&
          other.utenteId == this.utenteId &&
          other.modello == this.modello &&
          other.attiva == this.attiva &&
          other.dataAssegnazione == this.dataAssegnazione &&
          other.dataFine == this.dataFine &&
          other.noteAllenatore == this.noteAllenatore);
}

class SchedeCompanion extends UpdateCompanion<SchedeData> {
  final Value<int> id;
  final Value<String> nomeScheda;
  final Value<String?> descrizione;
  final Value<String?> livelloDifficolta;
  final Value<int> utenteId;
  final Value<bool> modello;
  final Value<bool> attiva;
  final Value<DateTime?> dataAssegnazione;
  final Value<DateTime?> dataFine;
  final Value<String?> noteAllenatore;
  const SchedeCompanion({
    this.id = const Value.absent(),
    this.nomeScheda = const Value.absent(),
    this.descrizione = const Value.absent(),
    this.livelloDifficolta = const Value.absent(),
    this.utenteId = const Value.absent(),
    this.modello = const Value.absent(),
    this.attiva = const Value.absent(),
    this.dataAssegnazione = const Value.absent(),
    this.dataFine = const Value.absent(),
    this.noteAllenatore = const Value.absent(),
  });
  SchedeCompanion.insert({
    this.id = const Value.absent(),
    required String nomeScheda,
    this.descrizione = const Value.absent(),
    this.livelloDifficolta = const Value.absent(),
    required int utenteId,
    this.modello = const Value.absent(),
    this.attiva = const Value.absent(),
    this.dataAssegnazione = const Value.absent(),
    this.dataFine = const Value.absent(),
    this.noteAllenatore = const Value.absent(),
  })  : nomeScheda = Value(nomeScheda),
        utenteId = Value(utenteId);
  static Insertable<SchedeData> custom({
    Expression<int>? id,
    Expression<String>? nomeScheda,
    Expression<String>? descrizione,
    Expression<String>? livelloDifficolta,
    Expression<int>? utenteId,
    Expression<bool>? modello,
    Expression<bool>? attiva,
    Expression<DateTime>? dataAssegnazione,
    Expression<DateTime>? dataFine,
    Expression<String>? noteAllenatore,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nomeScheda != null) 'nome_scheda': nomeScheda,
      if (descrizione != null) 'descrizione': descrizione,
      if (livelloDifficolta != null) 'livello_difficolta': livelloDifficolta,
      if (utenteId != null) 'utente_id': utenteId,
      if (modello != null) 'template': modello,
      if (attiva != null) 'attiva': attiva,
      if (dataAssegnazione != null) 'data_assegnazione': dataAssegnazione,
      if (dataFine != null) 'data_fine': dataFine,
      if (noteAllenatore != null) 'note_allenatore': noteAllenatore,
    });
  }

  SchedeCompanion copyWith(
      {Value<int>? id,
      Value<String>? nomeScheda,
      Value<String?>? descrizione,
      Value<String?>? livelloDifficolta,
      Value<int>? utenteId,
      Value<bool>? modello,
      Value<bool>? attiva,
      Value<DateTime?>? dataAssegnazione,
      Value<DateTime?>? dataFine,
      Value<String?>? noteAllenatore}) {
    return SchedeCompanion(
      id: id ?? this.id,
      nomeScheda: nomeScheda ?? this.nomeScheda,
      descrizione: descrizione ?? this.descrizione,
      livelloDifficolta: livelloDifficolta ?? this.livelloDifficolta,
      utenteId: utenteId ?? this.utenteId,
      modello: modello ?? this.modello,
      attiva: attiva ?? this.attiva,
      dataAssegnazione: dataAssegnazione ?? this.dataAssegnazione,
      dataFine: dataFine ?? this.dataFine,
      noteAllenatore: noteAllenatore ?? this.noteAllenatore,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nomeScheda.present) {
      map['nome_scheda'] = Variable<String>(nomeScheda.value);
    }
    if (descrizione.present) {
      map['descrizione'] = Variable<String>(descrizione.value);
    }
    if (livelloDifficolta.present) {
      map['livello_difficolta'] = Variable<String>(livelloDifficolta.value);
    }
    if (utenteId.present) {
      map['utente_id'] = Variable<int>(utenteId.value);
    }
    if (modello.present) {
      map['template'] = Variable<bool>(modello.value);
    }
    if (attiva.present) {
      map['attiva'] = Variable<bool>(attiva.value);
    }
    if (dataAssegnazione.present) {
      map['data_assegnazione'] = Variable<DateTime>(dataAssegnazione.value);
    }
    if (dataFine.present) {
      map['data_fine'] = Variable<DateTime>(dataFine.value);
    }
    if (noteAllenatore.present) {
      map['note_allenatore'] = Variable<String>(noteAllenatore.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchedeCompanion(')
          ..write('id: $id, ')
          ..write('nomeScheda: $nomeScheda, ')
          ..write('descrizione: $descrizione, ')
          ..write('livelloDifficolta: $livelloDifficolta, ')
          ..write('utenteId: $utenteId, ')
          ..write('modello: $modello, ')
          ..write('attiva: $attiva, ')
          ..write('dataAssegnazione: $dataAssegnazione, ')
          ..write('dataFine: $dataFine, ')
          ..write('noteAllenatore: $noteAllenatore')
          ..write(')'))
        .toString();
  }
}

class $SchedeEserciziTable extends SchedeEsercizi
    with TableInfo<$SchedeEserciziTable, SchedeEserciziData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchedeEserciziTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _schedaIdMeta =
      const VerificationMeta('schedaId');
  @override
  late final GeneratedColumn<int> schedaId = GeneratedColumn<int>(
      'scheda_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES schede (id)'));
  static const VerificationMeta _esercizioIdMeta =
      const VerificationMeta('esercizioId');
  @override
  late final GeneratedColumn<int> esercizioId = GeneratedColumn<int>(
      'esercizio_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES esercizi (id)'));
  static const VerificationMeta _sezioneMeta =
      const VerificationMeta('sezione');
  @override
  late final GeneratedColumn<String> sezione = GeneratedColumn<String>(
      'sezione', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Allenamento'));
  static const VerificationMeta _ordineSezioneMeta =
      const VerificationMeta('ordineSezione');
  @override
  late final GeneratedColumn<int> ordineSezione = GeneratedColumn<int>(
      'ordine_sezione', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _ordineEsercizioMeta =
      const VerificationMeta('ordineEsercizio');
  @override
  late final GeneratedColumn<int> ordineEsercizio = GeneratedColumn<int>(
      'ordine_esercizio', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _serieMeta = const VerificationMeta('serie');
  @override
  late final GeneratedColumn<int> serie = GeneratedColumn<int>(
      'serie', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _ripetizioniMeta =
      const VerificationMeta('ripetizioni');
  @override
  late final GeneratedColumn<int> ripetizioni = GeneratedColumn<int>(
      'ripetizioni', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  static const VerificationMeta _ripetizioniPiramidaliMeta =
      const VerificationMeta('ripetizioniPiramidali');
  @override
  late final GeneratedColumn<String> ripetizioniPiramidali =
      GeneratedColumn<String>('repsPyramid', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pesoMeta = const VerificationMeta('peso');
  @override
  late final GeneratedColumn<double> peso = GeneratedColumn<double>(
      'peso', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _durataMinutiMeta =
      const VerificationMeta('durataMinuti');
  @override
  late final GeneratedColumn<int> durataMinuti = GeneratedColumn<int>(
      'durata_minuti', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _noteAllenatoreMeta =
      const VerificationMeta('noteAllenatore');
  @override
  late final GeneratedColumn<String> noteAllenatore = GeneratedColumn<String>(
      'note_allenatore', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        schedaId,
        esercizioId,
        sezione,
        ordineSezione,
        ordineEsercizio,
        serie,
        ripetizioni,
        ripetizioniPiramidali,
        peso,
        durataMinuti,
        noteAllenatore
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schede_esercizi';
  @override
  VerificationContext validateIntegrity(Insertable<SchedeEserciziData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('scheda_id')) {
      context.handle(_schedaIdMeta,
          schedaId.isAcceptableOrUnknown(data['scheda_id']!, _schedaIdMeta));
    } else if (isInserting) {
      context.missing(_schedaIdMeta);
    }
    if (data.containsKey('esercizio_id')) {
      context.handle(
          _esercizioIdMeta,
          esercizioId.isAcceptableOrUnknown(
              data['esercizio_id']!, _esercizioIdMeta));
    } else if (isInserting) {
      context.missing(_esercizioIdMeta);
    }
    if (data.containsKey('sezione')) {
      context.handle(_sezioneMeta,
          sezione.isAcceptableOrUnknown(data['sezione']!, _sezioneMeta));
    }
    if (data.containsKey('ordine_sezione')) {
      context.handle(
          _ordineSezioneMeta,
          ordineSezione.isAcceptableOrUnknown(
              data['ordine_sezione']!, _ordineSezioneMeta));
    }
    if (data.containsKey('ordine_esercizio')) {
      context.handle(
          _ordineEsercizioMeta,
          ordineEsercizio.isAcceptableOrUnknown(
              data['ordine_esercizio']!, _ordineEsercizioMeta));
    }
    if (data.containsKey('serie')) {
      context.handle(
          _serieMeta, serie.isAcceptableOrUnknown(data['serie']!, _serieMeta));
    }
    if (data.containsKey('ripetizioni')) {
      context.handle(
          _ripetizioniMeta,
          ripetizioni.isAcceptableOrUnknown(
              data['ripetizioni']!, _ripetizioniMeta));
    }
    if (data.containsKey('repsPyramid')) {
      context.handle(
          _ripetizioniPiramidaliMeta,
          ripetizioniPiramidali.isAcceptableOrUnknown(
              data['repsPyramid']!, _ripetizioniPiramidaliMeta));
    }
    if (data.containsKey('peso')) {
      context.handle(
          _pesoMeta, peso.isAcceptableOrUnknown(data['peso']!, _pesoMeta));
    }
    if (data.containsKey('durata_minuti')) {
      context.handle(
          _durataMinutiMeta,
          durataMinuti.isAcceptableOrUnknown(
              data['durata_minuti']!, _durataMinutiMeta));
    }
    if (data.containsKey('note_allenatore')) {
      context.handle(
          _noteAllenatoreMeta,
          noteAllenatore.isAcceptableOrUnknown(
              data['note_allenatore']!, _noteAllenatoreMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SchedeEserciziData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchedeEserciziData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      schedaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scheda_id'])!,
      esercizioId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}esercizio_id'])!,
      sezione: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sezione'])!,
      ordineSezione: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ordine_sezione'])!,
      ordineEsercizio: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ordine_esercizio'])!,
      serie: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}serie'])!,
      ripetizioni: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ripetizioni'])!,
      ripetizioniPiramidali: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repsPyramid']),
      peso: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}peso']),
      durataMinuti: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}durata_minuti']),
      noteAllenatore: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_allenatore']),
    );
  }

  @override
  $SchedeEserciziTable createAlias(String alias) {
    return $SchedeEserciziTable(attachedDatabase, alias);
  }
}

class SchedeEserciziData extends DataClass
    implements Insertable<SchedeEserciziData> {
  final int id;
  final int schedaId;
  final int esercizioId;
  final String sezione;
  final int ordineSezione;
  final int ordineEsercizio;
  final int serie;
  final int ripetizioni;
  final String? ripetizioniPiramidali;
  final double? peso;
  final int? durataMinuti;
  final String? noteAllenatore;
  const SchedeEserciziData(
      {required this.id,
      required this.schedaId,
      required this.esercizioId,
      required this.sezione,
      required this.ordineSezione,
      required this.ordineEsercizio,
      required this.serie,
      required this.ripetizioni,
      this.ripetizioniPiramidali,
      this.peso,
      this.durataMinuti,
      this.noteAllenatore});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['scheda_id'] = Variable<int>(schedaId);
    map['esercizio_id'] = Variable<int>(esercizioId);
    map['sezione'] = Variable<String>(sezione);
    map['ordine_sezione'] = Variable<int>(ordineSezione);
    map['ordine_esercizio'] = Variable<int>(ordineEsercizio);
    map['serie'] = Variable<int>(serie);
    map['ripetizioni'] = Variable<int>(ripetizioni);
    if (!nullToAbsent || ripetizioniPiramidali != null) {
      map['repsPyramid'] = Variable<String>(ripetizioniPiramidali);
    }
    if (!nullToAbsent || peso != null) {
      map['peso'] = Variable<double>(peso);
    }
    if (!nullToAbsent || durataMinuti != null) {
      map['durata_minuti'] = Variable<int>(durataMinuti);
    }
    if (!nullToAbsent || noteAllenatore != null) {
      map['note_allenatore'] = Variable<String>(noteAllenatore);
    }
    return map;
  }

  SchedeEserciziCompanion toCompanion(bool nullToAbsent) {
    return SchedeEserciziCompanion(
      id: Value(id),
      schedaId: Value(schedaId),
      esercizioId: Value(esercizioId),
      sezione: Value(sezione),
      ordineSezione: Value(ordineSezione),
      ordineEsercizio: Value(ordineEsercizio),
      serie: Value(serie),
      ripetizioni: Value(ripetizioni),
      ripetizioniPiramidali: ripetizioniPiramidali == null && nullToAbsent
          ? const Value.absent()
          : Value(ripetizioniPiramidali),
      peso: peso == null && nullToAbsent ? const Value.absent() : Value(peso),
      durataMinuti: durataMinuti == null && nullToAbsent
          ? const Value.absent()
          : Value(durataMinuti),
      noteAllenatore: noteAllenatore == null && nullToAbsent
          ? const Value.absent()
          : Value(noteAllenatore),
    );
  }

  factory SchedeEserciziData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchedeEserciziData(
      id: serializer.fromJson<int>(json['id']),
      schedaId: serializer.fromJson<int>(json['schedaId']),
      esercizioId: serializer.fromJson<int>(json['esercizioId']),
      sezione: serializer.fromJson<String>(json['sezione']),
      ordineSezione: serializer.fromJson<int>(json['ordineSezione']),
      ordineEsercizio: serializer.fromJson<int>(json['ordineEsercizio']),
      serie: serializer.fromJson<int>(json['serie']),
      ripetizioni: serializer.fromJson<int>(json['ripetizioni']),
      ripetizioniPiramidali:
          serializer.fromJson<String?>(json['ripetizioniPiramidali']),
      peso: serializer.fromJson<double?>(json['peso']),
      durataMinuti: serializer.fromJson<int?>(json['durataMinuti']),
      noteAllenatore: serializer.fromJson<String?>(json['noteAllenatore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'schedaId': serializer.toJson<int>(schedaId),
      'esercizioId': serializer.toJson<int>(esercizioId),
      'sezione': serializer.toJson<String>(sezione),
      'ordineSezione': serializer.toJson<int>(ordineSezione),
      'ordineEsercizio': serializer.toJson<int>(ordineEsercizio),
      'serie': serializer.toJson<int>(serie),
      'ripetizioni': serializer.toJson<int>(ripetizioni),
      'ripetizioniPiramidali':
          serializer.toJson<String?>(ripetizioniPiramidali),
      'peso': serializer.toJson<double?>(peso),
      'durataMinuti': serializer.toJson<int?>(durataMinuti),
      'noteAllenatore': serializer.toJson<String?>(noteAllenatore),
    };
  }

  SchedeEserciziData copyWith(
          {int? id,
          int? schedaId,
          int? esercizioId,
          String? sezione,
          int? ordineSezione,
          int? ordineEsercizio,
          int? serie,
          int? ripetizioni,
          Value<String?> ripetizioniPiramidali = const Value.absent(),
          Value<double?> peso = const Value.absent(),
          Value<int?> durataMinuti = const Value.absent(),
          Value<String?> noteAllenatore = const Value.absent()}) =>
      SchedeEserciziData(
        id: id ?? this.id,
        schedaId: schedaId ?? this.schedaId,
        esercizioId: esercizioId ?? this.esercizioId,
        sezione: sezione ?? this.sezione,
        ordineSezione: ordineSezione ?? this.ordineSezione,
        ordineEsercizio: ordineEsercizio ?? this.ordineEsercizio,
        serie: serie ?? this.serie,
        ripetizioni: ripetizioni ?? this.ripetizioni,
        ripetizioniPiramidali: ripetizioniPiramidali.present
            ? ripetizioniPiramidali.value
            : this.ripetizioniPiramidali,
        peso: peso.present ? peso.value : this.peso,
        durataMinuti:
            durataMinuti.present ? durataMinuti.value : this.durataMinuti,
        noteAllenatore:
            noteAllenatore.present ? noteAllenatore.value : this.noteAllenatore,
      );
  SchedeEserciziData copyWithCompanion(SchedeEserciziCompanion data) {
    return SchedeEserciziData(
      id: data.id.present ? data.id.value : this.id,
      schedaId: data.schedaId.present ? data.schedaId.value : this.schedaId,
      esercizioId:
          data.esercizioId.present ? data.esercizioId.value : this.esercizioId,
      sezione: data.sezione.present ? data.sezione.value : this.sezione,
      ordineSezione: data.ordineSezione.present
          ? data.ordineSezione.value
          : this.ordineSezione,
      ordineEsercizio: data.ordineEsercizio.present
          ? data.ordineEsercizio.value
          : this.ordineEsercizio,
      serie: data.serie.present ? data.serie.value : this.serie,
      ripetizioni:
          data.ripetizioni.present ? data.ripetizioni.value : this.ripetizioni,
      ripetizioniPiramidali: data.ripetizioniPiramidali.present
          ? data.ripetizioniPiramidali.value
          : this.ripetizioniPiramidali,
      peso: data.peso.present ? data.peso.value : this.peso,
      durataMinuti: data.durataMinuti.present
          ? data.durataMinuti.value
          : this.durataMinuti,
      noteAllenatore: data.noteAllenatore.present
          ? data.noteAllenatore.value
          : this.noteAllenatore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchedeEserciziData(')
          ..write('id: $id, ')
          ..write('schedaId: $schedaId, ')
          ..write('esercizioId: $esercizioId, ')
          ..write('sezione: $sezione, ')
          ..write('ordineSezione: $ordineSezione, ')
          ..write('ordineEsercizio: $ordineEsercizio, ')
          ..write('serie: $serie, ')
          ..write('ripetizioni: $ripetizioni, ')
          ..write('ripetizioniPiramidali: $ripetizioniPiramidali, ')
          ..write('peso: $peso, ')
          ..write('durataMinuti: $durataMinuti, ')
          ..write('noteAllenatore: $noteAllenatore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      schedaId,
      esercizioId,
      sezione,
      ordineSezione,
      ordineEsercizio,
      serie,
      ripetizioni,
      ripetizioniPiramidali,
      peso,
      durataMinuti,
      noteAllenatore);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchedeEserciziData &&
          other.id == this.id &&
          other.schedaId == this.schedaId &&
          other.esercizioId == this.esercizioId &&
          other.sezione == this.sezione &&
          other.ordineSezione == this.ordineSezione &&
          other.ordineEsercizio == this.ordineEsercizio &&
          other.serie == this.serie &&
          other.ripetizioni == this.ripetizioni &&
          other.ripetizioniPiramidali == this.ripetizioniPiramidali &&
          other.peso == this.peso &&
          other.durataMinuti == this.durataMinuti &&
          other.noteAllenatore == this.noteAllenatore);
}

class SchedeEserciziCompanion extends UpdateCompanion<SchedeEserciziData> {
  final Value<int> id;
  final Value<int> schedaId;
  final Value<int> esercizioId;
  final Value<String> sezione;
  final Value<int> ordineSezione;
  final Value<int> ordineEsercizio;
  final Value<int> serie;
  final Value<int> ripetizioni;
  final Value<String?> ripetizioniPiramidali;
  final Value<double?> peso;
  final Value<int?> durataMinuti;
  final Value<String?> noteAllenatore;
  const SchedeEserciziCompanion({
    this.id = const Value.absent(),
    this.schedaId = const Value.absent(),
    this.esercizioId = const Value.absent(),
    this.sezione = const Value.absent(),
    this.ordineSezione = const Value.absent(),
    this.ordineEsercizio = const Value.absent(),
    this.serie = const Value.absent(),
    this.ripetizioni = const Value.absent(),
    this.ripetizioniPiramidali = const Value.absent(),
    this.peso = const Value.absent(),
    this.durataMinuti = const Value.absent(),
    this.noteAllenatore = const Value.absent(),
  });
  SchedeEserciziCompanion.insert({
    this.id = const Value.absent(),
    required int schedaId,
    required int esercizioId,
    this.sezione = const Value.absent(),
    this.ordineSezione = const Value.absent(),
    this.ordineEsercizio = const Value.absent(),
    this.serie = const Value.absent(),
    this.ripetizioni = const Value.absent(),
    this.ripetizioniPiramidali = const Value.absent(),
    this.peso = const Value.absent(),
    this.durataMinuti = const Value.absent(),
    this.noteAllenatore = const Value.absent(),
  })  : schedaId = Value(schedaId),
        esercizioId = Value(esercizioId);
  static Insertable<SchedeEserciziData> custom({
    Expression<int>? id,
    Expression<int>? schedaId,
    Expression<int>? esercizioId,
    Expression<String>? sezione,
    Expression<int>? ordineSezione,
    Expression<int>? ordineEsercizio,
    Expression<int>? serie,
    Expression<int>? ripetizioni,
    Expression<String>? ripetizioniPiramidali,
    Expression<double>? peso,
    Expression<int>? durataMinuti,
    Expression<String>? noteAllenatore,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (schedaId != null) 'scheda_id': schedaId,
      if (esercizioId != null) 'esercizio_id': esercizioId,
      if (sezione != null) 'sezione': sezione,
      if (ordineSezione != null) 'ordine_sezione': ordineSezione,
      if (ordineEsercizio != null) 'ordine_esercizio': ordineEsercizio,
      if (serie != null) 'serie': serie,
      if (ripetizioni != null) 'ripetizioni': ripetizioni,
      if (ripetizioniPiramidali != null) 'repsPyramid': ripetizioniPiramidali,
      if (peso != null) 'peso': peso,
      if (durataMinuti != null) 'durata_minuti': durataMinuti,
      if (noteAllenatore != null) 'note_allenatore': noteAllenatore,
    });
  }

  SchedeEserciziCompanion copyWith(
      {Value<int>? id,
      Value<int>? schedaId,
      Value<int>? esercizioId,
      Value<String>? sezione,
      Value<int>? ordineSezione,
      Value<int>? ordineEsercizio,
      Value<int>? serie,
      Value<int>? ripetizioni,
      Value<String?>? ripetizioniPiramidali,
      Value<double?>? peso,
      Value<int?>? durataMinuti,
      Value<String?>? noteAllenatore}) {
    return SchedeEserciziCompanion(
      id: id ?? this.id,
      schedaId: schedaId ?? this.schedaId,
      esercizioId: esercizioId ?? this.esercizioId,
      sezione: sezione ?? this.sezione,
      ordineSezione: ordineSezione ?? this.ordineSezione,
      ordineEsercizio: ordineEsercizio ?? this.ordineEsercizio,
      serie: serie ?? this.serie,
      ripetizioni: ripetizioni ?? this.ripetizioni,
      ripetizioniPiramidali:
          ripetizioniPiramidali ?? this.ripetizioniPiramidali,
      peso: peso ?? this.peso,
      durataMinuti: durataMinuti ?? this.durataMinuti,
      noteAllenatore: noteAllenatore ?? this.noteAllenatore,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (schedaId.present) {
      map['scheda_id'] = Variable<int>(schedaId.value);
    }
    if (esercizioId.present) {
      map['esercizio_id'] = Variable<int>(esercizioId.value);
    }
    if (sezione.present) {
      map['sezione'] = Variable<String>(sezione.value);
    }
    if (ordineSezione.present) {
      map['ordine_sezione'] = Variable<int>(ordineSezione.value);
    }
    if (ordineEsercizio.present) {
      map['ordine_esercizio'] = Variable<int>(ordineEsercizio.value);
    }
    if (serie.present) {
      map['serie'] = Variable<int>(serie.value);
    }
    if (ripetizioni.present) {
      map['ripetizioni'] = Variable<int>(ripetizioni.value);
    }
    if (ripetizioniPiramidali.present) {
      map['repsPyramid'] = Variable<String>(ripetizioniPiramidali.value);
    }
    if (peso.present) {
      map['peso'] = Variable<double>(peso.value);
    }
    if (durataMinuti.present) {
      map['durata_minuti'] = Variable<int>(durataMinuti.value);
    }
    if (noteAllenatore.present) {
      map['note_allenatore'] = Variable<String>(noteAllenatore.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchedeEserciziCompanion(')
          ..write('id: $id, ')
          ..write('schedaId: $schedaId, ')
          ..write('esercizioId: $esercizioId, ')
          ..write('sezione: $sezione, ')
          ..write('ordineSezione: $ordineSezione, ')
          ..write('ordineEsercizio: $ordineEsercizio, ')
          ..write('serie: $serie, ')
          ..write('ripetizioni: $ripetizioni, ')
          ..write('ripetizioniPiramidali: $ripetizioniPiramidali, ')
          ..write('peso: $peso, ')
          ..write('durataMinuti: $durataMinuti, ')
          ..write('noteAllenatore: $noteAllenatore')
          ..write(')'))
        .toString();
  }
}

class $SessioniAllenamentoTable extends SessioniAllenamento
    with TableInfo<$SessioniAllenamentoTable, SessioniAllenamentoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessioniAllenamentoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _schedaIdMeta =
      const VerificationMeta('schedaId');
  @override
  late final GeneratedColumn<int> schedaId = GeneratedColumn<int>(
      'scheda_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES schede (id)'));
  static const VerificationMeta _utenteIdMeta =
      const VerificationMeta('utenteId');
  @override
  late final GeneratedColumn<int> utenteId = GeneratedColumn<int>(
      'utente_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES utenti (id)'));
  static const VerificationMeta _inizioMeta = const VerificationMeta('inizio');
  @override
  late final GeneratedColumn<DateTime> inizio = GeneratedColumn<DateTime>(
      'startTime', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _fineMeta = const VerificationMeta('fine');
  @override
  late final GeneratedColumn<DateTime> fine = GeneratedColumn<DateTime>(
      'endTime', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _completataMeta =
      const VerificationMeta('completata');
  @override
  late final GeneratedColumn<bool> completata = GeneratedColumn<bool>(
      'completata', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completata" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sincronizzataMeta =
      const VerificationMeta('sincronizzata');
  @override
  late final GeneratedColumn<bool> sincronizzata = GeneratedColumn<bool>(
      'sincronizzata', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sincronizzata" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, schedaId, utenteId, inizio, fine, note, completata, sincronizzata];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessioni_allenamento';
  @override
  VerificationContext validateIntegrity(
      Insertable<SessioniAllenamentoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('scheda_id')) {
      context.handle(_schedaIdMeta,
          schedaId.isAcceptableOrUnknown(data['scheda_id']!, _schedaIdMeta));
    }
    if (data.containsKey('utente_id')) {
      context.handle(_utenteIdMeta,
          utenteId.isAcceptableOrUnknown(data['utente_id']!, _utenteIdMeta));
    } else if (isInserting) {
      context.missing(_utenteIdMeta);
    }
    if (data.containsKey('startTime')) {
      context.handle(_inizioMeta,
          inizio.isAcceptableOrUnknown(data['startTime']!, _inizioMeta));
    } else if (isInserting) {
      context.missing(_inizioMeta);
    }
    if (data.containsKey('endTime')) {
      context.handle(
          _fineMeta, fine.isAcceptableOrUnknown(data['endTime']!, _fineMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('completata')) {
      context.handle(
          _completataMeta,
          completata.isAcceptableOrUnknown(
              data['completata']!, _completataMeta));
    }
    if (data.containsKey('sincronizzata')) {
      context.handle(
          _sincronizzataMeta,
          sincronizzata.isAcceptableOrUnknown(
              data['sincronizzata']!, _sincronizzataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessioniAllenamentoData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessioniAllenamentoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      schedaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scheda_id']),
      utenteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}utente_id'])!,
      inizio: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}startTime'])!,
      fine: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}endTime']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      completata: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completata'])!,
      sincronizzata: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}sincronizzata'])!,
    );
  }

  @override
  $SessioniAllenamentoTable createAlias(String alias) {
    return $SessioniAllenamentoTable(attachedDatabase, alias);
  }
}

class SessioniAllenamentoData extends DataClass
    implements Insertable<SessioniAllenamentoData> {
  final int id;
  final int? schedaId;
  final int utenteId;
  final DateTime inizio;
  final DateTime? fine;
  final String? note;
  final bool completata;
  final bool sincronizzata;
  const SessioniAllenamentoData(
      {required this.id,
      this.schedaId,
      required this.utenteId,
      required this.inizio,
      this.fine,
      this.note,
      required this.completata,
      required this.sincronizzata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || schedaId != null) {
      map['scheda_id'] = Variable<int>(schedaId);
    }
    map['utente_id'] = Variable<int>(utenteId);
    map['startTime'] = Variable<DateTime>(inizio);
    if (!nullToAbsent || fine != null) {
      map['endTime'] = Variable<DateTime>(fine);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['completata'] = Variable<bool>(completata);
    map['sincronizzata'] = Variable<bool>(sincronizzata);
    return map;
  }

  SessioniAllenamentoCompanion toCompanion(bool nullToAbsent) {
    return SessioniAllenamentoCompanion(
      id: Value(id),
      schedaId: schedaId == null && nullToAbsent
          ? const Value.absent()
          : Value(schedaId),
      utenteId: Value(utenteId),
      inizio: Value(inizio),
      fine: fine == null && nullToAbsent ? const Value.absent() : Value(fine),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      completata: Value(completata),
      sincronizzata: Value(sincronizzata),
    );
  }

  factory SessioniAllenamentoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessioniAllenamentoData(
      id: serializer.fromJson<int>(json['id']),
      schedaId: serializer.fromJson<int?>(json['schedaId']),
      utenteId: serializer.fromJson<int>(json['utenteId']),
      inizio: serializer.fromJson<DateTime>(json['inizio']),
      fine: serializer.fromJson<DateTime?>(json['fine']),
      note: serializer.fromJson<String?>(json['note']),
      completata: serializer.fromJson<bool>(json['completata']),
      sincronizzata: serializer.fromJson<bool>(json['sincronizzata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'schedaId': serializer.toJson<int?>(schedaId),
      'utenteId': serializer.toJson<int>(utenteId),
      'inizio': serializer.toJson<DateTime>(inizio),
      'fine': serializer.toJson<DateTime?>(fine),
      'note': serializer.toJson<String?>(note),
      'completata': serializer.toJson<bool>(completata),
      'sincronizzata': serializer.toJson<bool>(sincronizzata),
    };
  }

  SessioniAllenamentoData copyWith(
          {int? id,
          Value<int?> schedaId = const Value.absent(),
          int? utenteId,
          DateTime? inizio,
          Value<DateTime?> fine = const Value.absent(),
          Value<String?> note = const Value.absent(),
          bool? completata,
          bool? sincronizzata}) =>
      SessioniAllenamentoData(
        id: id ?? this.id,
        schedaId: schedaId.present ? schedaId.value : this.schedaId,
        utenteId: utenteId ?? this.utenteId,
        inizio: inizio ?? this.inizio,
        fine: fine.present ? fine.value : this.fine,
        note: note.present ? note.value : this.note,
        completata: completata ?? this.completata,
        sincronizzata: sincronizzata ?? this.sincronizzata,
      );
  SessioniAllenamentoData copyWithCompanion(SessioniAllenamentoCompanion data) {
    return SessioniAllenamentoData(
      id: data.id.present ? data.id.value : this.id,
      schedaId: data.schedaId.present ? data.schedaId.value : this.schedaId,
      utenteId: data.utenteId.present ? data.utenteId.value : this.utenteId,
      inizio: data.inizio.present ? data.inizio.value : this.inizio,
      fine: data.fine.present ? data.fine.value : this.fine,
      note: data.note.present ? data.note.value : this.note,
      completata:
          data.completata.present ? data.completata.value : this.completata,
      sincronizzata: data.sincronizzata.present
          ? data.sincronizzata.value
          : this.sincronizzata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessioniAllenamentoData(')
          ..write('id: $id, ')
          ..write('schedaId: $schedaId, ')
          ..write('utenteId: $utenteId, ')
          ..write('inizio: $inizio, ')
          ..write('fine: $fine, ')
          ..write('note: $note, ')
          ..write('completata: $completata, ')
          ..write('sincronizzata: $sincronizzata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, schedaId, utenteId, inizio, fine, note, completata, sincronizzata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessioniAllenamentoData &&
          other.id == this.id &&
          other.schedaId == this.schedaId &&
          other.utenteId == this.utenteId &&
          other.inizio == this.inizio &&
          other.fine == this.fine &&
          other.note == this.note &&
          other.completata == this.completata &&
          other.sincronizzata == this.sincronizzata);
}

class SessioniAllenamentoCompanion
    extends UpdateCompanion<SessioniAllenamentoData> {
  final Value<int> id;
  final Value<int?> schedaId;
  final Value<int> utenteId;
  final Value<DateTime> inizio;
  final Value<DateTime?> fine;
  final Value<String?> note;
  final Value<bool> completata;
  final Value<bool> sincronizzata;
  const SessioniAllenamentoCompanion({
    this.id = const Value.absent(),
    this.schedaId = const Value.absent(),
    this.utenteId = const Value.absent(),
    this.inizio = const Value.absent(),
    this.fine = const Value.absent(),
    this.note = const Value.absent(),
    this.completata = const Value.absent(),
    this.sincronizzata = const Value.absent(),
  });
  SessioniAllenamentoCompanion.insert({
    this.id = const Value.absent(),
    this.schedaId = const Value.absent(),
    required int utenteId,
    required DateTime inizio,
    this.fine = const Value.absent(),
    this.note = const Value.absent(),
    this.completata = const Value.absent(),
    this.sincronizzata = const Value.absent(),
  })  : utenteId = Value(utenteId),
        inizio = Value(inizio);
  static Insertable<SessioniAllenamentoData> custom({
    Expression<int>? id,
    Expression<int>? schedaId,
    Expression<int>? utenteId,
    Expression<DateTime>? inizio,
    Expression<DateTime>? fine,
    Expression<String>? note,
    Expression<bool>? completata,
    Expression<bool>? sincronizzata,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (schedaId != null) 'scheda_id': schedaId,
      if (utenteId != null) 'utente_id': utenteId,
      if (inizio != null) 'startTime': inizio,
      if (fine != null) 'endTime': fine,
      if (note != null) 'note': note,
      if (completata != null) 'completata': completata,
      if (sincronizzata != null) 'sincronizzata': sincronizzata,
    });
  }

  SessioniAllenamentoCompanion copyWith(
      {Value<int>? id,
      Value<int?>? schedaId,
      Value<int>? utenteId,
      Value<DateTime>? inizio,
      Value<DateTime?>? fine,
      Value<String?>? note,
      Value<bool>? completata,
      Value<bool>? sincronizzata}) {
    return SessioniAllenamentoCompanion(
      id: id ?? this.id,
      schedaId: schedaId ?? this.schedaId,
      utenteId: utenteId ?? this.utenteId,
      inizio: inizio ?? this.inizio,
      fine: fine ?? this.fine,
      note: note ?? this.note,
      completata: completata ?? this.completata,
      sincronizzata: sincronizzata ?? this.sincronizzata,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (schedaId.present) {
      map['scheda_id'] = Variable<int>(schedaId.value);
    }
    if (utenteId.present) {
      map['utente_id'] = Variable<int>(utenteId.value);
    }
    if (inizio.present) {
      map['startTime'] = Variable<DateTime>(inizio.value);
    }
    if (fine.present) {
      map['endTime'] = Variable<DateTime>(fine.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (completata.present) {
      map['completata'] = Variable<bool>(completata.value);
    }
    if (sincronizzata.present) {
      map['sincronizzata'] = Variable<bool>(sincronizzata.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessioniAllenamentoCompanion(')
          ..write('id: $id, ')
          ..write('schedaId: $schedaId, ')
          ..write('utenteId: $utenteId, ')
          ..write('inizio: $inizio, ')
          ..write('fine: $fine, ')
          ..write('note: $note, ')
          ..write('completata: $completata, ')
          ..write('sincronizzata: $sincronizzata')
          ..write(')'))
        .toString();
  }
}

class $SerieRegistrateTable extends SerieRegistrate
    with TableInfo<$SerieRegistrateTable, SerieRegistrateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SerieRegistrateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessioneIdMeta =
      const VerificationMeta('sessioneId');
  @override
  late final GeneratedColumn<int> sessioneId = GeneratedColumn<int>(
      'sessione_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES sessioni_allenamento (id)'));
  static const VerificationMeta _esercizioIdMeta =
      const VerificationMeta('esercizioId');
  @override
  late final GeneratedColumn<int> esercizioId = GeneratedColumn<int>(
      'esercizio_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES esercizi (id)'));
  static const VerificationMeta _indiceSerieMeta =
      const VerificationMeta('indiceSerie');
  @override
  late final GeneratedColumn<int> indiceSerie = GeneratedColumn<int>(
      'serieIndex', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ripetizioniMeta =
      const VerificationMeta('ripetizioni');
  @override
  late final GeneratedColumn<int> ripetizioni = GeneratedColumn<int>(
      'ripetizioni', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ripetizioniTestoMeta =
      const VerificationMeta('ripetizioniTesto');
  @override
  late final GeneratedColumn<String> ripetizioniTesto = GeneratedColumn<String>(
      'ripetizioni_testo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pesoMeta = const VerificationMeta('peso');
  @override
  late final GeneratedColumn<double> peso = GeneratedColumn<double>(
      'peso', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
      'rpe', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _secondiTempoMeta =
      const VerificationMeta('secondiTempo');
  @override
  late final GeneratedColumn<int> secondiTempo = GeneratedColumn<int>(
      'tempoSec', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dataOraMeta =
      const VerificationMeta('dataOra');
  @override
  late final GeneratedColumn<DateTime> dataOra = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessioneId,
        esercizioId,
        indiceSerie,
        ripetizioni,
        ripetizioniTesto,
        peso,
        rpe,
        secondiTempo,
        note,
        dataOra
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recordSet';
  @override
  VerificationContext validateIntegrity(
      Insertable<SerieRegistrateData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sessione_id')) {
      context.handle(
          _sessioneIdMeta,
          sessioneId.isAcceptableOrUnknown(
              data['sessione_id']!, _sessioneIdMeta));
    } else if (isInserting) {
      context.missing(_sessioneIdMeta);
    }
    if (data.containsKey('esercizio_id')) {
      context.handle(
          _esercizioIdMeta,
          esercizioId.isAcceptableOrUnknown(
              data['esercizio_id']!, _esercizioIdMeta));
    } else if (isInserting) {
      context.missing(_esercizioIdMeta);
    }
    if (data.containsKey('serieIndex')) {
      context.handle(
          _indiceSerieMeta,
          indiceSerie.isAcceptableOrUnknown(
              data['serieIndex']!, _indiceSerieMeta));
    } else if (isInserting) {
      context.missing(_indiceSerieMeta);
    }
    if (data.containsKey('ripetizioni')) {
      context.handle(
          _ripetizioniMeta,
          ripetizioni.isAcceptableOrUnknown(
              data['ripetizioni']!, _ripetizioniMeta));
    } else if (isInserting) {
      context.missing(_ripetizioniMeta);
    }
    if (data.containsKey('ripetizioni_testo')) {
      context.handle(
          _ripetizioniTestoMeta,
          ripetizioniTesto.isAcceptableOrUnknown(
              data['ripetizioni_testo']!, _ripetizioniTestoMeta));
    }
    if (data.containsKey('peso')) {
      context.handle(
          _pesoMeta, peso.isAcceptableOrUnknown(data['peso']!, _pesoMeta));
    }
    if (data.containsKey('rpe')) {
      context.handle(
          _rpeMeta, rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta));
    }
    if (data.containsKey('tempoSec')) {
      context.handle(
          _secondiTempoMeta,
          secondiTempo.isAcceptableOrUnknown(
              data['tempoSec']!, _secondiTempoMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_dataOraMeta,
          dataOra.isAcceptableOrUnknown(data['timestamp']!, _dataOraMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SerieRegistrateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SerieRegistrateData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessioneId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sessione_id'])!,
      esercizioId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}esercizio_id'])!,
      indiceSerie: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}serieIndex'])!,
      ripetizioni: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ripetizioni'])!,
      ripetizioniTesto: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ripetizioni_testo']),
      peso: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}peso']),
      rpe: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rpe']),
      secondiTempo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tempoSec']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      dataOra: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $SerieRegistrateTable createAlias(String alias) {
    return $SerieRegistrateTable(attachedDatabase, alias);
  }
}

class SerieRegistrateData extends DataClass
    implements Insertable<SerieRegistrateData> {
  final int id;
  final int sessioneId;
  final int esercizioId;
  final int indiceSerie;
  final int ripetizioni;
  final String? ripetizioniTesto;
  final double? peso;
  final double? rpe;
  final int? secondiTempo;
  final String? note;
  final DateTime dataOra;
  const SerieRegistrateData(
      {required this.id,
      required this.sessioneId,
      required this.esercizioId,
      required this.indiceSerie,
      required this.ripetizioni,
      this.ripetizioniTesto,
      this.peso,
      this.rpe,
      this.secondiTempo,
      this.note,
      required this.dataOra});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sessione_id'] = Variable<int>(sessioneId);
    map['esercizio_id'] = Variable<int>(esercizioId);
    map['serieIndex'] = Variable<int>(indiceSerie);
    map['ripetizioni'] = Variable<int>(ripetizioni);
    if (!nullToAbsent || ripetizioniTesto != null) {
      map['ripetizioni_testo'] = Variable<String>(ripetizioniTesto);
    }
    if (!nullToAbsent || peso != null) {
      map['peso'] = Variable<double>(peso);
    }
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<double>(rpe);
    }
    if (!nullToAbsent || secondiTempo != null) {
      map['tempoSec'] = Variable<int>(secondiTempo);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['timestamp'] = Variable<DateTime>(dataOra);
    return map;
  }

  SerieRegistrateCompanion toCompanion(bool nullToAbsent) {
    return SerieRegistrateCompanion(
      id: Value(id),
      sessioneId: Value(sessioneId),
      esercizioId: Value(esercizioId),
      indiceSerie: Value(indiceSerie),
      ripetizioni: Value(ripetizioni),
      ripetizioniTesto: ripetizioniTesto == null && nullToAbsent
          ? const Value.absent()
          : Value(ripetizioniTesto),
      peso: peso == null && nullToAbsent ? const Value.absent() : Value(peso),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      secondiTempo: secondiTempo == null && nullToAbsent
          ? const Value.absent()
          : Value(secondiTempo),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      dataOra: Value(dataOra),
    );
  }

  factory SerieRegistrateData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SerieRegistrateData(
      id: serializer.fromJson<int>(json['id']),
      sessioneId: serializer.fromJson<int>(json['sessioneId']),
      esercizioId: serializer.fromJson<int>(json['esercizioId']),
      indiceSerie: serializer.fromJson<int>(json['indiceSerie']),
      ripetizioni: serializer.fromJson<int>(json['ripetizioni']),
      ripetizioniTesto: serializer.fromJson<String?>(json['ripetizioniTesto']),
      peso: serializer.fromJson<double?>(json['peso']),
      rpe: serializer.fromJson<double?>(json['rpe']),
      secondiTempo: serializer.fromJson<int?>(json['secondiTempo']),
      note: serializer.fromJson<String?>(json['note']),
      dataOra: serializer.fromJson<DateTime>(json['dataOra']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessioneId': serializer.toJson<int>(sessioneId),
      'esercizioId': serializer.toJson<int>(esercizioId),
      'indiceSerie': serializer.toJson<int>(indiceSerie),
      'ripetizioni': serializer.toJson<int>(ripetizioni),
      'ripetizioniTesto': serializer.toJson<String?>(ripetizioniTesto),
      'peso': serializer.toJson<double?>(peso),
      'rpe': serializer.toJson<double?>(rpe),
      'secondiTempo': serializer.toJson<int?>(secondiTempo),
      'note': serializer.toJson<String?>(note),
      'dataOra': serializer.toJson<DateTime>(dataOra),
    };
  }

  SerieRegistrateData copyWith(
          {int? id,
          int? sessioneId,
          int? esercizioId,
          int? indiceSerie,
          int? ripetizioni,
          Value<String?> ripetizioniTesto = const Value.absent(),
          Value<double?> peso = const Value.absent(),
          Value<double?> rpe = const Value.absent(),
          Value<int?> secondiTempo = const Value.absent(),
          Value<String?> note = const Value.absent(),
          DateTime? dataOra}) =>
      SerieRegistrateData(
        id: id ?? this.id,
        sessioneId: sessioneId ?? this.sessioneId,
        esercizioId: esercizioId ?? this.esercizioId,
        indiceSerie: indiceSerie ?? this.indiceSerie,
        ripetizioni: ripetizioni ?? this.ripetizioni,
        ripetizioniTesto: ripetizioniTesto.present
            ? ripetizioniTesto.value
            : this.ripetizioniTesto,
        peso: peso.present ? peso.value : this.peso,
        rpe: rpe.present ? rpe.value : this.rpe,
        secondiTempo:
            secondiTempo.present ? secondiTempo.value : this.secondiTempo,
        note: note.present ? note.value : this.note,
        dataOra: dataOra ?? this.dataOra,
      );
  SerieRegistrateData copyWithCompanion(SerieRegistrateCompanion data) {
    return SerieRegistrateData(
      id: data.id.present ? data.id.value : this.id,
      sessioneId:
          data.sessioneId.present ? data.sessioneId.value : this.sessioneId,
      esercizioId:
          data.esercizioId.present ? data.esercizioId.value : this.esercizioId,
      indiceSerie:
          data.indiceSerie.present ? data.indiceSerie.value : this.indiceSerie,
      ripetizioni:
          data.ripetizioni.present ? data.ripetizioni.value : this.ripetizioni,
      ripetizioniTesto: data.ripetizioniTesto.present
          ? data.ripetizioniTesto.value
          : this.ripetizioniTesto,
      peso: data.peso.present ? data.peso.value : this.peso,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      secondiTempo: data.secondiTempo.present
          ? data.secondiTempo.value
          : this.secondiTempo,
      note: data.note.present ? data.note.value : this.note,
      dataOra: data.dataOra.present ? data.dataOra.value : this.dataOra,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SerieRegistrateData(')
          ..write('id: $id, ')
          ..write('sessioneId: $sessioneId, ')
          ..write('esercizioId: $esercizioId, ')
          ..write('indiceSerie: $indiceSerie, ')
          ..write('ripetizioni: $ripetizioni, ')
          ..write('ripetizioniTesto: $ripetizioniTesto, ')
          ..write('peso: $peso, ')
          ..write('rpe: $rpe, ')
          ..write('secondiTempo: $secondiTempo, ')
          ..write('note: $note, ')
          ..write('dataOra: $dataOra')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessioneId, esercizioId, indiceSerie,
      ripetizioni, ripetizioniTesto, peso, rpe, secondiTempo, note, dataOra);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SerieRegistrateData &&
          other.id == this.id &&
          other.sessioneId == this.sessioneId &&
          other.esercizioId == this.esercizioId &&
          other.indiceSerie == this.indiceSerie &&
          other.ripetizioni == this.ripetizioni &&
          other.ripetizioniTesto == this.ripetizioniTesto &&
          other.peso == this.peso &&
          other.rpe == this.rpe &&
          other.secondiTempo == this.secondiTempo &&
          other.note == this.note &&
          other.dataOra == this.dataOra);
}

class SerieRegistrateCompanion extends UpdateCompanion<SerieRegistrateData> {
  final Value<int> id;
  final Value<int> sessioneId;
  final Value<int> esercizioId;
  final Value<int> indiceSerie;
  final Value<int> ripetizioni;
  final Value<String?> ripetizioniTesto;
  final Value<double?> peso;
  final Value<double?> rpe;
  final Value<int?> secondiTempo;
  final Value<String?> note;
  final Value<DateTime> dataOra;
  const SerieRegistrateCompanion({
    this.id = const Value.absent(),
    this.sessioneId = const Value.absent(),
    this.esercizioId = const Value.absent(),
    this.indiceSerie = const Value.absent(),
    this.ripetizioni = const Value.absent(),
    this.ripetizioniTesto = const Value.absent(),
    this.peso = const Value.absent(),
    this.rpe = const Value.absent(),
    this.secondiTempo = const Value.absent(),
    this.note = const Value.absent(),
    this.dataOra = const Value.absent(),
  });
  SerieRegistrateCompanion.insert({
    this.id = const Value.absent(),
    required int sessioneId,
    required int esercizioId,
    required int indiceSerie,
    required int ripetizioni,
    this.ripetizioniTesto = const Value.absent(),
    this.peso = const Value.absent(),
    this.rpe = const Value.absent(),
    this.secondiTempo = const Value.absent(),
    this.note = const Value.absent(),
    this.dataOra = const Value.absent(),
  })  : sessioneId = Value(sessioneId),
        esercizioId = Value(esercizioId),
        indiceSerie = Value(indiceSerie),
        ripetizioni = Value(ripetizioni);
  static Insertable<SerieRegistrateData> custom({
    Expression<int>? id,
    Expression<int>? sessioneId,
    Expression<int>? esercizioId,
    Expression<int>? indiceSerie,
    Expression<int>? ripetizioni,
    Expression<String>? ripetizioniTesto,
    Expression<double>? peso,
    Expression<double>? rpe,
    Expression<int>? secondiTempo,
    Expression<String>? note,
    Expression<DateTime>? dataOra,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessioneId != null) 'sessione_id': sessioneId,
      if (esercizioId != null) 'esercizio_id': esercizioId,
      if (indiceSerie != null) 'serieIndex': indiceSerie,
      if (ripetizioni != null) 'ripetizioni': ripetizioni,
      if (ripetizioniTesto != null) 'ripetizioni_testo': ripetizioniTesto,
      if (peso != null) 'peso': peso,
      if (rpe != null) 'rpe': rpe,
      if (secondiTempo != null) 'tempoSec': secondiTempo,
      if (note != null) 'note': note,
      if (dataOra != null) 'timestamp': dataOra,
    });
  }

  SerieRegistrateCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessioneId,
      Value<int>? esercizioId,
      Value<int>? indiceSerie,
      Value<int>? ripetizioni,
      Value<String?>? ripetizioniTesto,
      Value<double?>? peso,
      Value<double?>? rpe,
      Value<int?>? secondiTempo,
      Value<String?>? note,
      Value<DateTime>? dataOra}) {
    return SerieRegistrateCompanion(
      id: id ?? this.id,
      sessioneId: sessioneId ?? this.sessioneId,
      esercizioId: esercizioId ?? this.esercizioId,
      indiceSerie: indiceSerie ?? this.indiceSerie,
      ripetizioni: ripetizioni ?? this.ripetizioni,
      ripetizioniTesto: ripetizioniTesto ?? this.ripetizioniTesto,
      peso: peso ?? this.peso,
      rpe: rpe ?? this.rpe,
      secondiTempo: secondiTempo ?? this.secondiTempo,
      note: note ?? this.note,
      dataOra: dataOra ?? this.dataOra,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessioneId.present) {
      map['sessione_id'] = Variable<int>(sessioneId.value);
    }
    if (esercizioId.present) {
      map['esercizio_id'] = Variable<int>(esercizioId.value);
    }
    if (indiceSerie.present) {
      map['serieIndex'] = Variable<int>(indiceSerie.value);
    }
    if (ripetizioni.present) {
      map['ripetizioni'] = Variable<int>(ripetizioni.value);
    }
    if (ripetizioniTesto.present) {
      map['ripetizioni_testo'] = Variable<String>(ripetizioniTesto.value);
    }
    if (peso.present) {
      map['peso'] = Variable<double>(peso.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (secondiTempo.present) {
      map['tempoSec'] = Variable<int>(secondiTempo.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (dataOra.present) {
      map['timestamp'] = Variable<DateTime>(dataOra.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SerieRegistrateCompanion(')
          ..write('id: $id, ')
          ..write('sessioneId: $sessioneId, ')
          ..write('esercizioId: $esercizioId, ')
          ..write('indiceSerie: $indiceSerie, ')
          ..write('ripetizioni: $ripetizioni, ')
          ..write('ripetizioniTesto: $ripetizioniTesto, ')
          ..write('peso: $peso, ')
          ..write('rpe: $rpe, ')
          ..write('secondiTempo: $secondiTempo, ')
          ..write('note: $note, ')
          ..write('dataOra: $dataOra')
          ..write(')'))
        .toString();
  }
}

class $MisurazioniTable extends Misurazioni
    with TableInfo<$MisurazioniTable, MisurazioniData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MisurazioniTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _utenteIdMeta =
      const VerificationMeta('utenteId');
  @override
  late final GeneratedColumn<int> utenteId = GeneratedColumn<int>(
      'utente_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES utenti (id)'));
  static const VerificationMeta _pesoMeta = const VerificationMeta('peso');
  @override
  late final GeneratedColumn<double> peso = GeneratedColumn<double>(
      'peso', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _percentualeMassaGrassaMeta =
      const VerificationMeta('percentualeMassaGrassa');
  @override
  late final GeneratedColumn<double> percentualeMassaGrassa =
      GeneratedColumn<double>('bodyFatPercent', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _pettoMeta = const VerificationMeta('petto');
  @override
  late final GeneratedColumn<double> petto = GeneratedColumn<double>(
      'petto', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _vitaMeta = const VerificationMeta('vita');
  @override
  late final GeneratedColumn<double> vita = GeneratedColumn<double>(
      'vita', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cosciaMeta = const VerificationMeta('coscia');
  @override
  late final GeneratedColumn<double> coscia = GeneratedColumn<double>(
      'coscia', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
      'data', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        utenteId,
        peso,
        percentualeMassaGrassa,
        petto,
        vita,
        coscia,
        note,
        data
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'misurazioni';
  @override
  VerificationContext validateIntegrity(Insertable<MisurazioniData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('utente_id')) {
      context.handle(_utenteIdMeta,
          utenteId.isAcceptableOrUnknown(data['utente_id']!, _utenteIdMeta));
    } else if (isInserting) {
      context.missing(_utenteIdMeta);
    }
    if (data.containsKey('peso')) {
      context.handle(
          _pesoMeta, peso.isAcceptableOrUnknown(data['peso']!, _pesoMeta));
    } else if (isInserting) {
      context.missing(_pesoMeta);
    }
    if (data.containsKey('bodyFatPercent')) {
      context.handle(
          _percentualeMassaGrassaMeta,
          percentualeMassaGrassa.isAcceptableOrUnknown(
              data['bodyFatPercent']!, _percentualeMassaGrassaMeta));
    }
    if (data.containsKey('petto')) {
      context.handle(
          _pettoMeta, petto.isAcceptableOrUnknown(data['petto']!, _pettoMeta));
    }
    if (data.containsKey('vita')) {
      context.handle(
          _vitaMeta, vita.isAcceptableOrUnknown(data['vita']!, _vitaMeta));
    }
    if (data.containsKey('coscia')) {
      context.handle(_cosciaMeta,
          coscia.isAcceptableOrUnknown(data['coscia']!, _cosciaMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MisurazioniData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MisurazioniData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      utenteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}utente_id'])!,
      peso: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}peso'])!,
      percentualeMassaGrassa: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bodyFatPercent']),
      petto: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}petto']),
      vita: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vita']),
      coscia: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}coscia']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data'])!,
    );
  }

  @override
  $MisurazioniTable createAlias(String alias) {
    return $MisurazioniTable(attachedDatabase, alias);
  }
}

class MisurazioniData extends DataClass implements Insertable<MisurazioniData> {
  final int id;
  final int utenteId;
  final double peso;
  final double? percentualeMassaGrassa;
  final double? petto;
  final double? vita;
  final double? coscia;
  final String? note;
  final DateTime data;
  const MisurazioniData(
      {required this.id,
      required this.utenteId,
      required this.peso,
      this.percentualeMassaGrassa,
      this.petto,
      this.vita,
      this.coscia,
      this.note,
      required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['utente_id'] = Variable<int>(utenteId);
    map['peso'] = Variable<double>(peso);
    if (!nullToAbsent || percentualeMassaGrassa != null) {
      map['bodyFatPercent'] = Variable<double>(percentualeMassaGrassa);
    }
    if (!nullToAbsent || petto != null) {
      map['petto'] = Variable<double>(petto);
    }
    if (!nullToAbsent || vita != null) {
      map['vita'] = Variable<double>(vita);
    }
    if (!nullToAbsent || coscia != null) {
      map['coscia'] = Variable<double>(coscia);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['data'] = Variable<DateTime>(data);
    return map;
  }

  MisurazioniCompanion toCompanion(bool nullToAbsent) {
    return MisurazioniCompanion(
      id: Value(id),
      utenteId: Value(utenteId),
      peso: Value(peso),
      percentualeMassaGrassa: percentualeMassaGrassa == null && nullToAbsent
          ? const Value.absent()
          : Value(percentualeMassaGrassa),
      petto:
          petto == null && nullToAbsent ? const Value.absent() : Value(petto),
      vita: vita == null && nullToAbsent ? const Value.absent() : Value(vita),
      coscia:
          coscia == null && nullToAbsent ? const Value.absent() : Value(coscia),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      data: Value(data),
    );
  }

  factory MisurazioniData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MisurazioniData(
      id: serializer.fromJson<int>(json['id']),
      utenteId: serializer.fromJson<int>(json['utenteId']),
      peso: serializer.fromJson<double>(json['peso']),
      percentualeMassaGrassa:
          serializer.fromJson<double?>(json['percentualeMassaGrassa']),
      petto: serializer.fromJson<double?>(json['petto']),
      vita: serializer.fromJson<double?>(json['vita']),
      coscia: serializer.fromJson<double?>(json['coscia']),
      note: serializer.fromJson<String?>(json['note']),
      data: serializer.fromJson<DateTime>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'utenteId': serializer.toJson<int>(utenteId),
      'peso': serializer.toJson<double>(peso),
      'percentualeMassaGrassa':
          serializer.toJson<double?>(percentualeMassaGrassa),
      'petto': serializer.toJson<double?>(petto),
      'vita': serializer.toJson<double?>(vita),
      'coscia': serializer.toJson<double?>(coscia),
      'note': serializer.toJson<String?>(note),
      'data': serializer.toJson<DateTime>(data),
    };
  }

  MisurazioniData copyWith(
          {int? id,
          int? utenteId,
          double? peso,
          Value<double?> percentualeMassaGrassa = const Value.absent(),
          Value<double?> petto = const Value.absent(),
          Value<double?> vita = const Value.absent(),
          Value<double?> coscia = const Value.absent(),
          Value<String?> note = const Value.absent(),
          DateTime? data}) =>
      MisurazioniData(
        id: id ?? this.id,
        utenteId: utenteId ?? this.utenteId,
        peso: peso ?? this.peso,
        percentualeMassaGrassa: percentualeMassaGrassa.present
            ? percentualeMassaGrassa.value
            : this.percentualeMassaGrassa,
        petto: petto.present ? petto.value : this.petto,
        vita: vita.present ? vita.value : this.vita,
        coscia: coscia.present ? coscia.value : this.coscia,
        note: note.present ? note.value : this.note,
        data: data ?? this.data,
      );
  MisurazioniData copyWithCompanion(MisurazioniCompanion data) {
    return MisurazioniData(
      id: data.id.present ? data.id.value : this.id,
      utenteId: data.utenteId.present ? data.utenteId.value : this.utenteId,
      peso: data.peso.present ? data.peso.value : this.peso,
      percentualeMassaGrassa: data.percentualeMassaGrassa.present
          ? data.percentualeMassaGrassa.value
          : this.percentualeMassaGrassa,
      petto: data.petto.present ? data.petto.value : this.petto,
      vita: data.vita.present ? data.vita.value : this.vita,
      coscia: data.coscia.present ? data.coscia.value : this.coscia,
      note: data.note.present ? data.note.value : this.note,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MisurazioniData(')
          ..write('id: $id, ')
          ..write('utenteId: $utenteId, ')
          ..write('peso: $peso, ')
          ..write('percentualeMassaGrassa: $percentualeMassaGrassa, ')
          ..write('petto: $petto, ')
          ..write('vita: $vita, ')
          ..write('coscia: $coscia, ')
          ..write('note: $note, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, utenteId, peso, percentualeMassaGrassa,
      petto, vita, coscia, note, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MisurazioniData &&
          other.id == this.id &&
          other.utenteId == this.utenteId &&
          other.peso == this.peso &&
          other.percentualeMassaGrassa == this.percentualeMassaGrassa &&
          other.petto == this.petto &&
          other.vita == this.vita &&
          other.coscia == this.coscia &&
          other.note == this.note &&
          other.data == this.data);
}

class MisurazioniCompanion extends UpdateCompanion<MisurazioniData> {
  final Value<int> id;
  final Value<int> utenteId;
  final Value<double> peso;
  final Value<double?> percentualeMassaGrassa;
  final Value<double?> petto;
  final Value<double?> vita;
  final Value<double?> coscia;
  final Value<String?> note;
  final Value<DateTime> data;
  const MisurazioniCompanion({
    this.id = const Value.absent(),
    this.utenteId = const Value.absent(),
    this.peso = const Value.absent(),
    this.percentualeMassaGrassa = const Value.absent(),
    this.petto = const Value.absent(),
    this.vita = const Value.absent(),
    this.coscia = const Value.absent(),
    this.note = const Value.absent(),
    this.data = const Value.absent(),
  });
  MisurazioniCompanion.insert({
    this.id = const Value.absent(),
    required int utenteId,
    required double peso,
    this.percentualeMassaGrassa = const Value.absent(),
    this.petto = const Value.absent(),
    this.vita = const Value.absent(),
    this.coscia = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime data,
  })  : utenteId = Value(utenteId),
        peso = Value(peso),
        data = Value(data);
  static Insertable<MisurazioniData> custom({
    Expression<int>? id,
    Expression<int>? utenteId,
    Expression<double>? peso,
    Expression<double>? percentualeMassaGrassa,
    Expression<double>? petto,
    Expression<double>? vita,
    Expression<double>? coscia,
    Expression<String>? note,
    Expression<DateTime>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (utenteId != null) 'utente_id': utenteId,
      if (peso != null) 'peso': peso,
      if (percentualeMassaGrassa != null)
        'bodyFatPercent': percentualeMassaGrassa,
      if (petto != null) 'petto': petto,
      if (vita != null) 'vita': vita,
      if (coscia != null) 'coscia': coscia,
      if (note != null) 'note': note,
      if (data != null) 'data': data,
    });
  }

  MisurazioniCompanion copyWith(
      {Value<int>? id,
      Value<int>? utenteId,
      Value<double>? peso,
      Value<double?>? percentualeMassaGrassa,
      Value<double?>? petto,
      Value<double?>? vita,
      Value<double?>? coscia,
      Value<String?>? note,
      Value<DateTime>? data}) {
    return MisurazioniCompanion(
      id: id ?? this.id,
      utenteId: utenteId ?? this.utenteId,
      peso: peso ?? this.peso,
      percentualeMassaGrassa:
          percentualeMassaGrassa ?? this.percentualeMassaGrassa,
      petto: petto ?? this.petto,
      vita: vita ?? this.vita,
      coscia: coscia ?? this.coscia,
      note: note ?? this.note,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (utenteId.present) {
      map['utente_id'] = Variable<int>(utenteId.value);
    }
    if (peso.present) {
      map['peso'] = Variable<double>(peso.value);
    }
    if (percentualeMassaGrassa.present) {
      map['bodyFatPercent'] = Variable<double>(percentualeMassaGrassa.value);
    }
    if (petto.present) {
      map['petto'] = Variable<double>(petto.value);
    }
    if (vita.present) {
      map['vita'] = Variable<double>(vita.value);
    }
    if (coscia.present) {
      map['coscia'] = Variable<double>(coscia.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MisurazioniCompanion(')
          ..write('id: $id, ')
          ..write('utenteId: $utenteId, ')
          ..write('peso: $peso, ')
          ..write('percentualeMassaGrassa: $percentualeMassaGrassa, ')
          ..write('petto: $petto, ')
          ..write('vita: $vita, ')
          ..write('coscia: $coscia, ')
          ..write('note: $note, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $ImpostazioniTable extends Impostazioni
    with TableInfo<$ImpostazioniTable, ImpostazioniData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImpostazioniTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _chiaveMeta = const VerificationMeta('chiave');
  @override
  late final GeneratedColumn<String> chiave = GeneratedColumn<String>(
      'chiave', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valoreMeta = const VerificationMeta('valore');
  @override
  late final GeneratedColumn<String> valore = GeneratedColumn<String>(
      'valore', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [chiave, valore];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'impostazioni';
  @override
  VerificationContext validateIntegrity(Insertable<ImpostazioniData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('chiave')) {
      context.handle(_chiaveMeta,
          chiave.isAcceptableOrUnknown(data['chiave']!, _chiaveMeta));
    } else if (isInserting) {
      context.missing(_chiaveMeta);
    }
    if (data.containsKey('valore')) {
      context.handle(_valoreMeta,
          valore.isAcceptableOrUnknown(data['valore']!, _valoreMeta));
    } else if (isInserting) {
      context.missing(_valoreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {chiave};
  @override
  ImpostazioniData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImpostazioniData(
      chiave: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chiave'])!,
      valore: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}valore'])!,
    );
  }

  @override
  $ImpostazioniTable createAlias(String alias) {
    return $ImpostazioniTable(attachedDatabase, alias);
  }
}

class ImpostazioniData extends DataClass
    implements Insertable<ImpostazioniData> {
  final String chiave;
  final String valore;
  const ImpostazioniData({required this.chiave, required this.valore});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chiave'] = Variable<String>(chiave);
    map['valore'] = Variable<String>(valore);
    return map;
  }

  ImpostazioniCompanion toCompanion(bool nullToAbsent) {
    return ImpostazioniCompanion(
      chiave: Value(chiave),
      valore: Value(valore),
    );
  }

  factory ImpostazioniData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImpostazioniData(
      chiave: serializer.fromJson<String>(json['chiave']),
      valore: serializer.fromJson<String>(json['valore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'chiave': serializer.toJson<String>(chiave),
      'valore': serializer.toJson<String>(valore),
    };
  }

  ImpostazioniData copyWith({String? chiave, String? valore}) =>
      ImpostazioniData(
        chiave: chiave ?? this.chiave,
        valore: valore ?? this.valore,
      );
  ImpostazioniData copyWithCompanion(ImpostazioniCompanion data) {
    return ImpostazioniData(
      chiave: data.chiave.present ? data.chiave.value : this.chiave,
      valore: data.valore.present ? data.valore.value : this.valore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImpostazioniData(')
          ..write('chiave: $chiave, ')
          ..write('valore: $valore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(chiave, valore);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImpostazioniData &&
          other.chiave == this.chiave &&
          other.valore == this.valore);
}

class ImpostazioniCompanion extends UpdateCompanion<ImpostazioniData> {
  final Value<String> chiave;
  final Value<String> valore;
  final Value<int> rowid;
  const ImpostazioniCompanion({
    this.chiave = const Value.absent(),
    this.valore = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImpostazioniCompanion.insert({
    required String chiave,
    required String valore,
    this.rowid = const Value.absent(),
  })  : chiave = Value(chiave),
        valore = Value(valore);
  static Insertable<ImpostazioniData> custom({
    Expression<String>? chiave,
    Expression<String>? valore,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (chiave != null) 'chiave': chiave,
      if (valore != null) 'valore': valore,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImpostazioniCompanion copyWith(
      {Value<String>? chiave, Value<String>? valore, Value<int>? rowid}) {
    return ImpostazioniCompanion(
      chiave: chiave ?? this.chiave,
      valore: valore ?? this.valore,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (chiave.present) {
      map['chiave'] = Variable<String>(chiave.value);
    }
    if (valore.present) {
      map['valore'] = Variable<String>(valore.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImpostazioniCompanion(')
          ..write('chiave: $chiave, ')
          ..write('valore: $valore, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CredenzialeSalvateTable extends CredenzialeSalvate
    with TableInfo<$CredenzialeSalvateTable, CredenzialeSalvateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CredenzialeSalvateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeVisualizzatoMeta =
      const VerificationMeta('nomeVisualizzato');
  @override
  late final GeneratedColumn<String> nomeVisualizzato = GeneratedColumn<String>(
      'nome_visualizzato', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _aziendaIdMeta =
      const VerificationMeta('aziendaId');
  @override
  late final GeneratedColumn<int> aziendaId = GeneratedColumn<int>(
      'azienda_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _codiceAziendaMeta =
      const VerificationMeta('codiceAzienda');
  @override
  late final GeneratedColumn<String> codiceAzienda = GeneratedColumn<String>(
      'codice_azienda', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ultimoUsoMeta =
      const VerificationMeta('ultimoUso');
  @override
  late final GeneratedColumn<DateTime> ultimoUso = GeneratedColumn<DateTime>(
      'ultimo_uso', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        username,
        password,
        nomeVisualizzato,
        aziendaId,
        codiceAzienda,
        ultimoUso
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credenziale_salvate';
  @override
  VerificationContext validateIntegrity(
      Insertable<CredenzialeSalvateData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('nome_visualizzato')) {
      context.handle(
          _nomeVisualizzatoMeta,
          nomeVisualizzato.isAcceptableOrUnknown(
              data['nome_visualizzato']!, _nomeVisualizzatoMeta));
    }
    if (data.containsKey('azienda_id')) {
      context.handle(_aziendaIdMeta,
          aziendaId.isAcceptableOrUnknown(data['azienda_id']!, _aziendaIdMeta));
    }
    if (data.containsKey('codice_azienda')) {
      context.handle(
          _codiceAziendaMeta,
          codiceAzienda.isAcceptableOrUnknown(
              data['codice_azienda']!, _codiceAziendaMeta));
    }
    if (data.containsKey('ultimo_uso')) {
      context.handle(_ultimoUsoMeta,
          ultimoUso.isAcceptableOrUnknown(data['ultimo_uso']!, _ultimoUsoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CredenzialeSalvateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CredenzialeSalvateData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      nomeVisualizzato: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}nome_visualizzato']),
      aziendaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}azienda_id']),
      codiceAzienda: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codice_azienda']),
      ultimoUso: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ultimo_uso'])!,
    );
  }

  @override
  $CredenzialeSalvateTable createAlias(String alias) {
    return $CredenzialeSalvateTable(attachedDatabase, alias);
  }
}

class CredenzialeSalvateData extends DataClass
    implements Insertable<CredenzialeSalvateData> {
  final int id;
  final String username;
  final String password;
  final String? nomeVisualizzato;
  final int? aziendaId;
  final String? codiceAzienda;
  final DateTime ultimoUso;
  const CredenzialeSalvateData(
      {required this.id,
      required this.username,
      required this.password,
      this.nomeVisualizzato,
      this.aziendaId,
      this.codiceAzienda,
      required this.ultimoUso});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    if (!nullToAbsent || nomeVisualizzato != null) {
      map['nome_visualizzato'] = Variable<String>(nomeVisualizzato);
    }
    if (!nullToAbsent || aziendaId != null) {
      map['azienda_id'] = Variable<int>(aziendaId);
    }
    if (!nullToAbsent || codiceAzienda != null) {
      map['codice_azienda'] = Variable<String>(codiceAzienda);
    }
    map['ultimo_uso'] = Variable<DateTime>(ultimoUso);
    return map;
  }

  CredenzialeSalvateCompanion toCompanion(bool nullToAbsent) {
    return CredenzialeSalvateCompanion(
      id: Value(id),
      username: Value(username),
      password: Value(password),
      nomeVisualizzato: nomeVisualizzato == null && nullToAbsent
          ? const Value.absent()
          : Value(nomeVisualizzato),
      aziendaId: aziendaId == null && nullToAbsent
          ? const Value.absent()
          : Value(aziendaId),
      codiceAzienda: codiceAzienda == null && nullToAbsent
          ? const Value.absent()
          : Value(codiceAzienda),
      ultimoUso: Value(ultimoUso),
    );
  }

  factory CredenzialeSalvateData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CredenzialeSalvateData(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      nomeVisualizzato: serializer.fromJson<String?>(json['nomeVisualizzato']),
      aziendaId: serializer.fromJson<int?>(json['aziendaId']),
      codiceAzienda: serializer.fromJson<String?>(json['codiceAzienda']),
      ultimoUso: serializer.fromJson<DateTime>(json['ultimoUso']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'nomeVisualizzato': serializer.toJson<String?>(nomeVisualizzato),
      'aziendaId': serializer.toJson<int?>(aziendaId),
      'codiceAzienda': serializer.toJson<String?>(codiceAzienda),
      'ultimoUso': serializer.toJson<DateTime>(ultimoUso),
    };
  }

  CredenzialeSalvateData copyWith(
          {int? id,
          String? username,
          String? password,
          Value<String?> nomeVisualizzato = const Value.absent(),
          Value<int?> aziendaId = const Value.absent(),
          Value<String?> codiceAzienda = const Value.absent(),
          DateTime? ultimoUso}) =>
      CredenzialeSalvateData(
        id: id ?? this.id,
        username: username ?? this.username,
        password: password ?? this.password,
        nomeVisualizzato: nomeVisualizzato.present
            ? nomeVisualizzato.value
            : this.nomeVisualizzato,
        aziendaId: aziendaId.present ? aziendaId.value : this.aziendaId,
        codiceAzienda:
            codiceAzienda.present ? codiceAzienda.value : this.codiceAzienda,
        ultimoUso: ultimoUso ?? this.ultimoUso,
      );
  CredenzialeSalvateData copyWithCompanion(CredenzialeSalvateCompanion data) {
    return CredenzialeSalvateData(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      nomeVisualizzato: data.nomeVisualizzato.present
          ? data.nomeVisualizzato.value
          : this.nomeVisualizzato,
      aziendaId: data.aziendaId.present ? data.aziendaId.value : this.aziendaId,
      codiceAzienda: data.codiceAzienda.present
          ? data.codiceAzienda.value
          : this.codiceAzienda,
      ultimoUso: data.ultimoUso.present ? data.ultimoUso.value : this.ultimoUso,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CredenzialeSalvateData(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('nomeVisualizzato: $nomeVisualizzato, ')
          ..write('aziendaId: $aziendaId, ')
          ..write('codiceAzienda: $codiceAzienda, ')
          ..write('ultimoUso: $ultimoUso')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, password, nomeVisualizzato,
      aziendaId, codiceAzienda, ultimoUso);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CredenzialeSalvateData &&
          other.id == this.id &&
          other.username == this.username &&
          other.password == this.password &&
          other.nomeVisualizzato == this.nomeVisualizzato &&
          other.aziendaId == this.aziendaId &&
          other.codiceAzienda == this.codiceAzienda &&
          other.ultimoUso == this.ultimoUso);
}

class CredenzialeSalvateCompanion
    extends UpdateCompanion<CredenzialeSalvateData> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> password;
  final Value<String?> nomeVisualizzato;
  final Value<int?> aziendaId;
  final Value<String?> codiceAzienda;
  final Value<DateTime> ultimoUso;
  const CredenzialeSalvateCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.nomeVisualizzato = const Value.absent(),
    this.aziendaId = const Value.absent(),
    this.codiceAzienda = const Value.absent(),
    this.ultimoUso = const Value.absent(),
  });
  CredenzialeSalvateCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String password,
    this.nomeVisualizzato = const Value.absent(),
    this.aziendaId = const Value.absent(),
    this.codiceAzienda = const Value.absent(),
    this.ultimoUso = const Value.absent(),
  })  : username = Value(username),
        password = Value(password);
  static Insertable<CredenzialeSalvateData> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? nomeVisualizzato,
    Expression<int>? aziendaId,
    Expression<String>? codiceAzienda,
    Expression<DateTime>? ultimoUso,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (nomeVisualizzato != null) 'nome_visualizzato': nomeVisualizzato,
      if (aziendaId != null) 'azienda_id': aziendaId,
      if (codiceAzienda != null) 'codice_azienda': codiceAzienda,
      if (ultimoUso != null) 'ultimo_uso': ultimoUso,
    });
  }

  CredenzialeSalvateCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String>? password,
      Value<String?>? nomeVisualizzato,
      Value<int?>? aziendaId,
      Value<String?>? codiceAzienda,
      Value<DateTime>? ultimoUso}) {
    return CredenzialeSalvateCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      nomeVisualizzato: nomeVisualizzato ?? this.nomeVisualizzato,
      aziendaId: aziendaId ?? this.aziendaId,
      codiceAzienda: codiceAzienda ?? this.codiceAzienda,
      ultimoUso: ultimoUso ?? this.ultimoUso,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (nomeVisualizzato.present) {
      map['nome_visualizzato'] = Variable<String>(nomeVisualizzato.value);
    }
    if (aziendaId.present) {
      map['azienda_id'] = Variable<int>(aziendaId.value);
    }
    if (codiceAzienda.present) {
      map['codice_azienda'] = Variable<String>(codiceAzienda.value);
    }
    if (ultimoUso.present) {
      map['ultimo_uso'] = Variable<DateTime>(ultimoUso.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CredenzialeSalvateCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('nomeVisualizzato: $nomeVisualizzato, ')
          ..write('aziendaId: $aziendaId, ')
          ..write('codiceAzienda: $codiceAzienda, ')
          ..write('ultimoUso: $ultimoUso')
          ..write(')'))
        .toString();
  }
}

abstract class _$ArchivioLocale extends GeneratedDatabase {
  _$ArchivioLocale(QueryExecutor e) : super(e);
  $ArchivioLocaleManager get managers => $ArchivioLocaleManager(this);
  late final $UtentiTable utenti = $UtentiTable(this);
  late final $EserciziTable esercizi = $EserciziTable(this);
  late final $SchedeTable schede = $SchedeTable(this);
  late final $SchedeEserciziTable schedeEsercizi = $SchedeEserciziTable(this);
  late final $SessioniAllenamentoTable sessioniAllenamento =
      $SessioniAllenamentoTable(this);
  late final $SerieRegistrateTable serieRegistrate =
      $SerieRegistrateTable(this);
  late final $MisurazioniTable misurazioni = $MisurazioniTable(this);
  late final $ImpostazioniTable impostazioni = $ImpostazioniTable(this);
  late final $CredenzialeSalvateTable credenzialeSalvate =
      $CredenzialeSalvateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        utenti,
        esercizi,
        schede,
        schedeEsercizi,
        sessioniAllenamento,
        serieRegistrate,
        misurazioni,
        impostazioni,
        credenzialeSalvate
      ];
}

typedef $$UtentiTableCreateCompanionBuilder = UtentiCompanion Function({
  Value<int> id,
  required String nome,
  Value<String?> email,
  Value<String?> username,
});
typedef $$UtentiTableUpdateCompanionBuilder = UtentiCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<String?> email,
  Value<String?> username,
});

final class $$UtentiTableReferences
    extends BaseReferences<_$ArchivioLocale, $UtentiTable, UtentiData> {
  $$UtentiTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SchedeTable, List<SchedeData>> _schedeRefsTable(
          _$ArchivioLocale db) =>
      MultiTypedResultKey.fromTable(db.schede,
          aliasName: $_aliasNameGenerator(db.utenti.id, db.schede.utenteId));

  $$SchedeTableProcessedTableManager get schedeRefs {
    final manager = $$SchedeTableTableManager($_db, $_db.schede)
        .filter((f) => f.utenteId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_schedeRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SessioniAllenamentoTable,
      List<SessioniAllenamentoData>> _sessioniAllenamentoRefsTable(
          _$ArchivioLocale db) =>
      MultiTypedResultKey.fromTable(db.sessioniAllenamento,
          aliasName: $_aliasNameGenerator(
              db.utenti.id, db.sessioniAllenamento.utenteId));

  $$SessioniAllenamentoTableProcessedTableManager get sessioniAllenamentoRefs {
    final manager =
        $$SessioniAllenamentoTableTableManager($_db, $_db.sessioniAllenamento)
            .filter((f) => f.utenteId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_sessioniAllenamentoRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MisurazioniTable, List<MisurazioniData>>
      _misurazioniRefsTable(_$ArchivioLocale db) =>
          MultiTypedResultKey.fromTable(db.misurazioni,
              aliasName:
                  $_aliasNameGenerator(db.utenti.id, db.misurazioni.utenteId));

  $$MisurazioniTableProcessedTableManager get misurazioniRefs {
    final manager = $$MisurazioniTableTableManager($_db, $_db.misurazioni)
        .filter((f) => f.utenteId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_misurazioniRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UtentiTableFilterComposer
    extends Composer<_$ArchivioLocale, $UtentiTable> {
  $$UtentiTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  Expression<bool> schedeRefs(
      Expression<bool> Function($$SchedeTableFilterComposer f) f) {
    final $$SchedeTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.schede,
        getReferencedColumn: (t) => t.utenteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedeTableFilterComposer(
              $db: $db,
              $table: $db.schede,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> sessioniAllenamentoRefs(
      Expression<bool> Function($$SessioniAllenamentoTableFilterComposer f) f) {
    final $$SessioniAllenamentoTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessioniAllenamento,
        getReferencedColumn: (t) => t.utenteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessioniAllenamentoTableFilterComposer(
              $db: $db,
              $table: $db.sessioniAllenamento,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> misurazioniRefs(
      Expression<bool> Function($$MisurazioniTableFilterComposer f) f) {
    final $$MisurazioniTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.misurazioni,
        getReferencedColumn: (t) => t.utenteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MisurazioniTableFilterComposer(
              $db: $db,
              $table: $db.misurazioni,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UtentiTableOrderingComposer
    extends Composer<_$ArchivioLocale, $UtentiTable> {
  $$UtentiTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));
}

class $$UtentiTableAnnotationComposer
    extends Composer<_$ArchivioLocale, $UtentiTable> {
  $$UtentiTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  Expression<T> schedeRefs<T extends Object>(
      Expression<T> Function($$SchedeTableAnnotationComposer a) f) {
    final $$SchedeTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.schede,
        getReferencedColumn: (t) => t.utenteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedeTableAnnotationComposer(
              $db: $db,
              $table: $db.schede,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> sessioniAllenamentoRefs<T extends Object>(
      Expression<T> Function($$SessioniAllenamentoTableAnnotationComposer a)
          f) {
    final $$SessioniAllenamentoTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.sessioniAllenamento,
            getReferencedColumn: (t) => t.utenteId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SessioniAllenamentoTableAnnotationComposer(
                  $db: $db,
                  $table: $db.sessioniAllenamento,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> misurazioniRefs<T extends Object>(
      Expression<T> Function($$MisurazioniTableAnnotationComposer a) f) {
    final $$MisurazioniTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.misurazioni,
        getReferencedColumn: (t) => t.utenteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MisurazioniTableAnnotationComposer(
              $db: $db,
              $table: $db.misurazioni,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UtentiTableTableManager extends RootTableManager<
    _$ArchivioLocale,
    $UtentiTable,
    UtentiData,
    $$UtentiTableFilterComposer,
    $$UtentiTableOrderingComposer,
    $$UtentiTableAnnotationComposer,
    $$UtentiTableCreateCompanionBuilder,
    $$UtentiTableUpdateCompanionBuilder,
    (UtentiData, $$UtentiTableReferences),
    UtentiData,
    PrefetchHooks Function(
        {bool schedeRefs,
        bool sessioniAllenamentoRefs,
        bool misurazioniRefs})> {
  $$UtentiTableTableManager(_$ArchivioLocale db, $UtentiTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UtentiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UtentiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UtentiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> username = const Value.absent(),
          }) =>
              UtentiCompanion(
            id: id,
            nome: nome,
            email: email,
            username: username,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nome,
            Value<String?> email = const Value.absent(),
            Value<String?> username = const Value.absent(),
          }) =>
              UtentiCompanion.insert(
            id: id,
            nome: nome,
            email: email,
            username: username,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UtentiTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {schedeRefs = false,
              sessioniAllenamentoRefs = false,
              misurazioniRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (schedeRefs) db.schede,
                if (sessioniAllenamentoRefs) db.sessioniAllenamento,
                if (misurazioniRefs) db.misurazioni
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (schedeRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$UtentiTableReferences._schedeRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UtentiTableReferences(db, table, p0).schedeRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.utenteId == item.id),
                        typedResults: items),
                  if (sessioniAllenamentoRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$UtentiTableReferences
                            ._sessioniAllenamentoRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UtentiTableReferences(db, table, p0)
                                .sessioniAllenamentoRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.utenteId == item.id),
                        typedResults: items),
                  if (misurazioniRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$UtentiTableReferences._misurazioniRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UtentiTableReferences(db, table, p0)
                                .misurazioniRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.utenteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UtentiTableProcessedTableManager = ProcessedTableManager<
    _$ArchivioLocale,
    $UtentiTable,
    UtentiData,
    $$UtentiTableFilterComposer,
    $$UtentiTableOrderingComposer,
    $$UtentiTableAnnotationComposer,
    $$UtentiTableCreateCompanionBuilder,
    $$UtentiTableUpdateCompanionBuilder,
    (UtentiData, $$UtentiTableReferences),
    UtentiData,
    PrefetchHooks Function(
        {bool schedeRefs, bool sessioniAllenamentoRefs, bool misurazioniRefs})>;
typedef $$EserciziTableCreateCompanionBuilder = EserciziCompanion Function({
  Value<int> id,
  required String nome,
  Value<String?> descrizione,
  Value<String?> muscoloObiettivo,
  required Attrezzo attrezzo,
  required GruppoMuscolare gruppoMuscolare,
  Value<double?> pesoObiettivo,
  Value<int?> durataMinuti,
  Value<String?> intensita,
  Value<String?> obiettivi,
  Value<String?> urlImmagine,
  Value<int?> recuperoSecondi,
});
typedef $$EserciziTableUpdateCompanionBuilder = EserciziCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<String?> descrizione,
  Value<String?> muscoloObiettivo,
  Value<Attrezzo> attrezzo,
  Value<GruppoMuscolare> gruppoMuscolare,
  Value<double?> pesoObiettivo,
  Value<int?> durataMinuti,
  Value<String?> intensita,
  Value<String?> obiettivi,
  Value<String?> urlImmagine,
  Value<int?> recuperoSecondi,
});

final class $$EserciziTableReferences
    extends BaseReferences<_$ArchivioLocale, $EserciziTable, EserciziData> {
  $$EserciziTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SchedeEserciziTable, List<SchedeEserciziData>>
      _schedeEserciziRefsTable(_$ArchivioLocale db) =>
          MultiTypedResultKey.fromTable(db.schedeEsercizi,
              aliasName: $_aliasNameGenerator(
                  db.esercizi.id, db.schedeEsercizi.esercizioId));

  $$SchedeEserciziTableProcessedTableManager get schedeEserciziRefs {
    final manager = $$SchedeEserciziTableTableManager($_db, $_db.schedeEsercizi)
        .filter((f) => f.esercizioId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_schedeEserciziRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SerieRegistrateTable, List<SerieRegistrateData>>
      _serieRegistrateRefsTable(_$ArchivioLocale db) =>
          MultiTypedResultKey.fromTable(db.serieRegistrate,
              aliasName: $_aliasNameGenerator(
                  db.esercizi.id, db.serieRegistrate.esercizioId));

  $$SerieRegistrateTableProcessedTableManager get serieRegistrateRefs {
    final manager =
        $$SerieRegistrateTableTableManager($_db, $_db.serieRegistrate)
            .filter((f) => f.esercizioId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_serieRegistrateRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EserciziTableFilterComposer
    extends Composer<_$ArchivioLocale, $EserciziTable> {
  $$EserciziTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descrizione => $composableBuilder(
      column: $table.descrizione, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get muscoloObiettivo => $composableBuilder(
      column: $table.muscoloObiettivo,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Attrezzo, Attrezzo, String> get attrezzo =>
      $composableBuilder(
          column: $table.attrezzo,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<GruppoMuscolare, GruppoMuscolare, String>
      get gruppoMuscolare => $composableBuilder(
          column: $table.gruppoMuscolare,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<double> get pesoObiettivo => $composableBuilder(
      column: $table.pesoObiettivo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durataMinuti => $composableBuilder(
      column: $table.durataMinuti, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get intensita => $composableBuilder(
      column: $table.intensita, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get obiettivi => $composableBuilder(
      column: $table.obiettivi, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get urlImmagine => $composableBuilder(
      column: $table.urlImmagine, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recuperoSecondi => $composableBuilder(
      column: $table.recuperoSecondi,
      builder: (column) => ColumnFilters(column));

  Expression<bool> schedeEserciziRefs(
      Expression<bool> Function($$SchedeEserciziTableFilterComposer f) f) {
    final $$SchedeEserciziTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.schedeEsercizi,
        getReferencedColumn: (t) => t.esercizioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedeEserciziTableFilterComposer(
              $db: $db,
              $table: $db.schedeEsercizi,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> serieRegistrateRefs(
      Expression<bool> Function($$SerieRegistrateTableFilterComposer f) f) {
    final $$SerieRegistrateTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serieRegistrate,
        getReferencedColumn: (t) => t.esercizioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SerieRegistrateTableFilterComposer(
              $db: $db,
              $table: $db.serieRegistrate,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EserciziTableOrderingComposer
    extends Composer<_$ArchivioLocale, $EserciziTable> {
  $$EserciziTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descrizione => $composableBuilder(
      column: $table.descrizione, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get muscoloObiettivo => $composableBuilder(
      column: $table.muscoloObiettivo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attrezzo => $composableBuilder(
      column: $table.attrezzo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gruppoMuscolare => $composableBuilder(
      column: $table.gruppoMuscolare,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pesoObiettivo => $composableBuilder(
      column: $table.pesoObiettivo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durataMinuti => $composableBuilder(
      column: $table.durataMinuti,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get intensita => $composableBuilder(
      column: $table.intensita, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get obiettivi => $composableBuilder(
      column: $table.obiettivi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get urlImmagine => $composableBuilder(
      column: $table.urlImmagine, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recuperoSecondi => $composableBuilder(
      column: $table.recuperoSecondi,
      builder: (column) => ColumnOrderings(column));
}

class $$EserciziTableAnnotationComposer
    extends Composer<_$ArchivioLocale, $EserciziTable> {
  $$EserciziTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get descrizione => $composableBuilder(
      column: $table.descrizione, builder: (column) => column);

  GeneratedColumn<String> get muscoloObiettivo => $composableBuilder(
      column: $table.muscoloObiettivo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Attrezzo, String> get attrezzo =>
      $composableBuilder(column: $table.attrezzo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GruppoMuscolare, String>
      get gruppoMuscolare => $composableBuilder(
          column: $table.gruppoMuscolare, builder: (column) => column);

  GeneratedColumn<double> get pesoObiettivo => $composableBuilder(
      column: $table.pesoObiettivo, builder: (column) => column);

  GeneratedColumn<int> get durataMinuti => $composableBuilder(
      column: $table.durataMinuti, builder: (column) => column);

  GeneratedColumn<String> get intensita =>
      $composableBuilder(column: $table.intensita, builder: (column) => column);

  GeneratedColumn<String> get obiettivi =>
      $composableBuilder(column: $table.obiettivi, builder: (column) => column);

  GeneratedColumn<String> get urlImmagine => $composableBuilder(
      column: $table.urlImmagine, builder: (column) => column);

  GeneratedColumn<int> get recuperoSecondi => $composableBuilder(
      column: $table.recuperoSecondi, builder: (column) => column);

  Expression<T> schedeEserciziRefs<T extends Object>(
      Expression<T> Function($$SchedeEserciziTableAnnotationComposer a) f) {
    final $$SchedeEserciziTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.schedeEsercizi,
        getReferencedColumn: (t) => t.esercizioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedeEserciziTableAnnotationComposer(
              $db: $db,
              $table: $db.schedeEsercizi,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> serieRegistrateRefs<T extends Object>(
      Expression<T> Function($$SerieRegistrateTableAnnotationComposer a) f) {
    final $$SerieRegistrateTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serieRegistrate,
        getReferencedColumn: (t) => t.esercizioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SerieRegistrateTableAnnotationComposer(
              $db: $db,
              $table: $db.serieRegistrate,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EserciziTableTableManager extends RootTableManager<
    _$ArchivioLocale,
    $EserciziTable,
    EserciziData,
    $$EserciziTableFilterComposer,
    $$EserciziTableOrderingComposer,
    $$EserciziTableAnnotationComposer,
    $$EserciziTableCreateCompanionBuilder,
    $$EserciziTableUpdateCompanionBuilder,
    (EserciziData, $$EserciziTableReferences),
    EserciziData,
    PrefetchHooks Function(
        {bool schedeEserciziRefs, bool serieRegistrateRefs})> {
  $$EserciziTableTableManager(_$ArchivioLocale db, $EserciziTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EserciziTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EserciziTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EserciziTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String?> descrizione = const Value.absent(),
            Value<String?> muscoloObiettivo = const Value.absent(),
            Value<Attrezzo> attrezzo = const Value.absent(),
            Value<GruppoMuscolare> gruppoMuscolare = const Value.absent(),
            Value<double?> pesoObiettivo = const Value.absent(),
            Value<int?> durataMinuti = const Value.absent(),
            Value<String?> intensita = const Value.absent(),
            Value<String?> obiettivi = const Value.absent(),
            Value<String?> urlImmagine = const Value.absent(),
            Value<int?> recuperoSecondi = const Value.absent(),
          }) =>
              EserciziCompanion(
            id: id,
            nome: nome,
            descrizione: descrizione,
            muscoloObiettivo: muscoloObiettivo,
            attrezzo: attrezzo,
            gruppoMuscolare: gruppoMuscolare,
            pesoObiettivo: pesoObiettivo,
            durataMinuti: durataMinuti,
            intensita: intensita,
            obiettivi: obiettivi,
            urlImmagine: urlImmagine,
            recuperoSecondi: recuperoSecondi,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nome,
            Value<String?> descrizione = const Value.absent(),
            Value<String?> muscoloObiettivo = const Value.absent(),
            required Attrezzo attrezzo,
            required GruppoMuscolare gruppoMuscolare,
            Value<double?> pesoObiettivo = const Value.absent(),
            Value<int?> durataMinuti = const Value.absent(),
            Value<String?> intensita = const Value.absent(),
            Value<String?> obiettivi = const Value.absent(),
            Value<String?> urlImmagine = const Value.absent(),
            Value<int?> recuperoSecondi = const Value.absent(),
          }) =>
              EserciziCompanion.insert(
            id: id,
            nome: nome,
            descrizione: descrizione,
            muscoloObiettivo: muscoloObiettivo,
            attrezzo: attrezzo,
            gruppoMuscolare: gruppoMuscolare,
            pesoObiettivo: pesoObiettivo,
            durataMinuti: durataMinuti,
            intensita: intensita,
            obiettivi: obiettivi,
            urlImmagine: urlImmagine,
            recuperoSecondi: recuperoSecondi,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$EserciziTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {schedeEserciziRefs = false, serieRegistrateRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (schedeEserciziRefs) db.schedeEsercizi,
                if (serieRegistrateRefs) db.serieRegistrate
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (schedeEserciziRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$EserciziTableReferences
                            ._schedeEserciziRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EserciziTableReferences(db, table, p0)
                                .schedeEserciziRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.esercizioId == item.id),
                        typedResults: items),
                  if (serieRegistrateRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$EserciziTableReferences
                            ._serieRegistrateRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EserciziTableReferences(db, table, p0)
                                .serieRegistrateRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.esercizioId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EserciziTableProcessedTableManager = ProcessedTableManager<
    _$ArchivioLocale,
    $EserciziTable,
    EserciziData,
    $$EserciziTableFilterComposer,
    $$EserciziTableOrderingComposer,
    $$EserciziTableAnnotationComposer,
    $$EserciziTableCreateCompanionBuilder,
    $$EserciziTableUpdateCompanionBuilder,
    (EserciziData, $$EserciziTableReferences),
    EserciziData,
    PrefetchHooks Function(
        {bool schedeEserciziRefs, bool serieRegistrateRefs})>;
typedef $$SchedeTableCreateCompanionBuilder = SchedeCompanion Function({
  Value<int> id,
  required String nomeScheda,
  Value<String?> descrizione,
  Value<String?> livelloDifficolta,
  required int utenteId,
  Value<bool> modello,
  Value<bool> attiva,
  Value<DateTime?> dataAssegnazione,
  Value<DateTime?> dataFine,
  Value<String?> noteAllenatore,
});
typedef $$SchedeTableUpdateCompanionBuilder = SchedeCompanion Function({
  Value<int> id,
  Value<String> nomeScheda,
  Value<String?> descrizione,
  Value<String?> livelloDifficolta,
  Value<int> utenteId,
  Value<bool> modello,
  Value<bool> attiva,
  Value<DateTime?> dataAssegnazione,
  Value<DateTime?> dataFine,
  Value<String?> noteAllenatore,
});

final class $$SchedeTableReferences
    extends BaseReferences<_$ArchivioLocale, $SchedeTable, SchedeData> {
  $$SchedeTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UtentiTable _utenteIdTable(_$ArchivioLocale db) => db.utenti
      .createAlias($_aliasNameGenerator(db.schede.utenteId, db.utenti.id));

  $$UtentiTableProcessedTableManager? get utenteId {
    if ($_item.utenteId == null) return null;
    final manager = $$UtentiTableTableManager($_db, $_db.utenti)
        .filter((f) => f.id($_item.utenteId!));
    final item = $_typedResult.readTableOrNull(_utenteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SchedeEserciziTable, List<SchedeEserciziData>>
      _schedeEserciziRefsTable(_$ArchivioLocale db) =>
          MultiTypedResultKey.fromTable(db.schedeEsercizi,
              aliasName: $_aliasNameGenerator(
                  db.schede.id, db.schedeEsercizi.schedaId));

  $$SchedeEserciziTableProcessedTableManager get schedeEserciziRefs {
    final manager = $$SchedeEserciziTableTableManager($_db, $_db.schedeEsercizi)
        .filter((f) => f.schedaId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_schedeEserciziRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SessioniAllenamentoTable,
      List<SessioniAllenamentoData>> _sessioniAllenamentoRefsTable(
          _$ArchivioLocale db) =>
      MultiTypedResultKey.fromTable(db.sessioniAllenamento,
          aliasName: $_aliasNameGenerator(
              db.schede.id, db.sessioniAllenamento.schedaId));

  $$SessioniAllenamentoTableProcessedTableManager get sessioniAllenamentoRefs {
    final manager =
        $$SessioniAllenamentoTableTableManager($_db, $_db.sessioniAllenamento)
            .filter((f) => f.schedaId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_sessioniAllenamentoRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SchedeTableFilterComposer
    extends Composer<_$ArchivioLocale, $SchedeTable> {
  $$SchedeTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomeScheda => $composableBuilder(
      column: $table.nomeScheda, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descrizione => $composableBuilder(
      column: $table.descrizione, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get livelloDifficolta => $composableBuilder(
      column: $table.livelloDifficolta,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get modello => $composableBuilder(
      column: $table.modello, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get attiva => $composableBuilder(
      column: $table.attiva, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataAssegnazione => $composableBuilder(
      column: $table.dataAssegnazione,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataFine => $composableBuilder(
      column: $table.dataFine, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noteAllenatore => $composableBuilder(
      column: $table.noteAllenatore,
      builder: (column) => ColumnFilters(column));

  $$UtentiTableFilterComposer get utenteId {
    final $$UtentiTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.utenteId,
        referencedTable: $db.utenti,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UtentiTableFilterComposer(
              $db: $db,
              $table: $db.utenti,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> schedeEserciziRefs(
      Expression<bool> Function($$SchedeEserciziTableFilterComposer f) f) {
    final $$SchedeEserciziTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.schedeEsercizi,
        getReferencedColumn: (t) => t.schedaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedeEserciziTableFilterComposer(
              $db: $db,
              $table: $db.schedeEsercizi,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> sessioniAllenamentoRefs(
      Expression<bool> Function($$SessioniAllenamentoTableFilterComposer f) f) {
    final $$SessioniAllenamentoTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessioniAllenamento,
        getReferencedColumn: (t) => t.schedaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessioniAllenamentoTableFilterComposer(
              $db: $db,
              $table: $db.sessioniAllenamento,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SchedeTableOrderingComposer
    extends Composer<_$ArchivioLocale, $SchedeTable> {
  $$SchedeTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomeScheda => $composableBuilder(
      column: $table.nomeScheda, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descrizione => $composableBuilder(
      column: $table.descrizione, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get livelloDifficolta => $composableBuilder(
      column: $table.livelloDifficolta,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get modello => $composableBuilder(
      column: $table.modello, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get attiva => $composableBuilder(
      column: $table.attiva, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataAssegnazione => $composableBuilder(
      column: $table.dataAssegnazione,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataFine => $composableBuilder(
      column: $table.dataFine, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noteAllenatore => $composableBuilder(
      column: $table.noteAllenatore,
      builder: (column) => ColumnOrderings(column));

  $$UtentiTableOrderingComposer get utenteId {
    final $$UtentiTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.utenteId,
        referencedTable: $db.utenti,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UtentiTableOrderingComposer(
              $db: $db,
              $table: $db.utenti,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SchedeTableAnnotationComposer
    extends Composer<_$ArchivioLocale, $SchedeTable> {
  $$SchedeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nomeScheda => $composableBuilder(
      column: $table.nomeScheda, builder: (column) => column);

  GeneratedColumn<String> get descrizione => $composableBuilder(
      column: $table.descrizione, builder: (column) => column);

  GeneratedColumn<String> get livelloDifficolta => $composableBuilder(
      column: $table.livelloDifficolta, builder: (column) => column);

  GeneratedColumn<bool> get modello =>
      $composableBuilder(column: $table.modello, builder: (column) => column);

  GeneratedColumn<bool> get attiva =>
      $composableBuilder(column: $table.attiva, builder: (column) => column);

  GeneratedColumn<DateTime> get dataAssegnazione => $composableBuilder(
      column: $table.dataAssegnazione, builder: (column) => column);

  GeneratedColumn<DateTime> get dataFine =>
      $composableBuilder(column: $table.dataFine, builder: (column) => column);

  GeneratedColumn<String> get noteAllenatore => $composableBuilder(
      column: $table.noteAllenatore, builder: (column) => column);

  $$UtentiTableAnnotationComposer get utenteId {
    final $$UtentiTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.utenteId,
        referencedTable: $db.utenti,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UtentiTableAnnotationComposer(
              $db: $db,
              $table: $db.utenti,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> schedeEserciziRefs<T extends Object>(
      Expression<T> Function($$SchedeEserciziTableAnnotationComposer a) f) {
    final $$SchedeEserciziTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.schedeEsercizi,
        getReferencedColumn: (t) => t.schedaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedeEserciziTableAnnotationComposer(
              $db: $db,
              $table: $db.schedeEsercizi,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> sessioniAllenamentoRefs<T extends Object>(
      Expression<T> Function($$SessioniAllenamentoTableAnnotationComposer a)
          f) {
    final $$SessioniAllenamentoTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.sessioniAllenamento,
            getReferencedColumn: (t) => t.schedaId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SessioniAllenamentoTableAnnotationComposer(
                  $db: $db,
                  $table: $db.sessioniAllenamento,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$SchedeTableTableManager extends RootTableManager<
    _$ArchivioLocale,
    $SchedeTable,
    SchedeData,
    $$SchedeTableFilterComposer,
    $$SchedeTableOrderingComposer,
    $$SchedeTableAnnotationComposer,
    $$SchedeTableCreateCompanionBuilder,
    $$SchedeTableUpdateCompanionBuilder,
    (SchedeData, $$SchedeTableReferences),
    SchedeData,
    PrefetchHooks Function(
        {bool utenteId,
        bool schedeEserciziRefs,
        bool sessioniAllenamentoRefs})> {
  $$SchedeTableTableManager(_$ArchivioLocale db, $SchedeTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchedeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchedeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchedeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nomeScheda = const Value.absent(),
            Value<String?> descrizione = const Value.absent(),
            Value<String?> livelloDifficolta = const Value.absent(),
            Value<int> utenteId = const Value.absent(),
            Value<bool> modello = const Value.absent(),
            Value<bool> attiva = const Value.absent(),
            Value<DateTime?> dataAssegnazione = const Value.absent(),
            Value<DateTime?> dataFine = const Value.absent(),
            Value<String?> noteAllenatore = const Value.absent(),
          }) =>
              SchedeCompanion(
            id: id,
            nomeScheda: nomeScheda,
            descrizione: descrizione,
            livelloDifficolta: livelloDifficolta,
            utenteId: utenteId,
            modello: modello,
            attiva: attiva,
            dataAssegnazione: dataAssegnazione,
            dataFine: dataFine,
            noteAllenatore: noteAllenatore,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nomeScheda,
            Value<String?> descrizione = const Value.absent(),
            Value<String?> livelloDifficolta = const Value.absent(),
            required int utenteId,
            Value<bool> modello = const Value.absent(),
            Value<bool> attiva = const Value.absent(),
            Value<DateTime?> dataAssegnazione = const Value.absent(),
            Value<DateTime?> dataFine = const Value.absent(),
            Value<String?> noteAllenatore = const Value.absent(),
          }) =>
              SchedeCompanion.insert(
            id: id,
            nomeScheda: nomeScheda,
            descrizione: descrizione,
            livelloDifficolta: livelloDifficolta,
            utenteId: utenteId,
            modello: modello,
            attiva: attiva,
            dataAssegnazione: dataAssegnazione,
            dataFine: dataFine,
            noteAllenatore: noteAllenatore,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SchedeTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {utenteId = false,
              schedeEserciziRefs = false,
              sessioniAllenamentoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (schedeEserciziRefs) db.schedeEsercizi,
                if (sessioniAllenamentoRefs) db.sessioniAllenamento
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (utenteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.utenteId,
                    referencedTable: $$SchedeTableReferences._utenteIdTable(db),
                    referencedColumn:
                        $$SchedeTableReferences._utenteIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (schedeEserciziRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$SchedeTableReferences
                            ._schedeEserciziRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SchedeTableReferences(db, table, p0)
                                .schedeEserciziRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.schedaId == item.id),
                        typedResults: items),
                  if (sessioniAllenamentoRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$SchedeTableReferences
                            ._sessioniAllenamentoRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SchedeTableReferences(db, table, p0)
                                .sessioniAllenamentoRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.schedaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SchedeTableProcessedTableManager = ProcessedTableManager<
    _$ArchivioLocale,
    $SchedeTable,
    SchedeData,
    $$SchedeTableFilterComposer,
    $$SchedeTableOrderingComposer,
    $$SchedeTableAnnotationComposer,
    $$SchedeTableCreateCompanionBuilder,
    $$SchedeTableUpdateCompanionBuilder,
    (SchedeData, $$SchedeTableReferences),
    SchedeData,
    PrefetchHooks Function(
        {bool utenteId,
        bool schedeEserciziRefs,
        bool sessioniAllenamentoRefs})>;
typedef $$SchedeEserciziTableCreateCompanionBuilder = SchedeEserciziCompanion
    Function({
  Value<int> id,
  required int schedaId,
  required int esercizioId,
  Value<String> sezione,
  Value<int> ordineSezione,
  Value<int> ordineEsercizio,
  Value<int> serie,
  Value<int> ripetizioni,
  Value<String?> ripetizioniPiramidali,
  Value<double?> peso,
  Value<int?> durataMinuti,
  Value<String?> noteAllenatore,
});
typedef $$SchedeEserciziTableUpdateCompanionBuilder = SchedeEserciziCompanion
    Function({
  Value<int> id,
  Value<int> schedaId,
  Value<int> esercizioId,
  Value<String> sezione,
  Value<int> ordineSezione,
  Value<int> ordineEsercizio,
  Value<int> serie,
  Value<int> ripetizioni,
  Value<String?> ripetizioniPiramidali,
  Value<double?> peso,
  Value<int?> durataMinuti,
  Value<String?> noteAllenatore,
});

final class $$SchedeEserciziTableReferences extends BaseReferences<
    _$ArchivioLocale, $SchedeEserciziTable, SchedeEserciziData> {
  $$SchedeEserciziTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SchedeTable _schedaIdTable(_$ArchivioLocale db) =>
      db.schede.createAlias(
          $_aliasNameGenerator(db.schedeEsercizi.schedaId, db.schede.id));

  $$SchedeTableProcessedTableManager? get schedaId {
    if ($_item.schedaId == null) return null;
    final manager = $$SchedeTableTableManager($_db, $_db.schede)
        .filter((f) => f.id($_item.schedaId!));
    final item = $_typedResult.readTableOrNull(_schedaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $EserciziTable _esercizioIdTable(_$ArchivioLocale db) =>
      db.esercizi.createAlias(
          $_aliasNameGenerator(db.schedeEsercizi.esercizioId, db.esercizi.id));

  $$EserciziTableProcessedTableManager? get esercizioId {
    if ($_item.esercizioId == null) return null;
    final manager = $$EserciziTableTableManager($_db, $_db.esercizi)
        .filter((f) => f.id($_item.esercizioId!));
    final item = $_typedResult.readTableOrNull(_esercizioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SchedeEserciziTableFilterComposer
    extends Composer<_$ArchivioLocale, $SchedeEserciziTable> {
  $$SchedeEserciziTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sezione => $composableBuilder(
      column: $table.sezione, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ordineSezione => $composableBuilder(
      column: $table.ordineSezione, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ordineEsercizio => $composableBuilder(
      column: $table.ordineEsercizio,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serie => $composableBuilder(
      column: $table.serie, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ripetizioni => $composableBuilder(
      column: $table.ripetizioni, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ripetizioniPiramidali => $composableBuilder(
      column: $table.ripetizioniPiramidali,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get peso => $composableBuilder(
      column: $table.peso, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durataMinuti => $composableBuilder(
      column: $table.durataMinuti, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noteAllenatore => $composableBuilder(
      column: $table.noteAllenatore,
      builder: (column) => ColumnFilters(column));

  $$SchedeTableFilterComposer get schedaId {
    final $$SchedeTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schedaId,
        referencedTable: $db.schede,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedeTableFilterComposer(
              $db: $db,
              $table: $db.schede,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EserciziTableFilterComposer get esercizioId {
    final $$EserciziTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.esercizioId,
        referencedTable: $db.esercizi,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EserciziTableFilterComposer(
              $db: $db,
              $table: $db.esercizi,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SchedeEserciziTableOrderingComposer
    extends Composer<_$ArchivioLocale, $SchedeEserciziTable> {
  $$SchedeEserciziTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sezione => $composableBuilder(
      column: $table.sezione, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ordineSezione => $composableBuilder(
      column: $table.ordineSezione,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ordineEsercizio => $composableBuilder(
      column: $table.ordineEsercizio,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serie => $composableBuilder(
      column: $table.serie, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ripetizioni => $composableBuilder(
      column: $table.ripetizioni, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ripetizioniPiramidali => $composableBuilder(
      column: $table.ripetizioniPiramidali,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get peso => $composableBuilder(
      column: $table.peso, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durataMinuti => $composableBuilder(
      column: $table.durataMinuti,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noteAllenatore => $composableBuilder(
      column: $table.noteAllenatore,
      builder: (column) => ColumnOrderings(column));

  $$SchedeTableOrderingComposer get schedaId {
    final $$SchedeTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schedaId,
        referencedTable: $db.schede,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedeTableOrderingComposer(
              $db: $db,
              $table: $db.schede,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EserciziTableOrderingComposer get esercizioId {
    final $$EserciziTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.esercizioId,
        referencedTable: $db.esercizi,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EserciziTableOrderingComposer(
              $db: $db,
              $table: $db.esercizi,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SchedeEserciziTableAnnotationComposer
    extends Composer<_$ArchivioLocale, $SchedeEserciziTable> {
  $$SchedeEserciziTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sezione =>
      $composableBuilder(column: $table.sezione, builder: (column) => column);

  GeneratedColumn<int> get ordineSezione => $composableBuilder(
      column: $table.ordineSezione, builder: (column) => column);

  GeneratedColumn<int> get ordineEsercizio => $composableBuilder(
      column: $table.ordineEsercizio, builder: (column) => column);

  GeneratedColumn<int> get serie =>
      $composableBuilder(column: $table.serie, builder: (column) => column);

  GeneratedColumn<int> get ripetizioni => $composableBuilder(
      column: $table.ripetizioni, builder: (column) => column);

  GeneratedColumn<String> get ripetizioniPiramidali => $composableBuilder(
      column: $table.ripetizioniPiramidali, builder: (column) => column);

  GeneratedColumn<double> get peso =>
      $composableBuilder(column: $table.peso, builder: (column) => column);

  GeneratedColumn<int> get durataMinuti => $composableBuilder(
      column: $table.durataMinuti, builder: (column) => column);

  GeneratedColumn<String> get noteAllenatore => $composableBuilder(
      column: $table.noteAllenatore, builder: (column) => column);

  $$SchedeTableAnnotationComposer get schedaId {
    final $$SchedeTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schedaId,
        referencedTable: $db.schede,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedeTableAnnotationComposer(
              $db: $db,
              $table: $db.schede,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EserciziTableAnnotationComposer get esercizioId {
    final $$EserciziTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.esercizioId,
        referencedTable: $db.esercizi,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EserciziTableAnnotationComposer(
              $db: $db,
              $table: $db.esercizi,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SchedeEserciziTableTableManager extends RootTableManager<
    _$ArchivioLocale,
    $SchedeEserciziTable,
    SchedeEserciziData,
    $$SchedeEserciziTableFilterComposer,
    $$SchedeEserciziTableOrderingComposer,
    $$SchedeEserciziTableAnnotationComposer,
    $$SchedeEserciziTableCreateCompanionBuilder,
    $$SchedeEserciziTableUpdateCompanionBuilder,
    (SchedeEserciziData, $$SchedeEserciziTableReferences),
    SchedeEserciziData,
    PrefetchHooks Function({bool schedaId, bool esercizioId})> {
  $$SchedeEserciziTableTableManager(
      _$ArchivioLocale db, $SchedeEserciziTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchedeEserciziTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchedeEserciziTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchedeEserciziTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> schedaId = const Value.absent(),
            Value<int> esercizioId = const Value.absent(),
            Value<String> sezione = const Value.absent(),
            Value<int> ordineSezione = const Value.absent(),
            Value<int> ordineEsercizio = const Value.absent(),
            Value<int> serie = const Value.absent(),
            Value<int> ripetizioni = const Value.absent(),
            Value<String?> ripetizioniPiramidali = const Value.absent(),
            Value<double?> peso = const Value.absent(),
            Value<int?> durataMinuti = const Value.absent(),
            Value<String?> noteAllenatore = const Value.absent(),
          }) =>
              SchedeEserciziCompanion(
            id: id,
            schedaId: schedaId,
            esercizioId: esercizioId,
            sezione: sezione,
            ordineSezione: ordineSezione,
            ordineEsercizio: ordineEsercizio,
            serie: serie,
            ripetizioni: ripetizioni,
            ripetizioniPiramidali: ripetizioniPiramidali,
            peso: peso,
            durataMinuti: durataMinuti,
            noteAllenatore: noteAllenatore,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int schedaId,
            required int esercizioId,
            Value<String> sezione = const Value.absent(),
            Value<int> ordineSezione = const Value.absent(),
            Value<int> ordineEsercizio = const Value.absent(),
            Value<int> serie = const Value.absent(),
            Value<int> ripetizioni = const Value.absent(),
            Value<String?> ripetizioniPiramidali = const Value.absent(),
            Value<double?> peso = const Value.absent(),
            Value<int?> durataMinuti = const Value.absent(),
            Value<String?> noteAllenatore = const Value.absent(),
          }) =>
              SchedeEserciziCompanion.insert(
            id: id,
            schedaId: schedaId,
            esercizioId: esercizioId,
            sezione: sezione,
            ordineSezione: ordineSezione,
            ordineEsercizio: ordineEsercizio,
            serie: serie,
            ripetizioni: ripetizioni,
            ripetizioniPiramidali: ripetizioniPiramidali,
            peso: peso,
            durataMinuti: durataMinuti,
            noteAllenatore: noteAllenatore,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SchedeEserciziTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({schedaId = false, esercizioId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (schedaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.schedaId,
                    referencedTable:
                        $$SchedeEserciziTableReferences._schedaIdTable(db),
                    referencedColumn:
                        $$SchedeEserciziTableReferences._schedaIdTable(db).id,
                  ) as T;
                }
                if (esercizioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.esercizioId,
                    referencedTable:
                        $$SchedeEserciziTableReferences._esercizioIdTable(db),
                    referencedColumn: $$SchedeEserciziTableReferences
                        ._esercizioIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SchedeEserciziTableProcessedTableManager = ProcessedTableManager<
    _$ArchivioLocale,
    $SchedeEserciziTable,
    SchedeEserciziData,
    $$SchedeEserciziTableFilterComposer,
    $$SchedeEserciziTableOrderingComposer,
    $$SchedeEserciziTableAnnotationComposer,
    $$SchedeEserciziTableCreateCompanionBuilder,
    $$SchedeEserciziTableUpdateCompanionBuilder,
    (SchedeEserciziData, $$SchedeEserciziTableReferences),
    SchedeEserciziData,
    PrefetchHooks Function({bool schedaId, bool esercizioId})>;
typedef $$SessioniAllenamentoTableCreateCompanionBuilder
    = SessioniAllenamentoCompanion Function({
  Value<int> id,
  Value<int?> schedaId,
  required int utenteId,
  required DateTime inizio,
  Value<DateTime?> fine,
  Value<String?> note,
  Value<bool> completata,
  Value<bool> sincronizzata,
});
typedef $$SessioniAllenamentoTableUpdateCompanionBuilder
    = SessioniAllenamentoCompanion Function({
  Value<int> id,
  Value<int?> schedaId,
  Value<int> utenteId,
  Value<DateTime> inizio,
  Value<DateTime?> fine,
  Value<String?> note,
  Value<bool> completata,
  Value<bool> sincronizzata,
});

final class $$SessioniAllenamentoTableReferences extends BaseReferences<
    _$ArchivioLocale, $SessioniAllenamentoTable, SessioniAllenamentoData> {
  $$SessioniAllenamentoTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SchedeTable _schedaIdTable(_$ArchivioLocale db) =>
      db.schede.createAlias(
          $_aliasNameGenerator(db.sessioniAllenamento.schedaId, db.schede.id));

  $$SchedeTableProcessedTableManager? get schedaId {
    if ($_item.schedaId == null) return null;
    final manager = $$SchedeTableTableManager($_db, $_db.schede)
        .filter((f) => f.id($_item.schedaId!));
    final item = $_typedResult.readTableOrNull(_schedaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UtentiTable _utenteIdTable(_$ArchivioLocale db) =>
      db.utenti.createAlias(
          $_aliasNameGenerator(db.sessioniAllenamento.utenteId, db.utenti.id));

  $$UtentiTableProcessedTableManager? get utenteId {
    if ($_item.utenteId == null) return null;
    final manager = $$UtentiTableTableManager($_db, $_db.utenti)
        .filter((f) => f.id($_item.utenteId!));
    final item = $_typedResult.readTableOrNull(_utenteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SerieRegistrateTable, List<SerieRegistrateData>>
      _serieRegistrateRefsTable(_$ArchivioLocale db) =>
          MultiTypedResultKey.fromTable(db.serieRegistrate,
              aliasName: $_aliasNameGenerator(
                  db.sessioniAllenamento.id, db.serieRegistrate.sessioneId));

  $$SerieRegistrateTableProcessedTableManager get serieRegistrateRefs {
    final manager =
        $$SerieRegistrateTableTableManager($_db, $_db.serieRegistrate)
            .filter((f) => f.sessioneId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_serieRegistrateRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SessioniAllenamentoTableFilterComposer
    extends Composer<_$ArchivioLocale, $SessioniAllenamentoTable> {
  $$SessioniAllenamentoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get inizio => $composableBuilder(
      column: $table.inizio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fine => $composableBuilder(
      column: $table.fine, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completata => $composableBuilder(
      column: $table.completata, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get sincronizzata => $composableBuilder(
      column: $table.sincronizzata, builder: (column) => ColumnFilters(column));

  $$SchedeTableFilterComposer get schedaId {
    final $$SchedeTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schedaId,
        referencedTable: $db.schede,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedeTableFilterComposer(
              $db: $db,
              $table: $db.schede,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UtentiTableFilterComposer get utenteId {
    final $$UtentiTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.utenteId,
        referencedTable: $db.utenti,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UtentiTableFilterComposer(
              $db: $db,
              $table: $db.utenti,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> serieRegistrateRefs(
      Expression<bool> Function($$SerieRegistrateTableFilterComposer f) f) {
    final $$SerieRegistrateTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serieRegistrate,
        getReferencedColumn: (t) => t.sessioneId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SerieRegistrateTableFilterComposer(
              $db: $db,
              $table: $db.serieRegistrate,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SessioniAllenamentoTableOrderingComposer
    extends Composer<_$ArchivioLocale, $SessioniAllenamentoTable> {
  $$SessioniAllenamentoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get inizio => $composableBuilder(
      column: $table.inizio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fine => $composableBuilder(
      column: $table.fine, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completata => $composableBuilder(
      column: $table.completata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get sincronizzata => $composableBuilder(
      column: $table.sincronizzata,
      builder: (column) => ColumnOrderings(column));

  $$SchedeTableOrderingComposer get schedaId {
    final $$SchedeTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schedaId,
        referencedTable: $db.schede,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedeTableOrderingComposer(
              $db: $db,
              $table: $db.schede,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UtentiTableOrderingComposer get utenteId {
    final $$UtentiTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.utenteId,
        referencedTable: $db.utenti,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UtentiTableOrderingComposer(
              $db: $db,
              $table: $db.utenti,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessioniAllenamentoTableAnnotationComposer
    extends Composer<_$ArchivioLocale, $SessioniAllenamentoTable> {
  $$SessioniAllenamentoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get inizio =>
      $composableBuilder(column: $table.inizio, builder: (column) => column);

  GeneratedColumn<DateTime> get fine =>
      $composableBuilder(column: $table.fine, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get completata => $composableBuilder(
      column: $table.completata, builder: (column) => column);

  GeneratedColumn<bool> get sincronizzata => $composableBuilder(
      column: $table.sincronizzata, builder: (column) => column);

  $$SchedeTableAnnotationComposer get schedaId {
    final $$SchedeTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schedaId,
        referencedTable: $db.schede,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchedeTableAnnotationComposer(
              $db: $db,
              $table: $db.schede,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UtentiTableAnnotationComposer get utenteId {
    final $$UtentiTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.utenteId,
        referencedTable: $db.utenti,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UtentiTableAnnotationComposer(
              $db: $db,
              $table: $db.utenti,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> serieRegistrateRefs<T extends Object>(
      Expression<T> Function($$SerieRegistrateTableAnnotationComposer a) f) {
    final $$SerieRegistrateTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serieRegistrate,
        getReferencedColumn: (t) => t.sessioneId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SerieRegistrateTableAnnotationComposer(
              $db: $db,
              $table: $db.serieRegistrate,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SessioniAllenamentoTableTableManager extends RootTableManager<
    _$ArchivioLocale,
    $SessioniAllenamentoTable,
    SessioniAllenamentoData,
    $$SessioniAllenamentoTableFilterComposer,
    $$SessioniAllenamentoTableOrderingComposer,
    $$SessioniAllenamentoTableAnnotationComposer,
    $$SessioniAllenamentoTableCreateCompanionBuilder,
    $$SessioniAllenamentoTableUpdateCompanionBuilder,
    (SessioniAllenamentoData, $$SessioniAllenamentoTableReferences),
    SessioniAllenamentoData,
    PrefetchHooks Function(
        {bool schedaId, bool utenteId, bool serieRegistrateRefs})> {
  $$SessioniAllenamentoTableTableManager(
      _$ArchivioLocale db, $SessioniAllenamentoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessioniAllenamentoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessioniAllenamentoTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessioniAllenamentoTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> schedaId = const Value.absent(),
            Value<int> utenteId = const Value.absent(),
            Value<DateTime> inizio = const Value.absent(),
            Value<DateTime?> fine = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> completata = const Value.absent(),
            Value<bool> sincronizzata = const Value.absent(),
          }) =>
              SessioniAllenamentoCompanion(
            id: id,
            schedaId: schedaId,
            utenteId: utenteId,
            inizio: inizio,
            fine: fine,
            note: note,
            completata: completata,
            sincronizzata: sincronizzata,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> schedaId = const Value.absent(),
            required int utenteId,
            required DateTime inizio,
            Value<DateTime?> fine = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> completata = const Value.absent(),
            Value<bool> sincronizzata = const Value.absent(),
          }) =>
              SessioniAllenamentoCompanion.insert(
            id: id,
            schedaId: schedaId,
            utenteId: utenteId,
            inizio: inizio,
            fine: fine,
            note: note,
            completata: completata,
            sincronizzata: sincronizzata,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SessioniAllenamentoTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {schedaId = false,
              utenteId = false,
              serieRegistrateRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (serieRegistrateRefs) db.serieRegistrate
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (schedaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.schedaId,
                    referencedTable:
                        $$SessioniAllenamentoTableReferences._schedaIdTable(db),
                    referencedColumn: $$SessioniAllenamentoTableReferences
                        ._schedaIdTable(db)
                        .id,
                  ) as T;
                }
                if (utenteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.utenteId,
                    referencedTable:
                        $$SessioniAllenamentoTableReferences._utenteIdTable(db),
                    referencedColumn: $$SessioniAllenamentoTableReferences
                        ._utenteIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (serieRegistrateRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$SessioniAllenamentoTableReferences
                            ._serieRegistrateRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SessioniAllenamentoTableReferences(db, table, p0)
                                .serieRegistrateRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessioneId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SessioniAllenamentoTableProcessedTableManager = ProcessedTableManager<
    _$ArchivioLocale,
    $SessioniAllenamentoTable,
    SessioniAllenamentoData,
    $$SessioniAllenamentoTableFilterComposer,
    $$SessioniAllenamentoTableOrderingComposer,
    $$SessioniAllenamentoTableAnnotationComposer,
    $$SessioniAllenamentoTableCreateCompanionBuilder,
    $$SessioniAllenamentoTableUpdateCompanionBuilder,
    (SessioniAllenamentoData, $$SessioniAllenamentoTableReferences),
    SessioniAllenamentoData,
    PrefetchHooks Function(
        {bool schedaId, bool utenteId, bool serieRegistrateRefs})>;
typedef $$SerieRegistrateTableCreateCompanionBuilder = SerieRegistrateCompanion
    Function({
  Value<int> id,
  required int sessioneId,
  required int esercizioId,
  required int indiceSerie,
  required int ripetizioni,
  Value<String?> ripetizioniTesto,
  Value<double?> peso,
  Value<double?> rpe,
  Value<int?> secondiTempo,
  Value<String?> note,
  Value<DateTime> dataOra,
});
typedef $$SerieRegistrateTableUpdateCompanionBuilder = SerieRegistrateCompanion
    Function({
  Value<int> id,
  Value<int> sessioneId,
  Value<int> esercizioId,
  Value<int> indiceSerie,
  Value<int> ripetizioni,
  Value<String?> ripetizioniTesto,
  Value<double?> peso,
  Value<double?> rpe,
  Value<int?> secondiTempo,
  Value<String?> note,
  Value<DateTime> dataOra,
});

final class $$SerieRegistrateTableReferences extends BaseReferences<
    _$ArchivioLocale, $SerieRegistrateTable, SerieRegistrateData> {
  $$SerieRegistrateTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SessioniAllenamentoTable _sessioneIdTable(_$ArchivioLocale db) =>
      db.sessioniAllenamento.createAlias($_aliasNameGenerator(
          db.serieRegistrate.sessioneId, db.sessioniAllenamento.id));

  $$SessioniAllenamentoTableProcessedTableManager? get sessioneId {
    if ($_item.sessioneId == null) return null;
    final manager =
        $$SessioniAllenamentoTableTableManager($_db, $_db.sessioniAllenamento)
            .filter((f) => f.id($_item.sessioneId!));
    final item = $_typedResult.readTableOrNull(_sessioneIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $EserciziTable _esercizioIdTable(_$ArchivioLocale db) =>
      db.esercizi.createAlias(
          $_aliasNameGenerator(db.serieRegistrate.esercizioId, db.esercizi.id));

  $$EserciziTableProcessedTableManager? get esercizioId {
    if ($_item.esercizioId == null) return null;
    final manager = $$EserciziTableTableManager($_db, $_db.esercizi)
        .filter((f) => f.id($_item.esercizioId!));
    final item = $_typedResult.readTableOrNull(_esercizioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SerieRegistrateTableFilterComposer
    extends Composer<_$ArchivioLocale, $SerieRegistrateTable> {
  $$SerieRegistrateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get indiceSerie => $composableBuilder(
      column: $table.indiceSerie, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ripetizioni => $composableBuilder(
      column: $table.ripetizioni, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ripetizioniTesto => $composableBuilder(
      column: $table.ripetizioniTesto,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get peso => $composableBuilder(
      column: $table.peso, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rpe => $composableBuilder(
      column: $table.rpe, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get secondiTempo => $composableBuilder(
      column: $table.secondiTempo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataOra => $composableBuilder(
      column: $table.dataOra, builder: (column) => ColumnFilters(column));

  $$SessioniAllenamentoTableFilterComposer get sessioneId {
    final $$SessioniAllenamentoTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessioneId,
        referencedTable: $db.sessioniAllenamento,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessioniAllenamentoTableFilterComposer(
              $db: $db,
              $table: $db.sessioniAllenamento,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EserciziTableFilterComposer get esercizioId {
    final $$EserciziTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.esercizioId,
        referencedTable: $db.esercizi,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EserciziTableFilterComposer(
              $db: $db,
              $table: $db.esercizi,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SerieRegistrateTableOrderingComposer
    extends Composer<_$ArchivioLocale, $SerieRegistrateTable> {
  $$SerieRegistrateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get indiceSerie => $composableBuilder(
      column: $table.indiceSerie, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ripetizioni => $composableBuilder(
      column: $table.ripetizioni, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ripetizioniTesto => $composableBuilder(
      column: $table.ripetizioniTesto,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get peso => $composableBuilder(
      column: $table.peso, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rpe => $composableBuilder(
      column: $table.rpe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get secondiTempo => $composableBuilder(
      column: $table.secondiTempo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataOra => $composableBuilder(
      column: $table.dataOra, builder: (column) => ColumnOrderings(column));

  $$SessioniAllenamentoTableOrderingComposer get sessioneId {
    final $$SessioniAllenamentoTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.sessioneId,
            referencedTable: $db.sessioniAllenamento,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SessioniAllenamentoTableOrderingComposer(
                  $db: $db,
                  $table: $db.sessioniAllenamento,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$EserciziTableOrderingComposer get esercizioId {
    final $$EserciziTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.esercizioId,
        referencedTable: $db.esercizi,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EserciziTableOrderingComposer(
              $db: $db,
              $table: $db.esercizi,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SerieRegistrateTableAnnotationComposer
    extends Composer<_$ArchivioLocale, $SerieRegistrateTable> {
  $$SerieRegistrateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get indiceSerie => $composableBuilder(
      column: $table.indiceSerie, builder: (column) => column);

  GeneratedColumn<int> get ripetizioni => $composableBuilder(
      column: $table.ripetizioni, builder: (column) => column);

  GeneratedColumn<String> get ripetizioniTesto => $composableBuilder(
      column: $table.ripetizioniTesto, builder: (column) => column);

  GeneratedColumn<double> get peso =>
      $composableBuilder(column: $table.peso, builder: (column) => column);

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<int> get secondiTempo => $composableBuilder(
      column: $table.secondiTempo, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get dataOra =>
      $composableBuilder(column: $table.dataOra, builder: (column) => column);

  $$SessioniAllenamentoTableAnnotationComposer get sessioneId {
    final $$SessioniAllenamentoTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.sessioneId,
            referencedTable: $db.sessioniAllenamento,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SessioniAllenamentoTableAnnotationComposer(
                  $db: $db,
                  $table: $db.sessioniAllenamento,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$EserciziTableAnnotationComposer get esercizioId {
    final $$EserciziTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.esercizioId,
        referencedTable: $db.esercizi,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EserciziTableAnnotationComposer(
              $db: $db,
              $table: $db.esercizi,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SerieRegistrateTableTableManager extends RootTableManager<
    _$ArchivioLocale,
    $SerieRegistrateTable,
    SerieRegistrateData,
    $$SerieRegistrateTableFilterComposer,
    $$SerieRegistrateTableOrderingComposer,
    $$SerieRegistrateTableAnnotationComposer,
    $$SerieRegistrateTableCreateCompanionBuilder,
    $$SerieRegistrateTableUpdateCompanionBuilder,
    (SerieRegistrateData, $$SerieRegistrateTableReferences),
    SerieRegistrateData,
    PrefetchHooks Function({bool sessioneId, bool esercizioId})> {
  $$SerieRegistrateTableTableManager(
      _$ArchivioLocale db, $SerieRegistrateTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SerieRegistrateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SerieRegistrateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SerieRegistrateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessioneId = const Value.absent(),
            Value<int> esercizioId = const Value.absent(),
            Value<int> indiceSerie = const Value.absent(),
            Value<int> ripetizioni = const Value.absent(),
            Value<String?> ripetizioniTesto = const Value.absent(),
            Value<double?> peso = const Value.absent(),
            Value<double?> rpe = const Value.absent(),
            Value<int?> secondiTempo = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> dataOra = const Value.absent(),
          }) =>
              SerieRegistrateCompanion(
            id: id,
            sessioneId: sessioneId,
            esercizioId: esercizioId,
            indiceSerie: indiceSerie,
            ripetizioni: ripetizioni,
            ripetizioniTesto: ripetizioniTesto,
            peso: peso,
            rpe: rpe,
            secondiTempo: secondiTempo,
            note: note,
            dataOra: dataOra,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessioneId,
            required int esercizioId,
            required int indiceSerie,
            required int ripetizioni,
            Value<String?> ripetizioniTesto = const Value.absent(),
            Value<double?> peso = const Value.absent(),
            Value<double?> rpe = const Value.absent(),
            Value<int?> secondiTempo = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> dataOra = const Value.absent(),
          }) =>
              SerieRegistrateCompanion.insert(
            id: id,
            sessioneId: sessioneId,
            esercizioId: esercizioId,
            indiceSerie: indiceSerie,
            ripetizioni: ripetizioni,
            ripetizioniTesto: ripetizioniTesto,
            peso: peso,
            rpe: rpe,
            secondiTempo: secondiTempo,
            note: note,
            dataOra: dataOra,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SerieRegistrateTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessioneId = false, esercizioId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sessioneId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessioneId,
                    referencedTable:
                        $$SerieRegistrateTableReferences._sessioneIdTable(db),
                    referencedColumn: $$SerieRegistrateTableReferences
                        ._sessioneIdTable(db)
                        .id,
                  ) as T;
                }
                if (esercizioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.esercizioId,
                    referencedTable:
                        $$SerieRegistrateTableReferences._esercizioIdTable(db),
                    referencedColumn: $$SerieRegistrateTableReferences
                        ._esercizioIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SerieRegistrateTableProcessedTableManager = ProcessedTableManager<
    _$ArchivioLocale,
    $SerieRegistrateTable,
    SerieRegistrateData,
    $$SerieRegistrateTableFilterComposer,
    $$SerieRegistrateTableOrderingComposer,
    $$SerieRegistrateTableAnnotationComposer,
    $$SerieRegistrateTableCreateCompanionBuilder,
    $$SerieRegistrateTableUpdateCompanionBuilder,
    (SerieRegistrateData, $$SerieRegistrateTableReferences),
    SerieRegistrateData,
    PrefetchHooks Function({bool sessioneId, bool esercizioId})>;
typedef $$MisurazioniTableCreateCompanionBuilder = MisurazioniCompanion
    Function({
  Value<int> id,
  required int utenteId,
  required double peso,
  Value<double?> percentualeMassaGrassa,
  Value<double?> petto,
  Value<double?> vita,
  Value<double?> coscia,
  Value<String?> note,
  required DateTime data,
});
typedef $$MisurazioniTableUpdateCompanionBuilder = MisurazioniCompanion
    Function({
  Value<int> id,
  Value<int> utenteId,
  Value<double> peso,
  Value<double?> percentualeMassaGrassa,
  Value<double?> petto,
  Value<double?> vita,
  Value<double?> coscia,
  Value<String?> note,
  Value<DateTime> data,
});

final class $$MisurazioniTableReferences extends BaseReferences<
    _$ArchivioLocale, $MisurazioniTable, MisurazioniData> {
  $$MisurazioniTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UtentiTable _utenteIdTable(_$ArchivioLocale db) => db.utenti
      .createAlias($_aliasNameGenerator(db.misurazioni.utenteId, db.utenti.id));

  $$UtentiTableProcessedTableManager? get utenteId {
    if ($_item.utenteId == null) return null;
    final manager = $$UtentiTableTableManager($_db, $_db.utenti)
        .filter((f) => f.id($_item.utenteId!));
    final item = $_typedResult.readTableOrNull(_utenteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MisurazioniTableFilterComposer
    extends Composer<_$ArchivioLocale, $MisurazioniTable> {
  $$MisurazioniTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get peso => $composableBuilder(
      column: $table.peso, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get percentualeMassaGrassa => $composableBuilder(
      column: $table.percentualeMassaGrassa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get petto => $composableBuilder(
      column: $table.petto, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vita => $composableBuilder(
      column: $table.vita, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get coscia => $composableBuilder(
      column: $table.coscia, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));

  $$UtentiTableFilterComposer get utenteId {
    final $$UtentiTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.utenteId,
        referencedTable: $db.utenti,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UtentiTableFilterComposer(
              $db: $db,
              $table: $db.utenti,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MisurazioniTableOrderingComposer
    extends Composer<_$ArchivioLocale, $MisurazioniTable> {
  $$MisurazioniTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get peso => $composableBuilder(
      column: $table.peso, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get percentualeMassaGrassa => $composableBuilder(
      column: $table.percentualeMassaGrassa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get petto => $composableBuilder(
      column: $table.petto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vita => $composableBuilder(
      column: $table.vita, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get coscia => $composableBuilder(
      column: $table.coscia, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  $$UtentiTableOrderingComposer get utenteId {
    final $$UtentiTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.utenteId,
        referencedTable: $db.utenti,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UtentiTableOrderingComposer(
              $db: $db,
              $table: $db.utenti,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MisurazioniTableAnnotationComposer
    extends Composer<_$ArchivioLocale, $MisurazioniTable> {
  $$MisurazioniTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get peso =>
      $composableBuilder(column: $table.peso, builder: (column) => column);

  GeneratedColumn<double> get percentualeMassaGrassa => $composableBuilder(
      column: $table.percentualeMassaGrassa, builder: (column) => column);

  GeneratedColumn<double> get petto =>
      $composableBuilder(column: $table.petto, builder: (column) => column);

  GeneratedColumn<double> get vita =>
      $composableBuilder(column: $table.vita, builder: (column) => column);

  GeneratedColumn<double> get coscia =>
      $composableBuilder(column: $table.coscia, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  $$UtentiTableAnnotationComposer get utenteId {
    final $$UtentiTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.utenteId,
        referencedTable: $db.utenti,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UtentiTableAnnotationComposer(
              $db: $db,
              $table: $db.utenti,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MisurazioniTableTableManager extends RootTableManager<
    _$ArchivioLocale,
    $MisurazioniTable,
    MisurazioniData,
    $$MisurazioniTableFilterComposer,
    $$MisurazioniTableOrderingComposer,
    $$MisurazioniTableAnnotationComposer,
    $$MisurazioniTableCreateCompanionBuilder,
    $$MisurazioniTableUpdateCompanionBuilder,
    (MisurazioniData, $$MisurazioniTableReferences),
    MisurazioniData,
    PrefetchHooks Function({bool utenteId})> {
  $$MisurazioniTableTableManager(_$ArchivioLocale db, $MisurazioniTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MisurazioniTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MisurazioniTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MisurazioniTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> utenteId = const Value.absent(),
            Value<double> peso = const Value.absent(),
            Value<double?> percentualeMassaGrassa = const Value.absent(),
            Value<double?> petto = const Value.absent(),
            Value<double?> vita = const Value.absent(),
            Value<double?> coscia = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> data = const Value.absent(),
          }) =>
              MisurazioniCompanion(
            id: id,
            utenteId: utenteId,
            peso: peso,
            percentualeMassaGrassa: percentualeMassaGrassa,
            petto: petto,
            vita: vita,
            coscia: coscia,
            note: note,
            data: data,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int utenteId,
            required double peso,
            Value<double?> percentualeMassaGrassa = const Value.absent(),
            Value<double?> petto = const Value.absent(),
            Value<double?> vita = const Value.absent(),
            Value<double?> coscia = const Value.absent(),
            Value<String?> note = const Value.absent(),
            required DateTime data,
          }) =>
              MisurazioniCompanion.insert(
            id: id,
            utenteId: utenteId,
            peso: peso,
            percentualeMassaGrassa: percentualeMassaGrassa,
            petto: petto,
            vita: vita,
            coscia: coscia,
            note: note,
            data: data,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MisurazioniTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({utenteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (utenteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.utenteId,
                    referencedTable:
                        $$MisurazioniTableReferences._utenteIdTable(db),
                    referencedColumn:
                        $$MisurazioniTableReferences._utenteIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MisurazioniTableProcessedTableManager = ProcessedTableManager<
    _$ArchivioLocale,
    $MisurazioniTable,
    MisurazioniData,
    $$MisurazioniTableFilterComposer,
    $$MisurazioniTableOrderingComposer,
    $$MisurazioniTableAnnotationComposer,
    $$MisurazioniTableCreateCompanionBuilder,
    $$MisurazioniTableUpdateCompanionBuilder,
    (MisurazioniData, $$MisurazioniTableReferences),
    MisurazioniData,
    PrefetchHooks Function({bool utenteId})>;
typedef $$ImpostazioniTableCreateCompanionBuilder = ImpostazioniCompanion
    Function({
  required String chiave,
  required String valore,
  Value<int> rowid,
});
typedef $$ImpostazioniTableUpdateCompanionBuilder = ImpostazioniCompanion
    Function({
  Value<String> chiave,
  Value<String> valore,
  Value<int> rowid,
});

class $$ImpostazioniTableFilterComposer
    extends Composer<_$ArchivioLocale, $ImpostazioniTable> {
  $$ImpostazioniTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get chiave => $composableBuilder(
      column: $table.chiave, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get valore => $composableBuilder(
      column: $table.valore, builder: (column) => ColumnFilters(column));
}

class $$ImpostazioniTableOrderingComposer
    extends Composer<_$ArchivioLocale, $ImpostazioniTable> {
  $$ImpostazioniTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get chiave => $composableBuilder(
      column: $table.chiave, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get valore => $composableBuilder(
      column: $table.valore, builder: (column) => ColumnOrderings(column));
}

class $$ImpostazioniTableAnnotationComposer
    extends Composer<_$ArchivioLocale, $ImpostazioniTable> {
  $$ImpostazioniTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get chiave =>
      $composableBuilder(column: $table.chiave, builder: (column) => column);

  GeneratedColumn<String> get valore =>
      $composableBuilder(column: $table.valore, builder: (column) => column);
}

class $$ImpostazioniTableTableManager extends RootTableManager<
    _$ArchivioLocale,
    $ImpostazioniTable,
    ImpostazioniData,
    $$ImpostazioniTableFilterComposer,
    $$ImpostazioniTableOrderingComposer,
    $$ImpostazioniTableAnnotationComposer,
    $$ImpostazioniTableCreateCompanionBuilder,
    $$ImpostazioniTableUpdateCompanionBuilder,
    (
      ImpostazioniData,
      BaseReferences<_$ArchivioLocale, $ImpostazioniTable, ImpostazioniData>
    ),
    ImpostazioniData,
    PrefetchHooks Function()> {
  $$ImpostazioniTableTableManager(_$ArchivioLocale db, $ImpostazioniTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImpostazioniTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImpostazioniTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImpostazioniTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> chiave = const Value.absent(),
            Value<String> valore = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ImpostazioniCompanion(
            chiave: chiave,
            valore: valore,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String chiave,
            required String valore,
            Value<int> rowid = const Value.absent(),
          }) =>
              ImpostazioniCompanion.insert(
            chiave: chiave,
            valore: valore,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ImpostazioniTableProcessedTableManager = ProcessedTableManager<
    _$ArchivioLocale,
    $ImpostazioniTable,
    ImpostazioniData,
    $$ImpostazioniTableFilterComposer,
    $$ImpostazioniTableOrderingComposer,
    $$ImpostazioniTableAnnotationComposer,
    $$ImpostazioniTableCreateCompanionBuilder,
    $$ImpostazioniTableUpdateCompanionBuilder,
    (
      ImpostazioniData,
      BaseReferences<_$ArchivioLocale, $ImpostazioniTable, ImpostazioniData>
    ),
    ImpostazioniData,
    PrefetchHooks Function()>;
typedef $$CredenzialeSalvateTableCreateCompanionBuilder
    = CredenzialeSalvateCompanion Function({
  Value<int> id,
  required String username,
  required String password,
  Value<String?> nomeVisualizzato,
  Value<int?> aziendaId,
  Value<String?> codiceAzienda,
  Value<DateTime> ultimoUso,
});
typedef $$CredenzialeSalvateTableUpdateCompanionBuilder
    = CredenzialeSalvateCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String> password,
  Value<String?> nomeVisualizzato,
  Value<int?> aziendaId,
  Value<String?> codiceAzienda,
  Value<DateTime> ultimoUso,
});

class $$CredenzialeSalvateTableFilterComposer
    extends Composer<_$ArchivioLocale, $CredenzialeSalvateTable> {
  $$CredenzialeSalvateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomeVisualizzato => $composableBuilder(
      column: $table.nomeVisualizzato,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get aziendaId => $composableBuilder(
      column: $table.aziendaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codiceAzienda => $composableBuilder(
      column: $table.codiceAzienda, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get ultimoUso => $composableBuilder(
      column: $table.ultimoUso, builder: (column) => ColumnFilters(column));
}

class $$CredenzialeSalvateTableOrderingComposer
    extends Composer<_$ArchivioLocale, $CredenzialeSalvateTable> {
  $$CredenzialeSalvateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomeVisualizzato => $composableBuilder(
      column: $table.nomeVisualizzato,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get aziendaId => $composableBuilder(
      column: $table.aziendaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codiceAzienda => $composableBuilder(
      column: $table.codiceAzienda,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get ultimoUso => $composableBuilder(
      column: $table.ultimoUso, builder: (column) => ColumnOrderings(column));
}

class $$CredenzialeSalvateTableAnnotationComposer
    extends Composer<_$ArchivioLocale, $CredenzialeSalvateTable> {
  $$CredenzialeSalvateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get nomeVisualizzato => $composableBuilder(
      column: $table.nomeVisualizzato, builder: (column) => column);

  GeneratedColumn<int> get aziendaId =>
      $composableBuilder(column: $table.aziendaId, builder: (column) => column);

  GeneratedColumn<String> get codiceAzienda => $composableBuilder(
      column: $table.codiceAzienda, builder: (column) => column);

  GeneratedColumn<DateTime> get ultimoUso =>
      $composableBuilder(column: $table.ultimoUso, builder: (column) => column);
}

class $$CredenzialeSalvateTableTableManager extends RootTableManager<
    _$ArchivioLocale,
    $CredenzialeSalvateTable,
    CredenzialeSalvateData,
    $$CredenzialeSalvateTableFilterComposer,
    $$CredenzialeSalvateTableOrderingComposer,
    $$CredenzialeSalvateTableAnnotationComposer,
    $$CredenzialeSalvateTableCreateCompanionBuilder,
    $$CredenzialeSalvateTableUpdateCompanionBuilder,
    (
      CredenzialeSalvateData,
      BaseReferences<_$ArchivioLocale, $CredenzialeSalvateTable,
          CredenzialeSalvateData>
    ),
    CredenzialeSalvateData,
    PrefetchHooks Function()> {
  $$CredenzialeSalvateTableTableManager(
      _$ArchivioLocale db, $CredenzialeSalvateTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CredenzialeSalvateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CredenzialeSalvateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CredenzialeSalvateTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String?> nomeVisualizzato = const Value.absent(),
            Value<int?> aziendaId = const Value.absent(),
            Value<String?> codiceAzienda = const Value.absent(),
            Value<DateTime> ultimoUso = const Value.absent(),
          }) =>
              CredenzialeSalvateCompanion(
            id: id,
            username: username,
            password: password,
            nomeVisualizzato: nomeVisualizzato,
            aziendaId: aziendaId,
            codiceAzienda: codiceAzienda,
            ultimoUso: ultimoUso,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            required String password,
            Value<String?> nomeVisualizzato = const Value.absent(),
            Value<int?> aziendaId = const Value.absent(),
            Value<String?> codiceAzienda = const Value.absent(),
            Value<DateTime> ultimoUso = const Value.absent(),
          }) =>
              CredenzialeSalvateCompanion.insert(
            id: id,
            username: username,
            password: password,
            nomeVisualizzato: nomeVisualizzato,
            aziendaId: aziendaId,
            codiceAzienda: codiceAzienda,
            ultimoUso: ultimoUso,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CredenzialeSalvateTableProcessedTableManager = ProcessedTableManager<
    _$ArchivioLocale,
    $CredenzialeSalvateTable,
    CredenzialeSalvateData,
    $$CredenzialeSalvateTableFilterComposer,
    $$CredenzialeSalvateTableOrderingComposer,
    $$CredenzialeSalvateTableAnnotationComposer,
    $$CredenzialeSalvateTableCreateCompanionBuilder,
    $$CredenzialeSalvateTableUpdateCompanionBuilder,
    (
      CredenzialeSalvateData,
      BaseReferences<_$ArchivioLocale, $CredenzialeSalvateTable,
          CredenzialeSalvateData>
    ),
    CredenzialeSalvateData,
    PrefetchHooks Function()>;

class $ArchivioLocaleManager {
  final _$ArchivioLocale _db;
  $ArchivioLocaleManager(this._db);
  $$UtentiTableTableManager get utenti =>
      $$UtentiTableTableManager(_db, _db.utenti);
  $$EserciziTableTableManager get esercizi =>
      $$EserciziTableTableManager(_db, _db.esercizi);
  $$SchedeTableTableManager get schede =>
      $$SchedeTableTableManager(_db, _db.schede);
  $$SchedeEserciziTableTableManager get schedeEsercizi =>
      $$SchedeEserciziTableTableManager(_db, _db.schedeEsercizi);
  $$SessioniAllenamentoTableTableManager get sessioniAllenamento =>
      $$SessioniAllenamentoTableTableManager(_db, _db.sessioniAllenamento);
  $$SerieRegistrateTableTableManager get serieRegistrate =>
      $$SerieRegistrateTableTableManager(_db, _db.serieRegistrate);
  $$MisurazioniTableTableManager get misurazioni =>
      $$MisurazioniTableTableManager(_db, _db.misurazioni);
  $$ImpostazioniTableTableManager get impostazioni =>
      $$ImpostazioniTableTableManager(_db, _db.impostazioni);
  $$CredenzialeSalvateTableTableManager get credenzialeSalvate =>
      $$CredenzialeSalvateTableTableManager(_db, _db.credenzialeSalvate);
}
