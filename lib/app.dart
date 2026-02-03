import 'package:flutter/material.dart';

import 'pages/Dashboard.dart';
import 'utils/tema.dart';

class AppAllenamento extends StatelessWidget {
  const AppAllenamento({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness 2026',
      debugShowCheckedModeBanner: false,
      theme: temaChiaro(),
      darkTheme: temaScuro(),
      themeMode: ThemeMode.system,
      home: const PaginaDashboard(),
    );

  }
}
