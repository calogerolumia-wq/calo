# Fitness App

App Flutter con persistenza locale (SQLite/Drift) per schede di allenamento, sessioni, set e misurazioni.

## Avvio rapido
```bash
flutter pub get
flutter run
```

## Rigenerare il codice Drift
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Struttura essenziale
- `lib/app.dart` avvio MaterialApp
- `lib/router.dart` routing con `go_router`
- `lib/tema.dart` temi Material 3
- `lib/database/` schema Drift + seed demo
- `lib/stato/` provider Riverpod
- `lib/pages/` UI e flussi principali
- `lib/immagini_esercizi.dart` mappa asset immagini esercizi

Note:
- Tema monocolore: la UI usa `colorScheme.primary` con varianti via opacity.
- Navigazione back: freccia indietro presente sulle pagine non root.
