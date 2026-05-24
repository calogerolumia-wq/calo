import '../utils/auth_api.dart';

class ConfigurazioneApp {
  const ConfigurazioneApp({
    this.featureEsercizi = true,
    this.featureSchede = true,
    this.featureModelliSchede = true,
    this.featureTimer = true,
    this.featureMisurazioni = true,
  });

  final bool featureEsercizi;
  final bool featureSchede;
  final bool featureModelliSchede;
  final bool featureTimer;
  final bool featureMisurazioni;

  factory ConfigurazioneApp.tutto() => const ConfigurazioneApp();

  factory ConfigurazioneApp.fromLogin(LoginResponse r) => ConfigurazioneApp(
        featureEsercizi: r.featureEsercizi,
        featureSchede: r.featureSchede,
        featureModelliSchede: r.featureModelliSchede,
        featureTimer: r.featureTimer,
        featureMisurazioni: r.featureMisurazioni,
      );
}
