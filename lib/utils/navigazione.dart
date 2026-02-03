import 'package:flutter/material.dart';

void apriPagina(BuildContext context, Widget pagina) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => pagina),
  );
}

void vaiAllaPaginaPrincipale(BuildContext context, Widget pagina) {
  final navigatore = Navigator.of(context);
  navigatore.popUntil((route) => route.isFirst);
  navigatore.push(
    MaterialPageRoute(builder: (_) => pagina),
  );
}
