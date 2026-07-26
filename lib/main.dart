import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'database/archivio_locale.dart';
import 'stato/fornitori.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configuraEasyLoading();
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

void _configuraEasyLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = const Color(0xFF1E40AF)
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.black.withOpacity(0.30)
    ..userInteractions = false
    ..dismissOnTap = false
    ..radius = 16
    ..fontSize = 14;
}
