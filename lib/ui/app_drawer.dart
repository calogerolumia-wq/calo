import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/pages/Impostazioni.dart';
import '../pages/notifiche/pagina_notifiche.dart';
import '../pages/profilo/pagina_profilo.dart';
import '../stato/fornitori.dart';
import '../utils/auth_api.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  Future<void> _gestisciLogout(BuildContext context, WidgetRef ref) async {
    final conferma = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Vuoi uscire dall\'app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Esci'),
            ),
          ],
        );
      },
    );

    if (conferma != true) return;

    Navigator.of(context).pop(); // chiude il drawer

    try {
      await ref.read(gestoreAutenticazione.notifier).logout();
      // _AuthGate reagisce allo stato nonAutenticato e naviga automaticamente
    } on AuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout non riuscito. Riprova.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utente = ref.watch(fornitoreUtenteCorrente);
    final nome = utente?.nome ?? 'Utente';
    final email = (utente?.email ?? '').trim();
    final username = utente?.username;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(nome),
              accountEmail: Text(
                username != null && username.isNotEmpty
                    ? '@$username'
                    : email.isEmpty ? ' ' : email,
              ),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Profilo utente'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PaginaProfilo(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined),
                    title: const Text('Notifiche'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PaginaNotifiche(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Impostazioni'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const Impostazioni(),
                          ),);
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _gestisciLogout(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}
