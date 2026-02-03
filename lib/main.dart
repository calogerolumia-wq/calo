import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'database/archivio_locale.dart';
import 'stato/fornitori.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final archivio = ArchivioLocale();
  await archivio.inizializzaDatiDemo();
  runApp(
    ProviderScope(
      overrides: [
        fornitoreArchivioLocale.overrideWithValue(archivio),
      ],
      child: const AppAllenamento(),
    ),
  );
}
