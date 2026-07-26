import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../database/archivio_locale.dart';
import '../../stato/fornitori.dart';
import '../../ui/app_ui.dart';
import '../../utils/auth_api.dart';

class PaginaLogin extends ConsumerStatefulWidget {
  const PaginaLogin({super.key});

  @override
  ConsumerState<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends ConsumerState<PaginaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codiceAziendaController = TextEditingController();

  bool _obscure = true;
  String? _errore;

  List<CredenzialeSalvateData> _credenziali = [];
  CredenzialeSalvateData? _selezionata;

  @override
  void initState() {
    super.initState();
    _caricaCredenziali();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _codiceAziendaController.dispose();
    super.dispose();
  }

  Future<void> _caricaCredenziali() async {
    final archivio = ref.read(fornitoreArchivioLocale);
    final list = await archivio.leggiCredenziali();
    if (!mounted) return;
    setState(() {
      _credenziali = list;
      // Se c'era una selezione, aggiorna il riferimento
      if (_selezionata != null) {
        _selezionata = list.where((c) => c.id == _selezionata!.id).firstOrNull;
      }
    });
  }

  void _applicaCredenziale(CredenzialeSalvateData cred) {
    setState(() {
      _selezionata = cred;
      _errore = null;
    });
    _usernameController.text = cred.username;
    _passwordController.text = cred.password;
    if (cred.codiceAzienda != null && cred.codiceAzienda!.isNotEmpty) {
      _codiceAziendaController.text = cred.codiceAzienda!;
    }
  }

  Future<void> _eliminaCredenziale(CredenzialeSalvateData cred) async {
    final archivio = ref.read(fornitoreArchivioLocale);
    await archivio.eliminaCredenziale(cred.id);
    if (_selezionata?.id == cred.id) {
      setState(() => _selezionata = null);
      _usernameController.clear();
      _passwordController.clear();
      _codiceAziendaController.clear();
    }
    await _caricaCredenziali();
  }

  Future<void> _eseguiLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _errore = null);

    EasyLoading.show(status: 'Accesso in corso...');
    try {
      await ref.read(gestoreAutenticazione.notifier).login(
            username: _usernameController.text.trim(),
            password: _passwordController.text,
            codiceAzienda: _codiceAziendaController.text.trim(),
          );
      EasyLoading.dismiss();
    } on AuthException catch (e) {
      EasyLoading.dismiss();
      setState(() => _errore = e.message);
    } catch (_) {
      EasyLoading.dismiss();
      setState(() => _errore = 'Errore di connessione. Riprova.');
    }
  }

  void _apriGestioneAccount(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _GestioneAccountSheet(
        credenziali: _credenziali,
        onElimina: _eliminaCredenziale,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand mark
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: c.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: c.primary.withOpacity(0.30),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child:
                    Icon(Icons.fitness_center_rounded, color: c.onPrimary, size: 24),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Accedi',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Usa le tue credenziali per continuare.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: c.onSurface.withOpacity(0.60),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ─── Account salvati ─────────────────────────────────────────
              if (_credenziali.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Account salvati',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: c.onSurface.withOpacity(0.75),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _apriGestioneAccount(context),
                      icon: const Icon(Icons.manage_accounts_outlined, size: 16),
                      label: const Text('Gestisci'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        textStyle: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < _credenziali.length; i++) ...[
                        _AccountTile(
                          cred: _credenziali[i],
                          selezionata: _selezionata?.id == _credenziali[i].id,
                          onTap: () => _applicaCredenziale(_credenziali[i]),
                        ),
                        if (i < _credenziali.length - 1)
                          Divider(
                            height: 1,
                            indent: AppSpacing.lg + 44,
                            color: c.outline.withOpacity(0.5),
                          ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(child: Divider(color: c.outline.withOpacity(0.5))),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      child: Text(
                        'oppure inserisci le credenziali',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: c.onSurface.withOpacity(0.40),
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: c.outline.withOpacity(0.5))),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // ─── Form ────────────────────────────────────────────────────
              AppCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username o email',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: (_) {
                          if (_selezionata != null) {
                            setState(() => _selezionata = null);
                          }
                        },
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Inserisci username o email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _eseguiLogin(),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Inserisci la password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (_errore != null) ...[
                        AppInlineBanner(
                          message: _errore!,
                          icon: Icons.error_outline,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      AppGradientButton(
                        label: 'Accedi',
                        icon: Icons.login,
                        expand: true,
                        onPressed: _eseguiLogin,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Account tile ─────────────────────────────────────────────────────────────

class _AccountTile extends StatelessWidget {
  const _AccountTile({
    required this.cred,
    required this.selezionata,
    required this.onTap,
  });

  final CredenzialeSalvateData cred;
  final bool selezionata;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final displayName = cred.nomeVisualizzato?.isNotEmpty == true
        ? cred.nomeVisualizzato!
        : cred.username;
    final initiale = displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : '?';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: 12),
        decoration: selezionata
            ? BoxDecoration(
                color: c.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(24),
              )
            : null,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selezionata
                    ? c.primary.withOpacity(0.12)
                    : c.surfaceVariant,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initiale,
                style: GoogleFonts.syne(
                  color: selezionata ? c.primary : c.onSurface.withOpacity(0.65),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: selezionata ? c.primary : null,
                    ),
                  ),
                  if (cred.nomeVisualizzato?.isNotEmpty == true)
                    Text(
                      cred.username,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: c.onSurface.withOpacity(0.45),
                      ),
                    ),
                ],
              ),
            ),
            if (selezionata)
              Icon(Icons.check_circle_rounded,
                  size: 18, color: c.primary),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom sheet gestione account ───────────────────────────────────────────

class _GestioneAccountSheet extends StatelessWidget {
  const _GestioneAccountSheet({
    required this.credenziali,
    required this.onElimina,
  });

  final List<CredenzialeSalvateData> credenziali;
  final Future<void> Function(CredenzialeSalvateData) onElimina;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (_, scrollController) {
        return Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: c.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              child: Row(
                children: [
                  Text(
                    'Account salvati',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      foregroundColor: c.onSurface.withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: c.outline.withOpacity(0.5)),
            Expanded(
              child: credenziali.isEmpty
                  ? Center(
                      child: Text(
                        'Nessun account salvato',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: c.onSurface.withOpacity(0.45),
                        ),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      itemCount: credenziali.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: c.outline.withOpacity(0.3)),
                      itemBuilder: (ctx, i) {
                        final cred = credenziali[i];
                        final displayName =
                            cred.nomeVisualizzato?.isNotEmpty == true
                                ? cred.nomeVisualizzato!
                                : cred.username;
                        final initiale = displayName.isNotEmpty
                            ? displayName[0].toUpperCase()
                            : '?';
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: c.primary.withOpacity(0.10),
                            child: Text(
                              initiale,
                              style: GoogleFonts.syne(
                                color: c.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          title: Text(displayName),
                          subtitle: cred.nomeVisualizzato?.isNotEmpty == true
                              ? Text(cred.username)
                              : null,
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline,
                                color: c.error, size: 20),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await onElimina(cred);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
