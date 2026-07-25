import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/misurazione_remota.dart';
import '../../ui/app_ui.dart';
import '../../utils/navigazione.dart';
import '../../stato/fornitori.dart';
import 'pagina_editor_misura.dart';

class PaginaMisure extends ConsumerWidget {
  const PaginaMisure({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cfg = ref.watch(fornitoreConfigurazioneApp);
    if (!cfg.featureMisurazioni) {
      return const FeatureDisabilitata(titolo: 'Misurazioni');
    }

    final misureAsync = ref.watch(fornitureMisurazioniRemote);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Misure'),
        leading: const BackButton(),
        actions: [
          if (misureAsync.isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              onPressed: () => apriPagina(context, const PaginaEditorMisura()),
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: misureAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 48),
              const SizedBox(height: 12),
              Text(
                'Impossibile caricare le misure',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () =>
                    ref.invalidate(fornitureMisurazioniRemote),
                icon: const Icon(Icons.refresh),
                label: const Text('Riprova'),
              ),
            ],
          ),
        ),
        data: (misure) => _ListaMisure(misure: misure),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => apriPagina(context, const PaginaEditorMisura()),
        icon: const Icon(Icons.add),
        label: const Text('Nuova misura'),
      ),
    );
  }
}

class _ListaMisure extends ConsumerWidget {
  const _ListaMisure({required this.misure});

  final List<MisurazioneRemota> misure;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            (misura) => _CardMisura(misura: misura).animate().fadeIn(duration: 200.ms),
          ),
      ],
    );
  }
}

class _CardMisura extends ConsumerWidget {
  const _CardMisura({required this.misura});

  final MisurazioneRemota misura;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final c = tema.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(
          '${misura.peso.toStringAsFixed(1)} kg',
          style: tema.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_formattaData(misura.date)),
            if (misura.bodyFatPercent != null)
              Text(
                'Massa grassa: ${misura.bodyFatPercent!.toStringAsFixed(1)}%',
                style: tema.textTheme.bodySmall,
              ),
            if (misura.petto != null || misura.vita != null || misura.coscia != null)
              Text(
                [
                  if (misura.petto != null) 'Petto: ${misura.petto!.toStringAsFixed(1)}',
                  if (misura.vita != null) 'Vita: ${misura.vita!.toStringAsFixed(1)}',
                  if (misura.coscia != null) 'Coscia: ${misura.coscia!.toStringAsFixed(1)}',
                ].join(' · '),
                style: tema.textTheme.bodySmall,
              ),
            if (misura.note != null && misura.note!.isNotEmpty)
              Text(
                misura.note!,
                style: tema.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: c.error),
          onPressed: () => _confermaElimina(context, ref),
        ),
      ),
    );
  }

  Future<void> _confermaElimina(BuildContext context, WidgetRef ref) async {
    final conferma = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Elimina misurazione'),
        content: Text(
          'Eliminare la misurazione del ${_formattaData(misura.date)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (conferma != true) return;
    await ref.read(fornitureMisurazioniRemote.notifier).elimina(misura);
  }

  String _formattaData(DateTime data) =>
      '${data.day.toString().padLeft(2, '0')}/'
      '${data.month.toString().padLeft(2, '0')}/'
      '${data.year}';
}

class _GraficoPeso extends StatelessWidget {
  const _GraficoPeso({required this.misure});

  final List<MisurazioneRemota> misure;

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
          leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: dati.length <= 4
                  ? 1
                  : (dati.length / 4).ceilToDouble(),
              getTitlesWidget: (value, meta) {
                final indice = value.toInt();
                if (indice < 0 || indice >= dati.length) {
                  return const SizedBox.shrink();
                }
                final data = dati[indice].date;
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
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
