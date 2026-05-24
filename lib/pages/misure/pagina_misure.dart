import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/archivio_locale.dart';
import '../../ui/app_ui.dart';
import '../../utils/navigazione.dart';
import '../../stato/fornitori.dart';
import 'pagina_editor_misura.dart';

class PaginaMisure extends ConsumerWidget {
  const PaginaMisure({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cfg = ref.watch(fornitoreConfigurazioneApp);
    if (!cfg.featureMisurazioni) return const FeatureDisabilitata(titolo: 'Misurazioni');

    final archivio = ref.watch(fornitoreArchivioLocale);
    final idUtente = ref.watch(fornitoreIdUtenteCorrente);
    if (idUtente == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Misure'),
        leading: const BackButton(),
        actions: [
          IconButton(
            onPressed: () => apriPagina(
              context,
              const PaginaEditorMisura(),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<MisurazioniData>>(
        stream: archivio.guardaMisure(idUtente),
        builder: (context, snapshot) {
          final misure = snapshot.data ?? [];
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [
              if (misure.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Peso nel tempo',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 220,
                          child: _GraficoPeso(misure: misure),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 12),
              if (misure.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Icon(Icons.insights_outlined, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          'Nessuna misura inserita',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aggiungi la prima misurazione per vedere i progressi',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...misure.map(
                  (misura) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text('${misura.peso.toStringAsFixed(1)} kg'),
                      subtitle: Text(_formattaData(misura.data)),
                      trailing: misura.percentualeMassaGrassa == null
                          ? null
                          : Text(
                              '${misura.percentualeMassaGrassa!.toStringAsFixed(1)}%',
                            ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => apriPagina(
          context,
          const PaginaEditorMisura(),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nuova misura'),
      ),
    );
  }

  String _formattaData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}

class _GraficoPeso extends StatelessWidget {
  const _GraficoPeso({required this.misure});

  final List<MisurazioniData> misure;

  @override
  Widget build(BuildContext context) {
    final dati = misure.reversed.toList();
    final spots = <FlSpot>[];
    for (var i = 0; i < dati.length; i++) {
      spots.add(FlSpot(i.toDouble(), dati[i].peso));
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: dati.length <= 4 ? 1 : (dati.length / 4).ceilToDouble(),
              getTitlesWidget: (value, meta) {
                final indice = value.toInt();
                if (indice < 0 || indice >= dati.length) {
                  return const SizedBox.shrink();
                }
                final data = dati[indice].data;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('${data.day}/${data.month}'),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
