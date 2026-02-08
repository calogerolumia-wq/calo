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
      theme: temaChiaro(),
      darkTheme: temaScuro(),
      themeMode: ThemeMode.system,
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
      data: (auth) => auth.autenticato
          ? const PaginaDashboard()
          : const PaginaLogin(),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
