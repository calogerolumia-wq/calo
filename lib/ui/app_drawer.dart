import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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

    Navigator.of(context).pop();

    try {
      await ref.read(gestoreAutenticazione.notifier).logout();
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
    final sub = (username != null && username.isNotEmpty)
        ? '@$username'
        : email.isEmpty
            ? ''
            : email;
    final initiali = nome
        .trim()
        .split(RegExp(r'\s+'))
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      child: Column(
        children: [
          _DrawerHeader(nome: nome, sub: sub, initiali: initiali),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _DrawerTile(
                  icon: Icons.person_2_outlined,
                  label: 'Profilo',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PaginaProfilo()),
                    );
                  },
                ),
                _DrawerTile(
                  icon: Icons.notifications_outlined,
                  label: 'Notifiche',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const PaginaNotifiche()),
                    );
                  },
                ),
                _DrawerTile(
                  icon: Icons.settings_outlined,
                  label: 'Impostazioni',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const Impostazioni()),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 32),
            child: _DrawerTile(
              icon: Icons.logout_rounded,
              label: 'Esci',
              destructive: true,
              onTap: () => _gestisciLogout(context, ref),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    required this.nome,
    required this.sub,
    required this.initiali,
  });

  final String nome;
  final String sub;
  final String initiali;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Branding
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.fitness_center_rounded,
                        color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'GymPulse',
                    style: GoogleFonts.syne(
                      color: Colors.white.withOpacity(0.90),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Avatar with initials
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.30),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  initiali.isEmpty ? '?' : initiali,
                  style: GoogleFonts.syne(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                nome,
                style: GoogleFonts.syne(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: -0.3,
                ),
              ),
              if (sub.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  sub,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.60),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final color = destructive ? c.error : c.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                color: color.withOpacity(destructive ? 0.85 : 0.68),
                size: 20,
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: color.withOpacity(destructive ? 0.90 : 0.85),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
