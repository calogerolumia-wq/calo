import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/Dashboard.dart';
import 'pages/login/pagina_login.dart';
import 'stato/fornitori.dart';
import 'utils/tema.dart';

class AppAllenamento extends StatelessWidget {
  const AppAllenamento({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness 2026',
      debugShowCheckedModeBanner: false,
      theme: tema(),
      themeMode: ThemeMode.light,
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stato = ref.watch(gestoreAutenticazione);
    return stato.when(
      loading: () => const _SplashScreen(),
      error: (err, stack) => const PaginaLogin(),
      data: (auth) => (auth.autenticato || auth.modalitaOffline)
          ? const PaginaDashboard()
          : const PaginaLogin(),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: c.background,
      body: Center(
        child: CircularProgressIndicator(color: c.primary, strokeWidth: 2.5),
      ),
    );
  }
}
