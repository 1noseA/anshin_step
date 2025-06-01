import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anshin_step/models/report.dart';
import 'package:anshin_step/services/report_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:anshin_step/components/colors.dart';

// レポートサービスのProvider
final reportServiceProvider = Provider((ref) => ReportService());

// レポートのProvider
final reportProvider = FutureProvider<Report?>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;
  return ref.read(reportServiceProvider).getReport(user.uid);
});

class MindReport extends ConsumerWidget {
  const MindReport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(reportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('あんしんのくすり'),
      ),
      body: reportAsync.when(
        data: (report) {
          if (report == null) {
            return const Center(
              child: Text('レポートがありません'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnxietyScoreChart(report),
                const SizedBox(height: 24),
                _buildAnxietyTendency(report),
                const SizedBox(height: 24),
                _buildEffectiveCopingMethods(report),
                const SizedBox(height: 24),
                _buildComfortingWords(report),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('エラーが発生しました: $error'),
        ),
      ),
    );
  }

  Widget _buildAnxietyScoreChart(Report report) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '不安得点の推移',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: report.anxietyScoreHistory
                          .asMap()
                          .entries
                          .map((entry) {
                        final data = entry.value as Map<String, dynamic>;
                        return FlSpot(
                          entry.key.toDouble(),
                          data['beforeScore']?.toDouble() ?? 0,
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                    LineChartBarData(
                      spots: report.anxietyScoreHistory
                          .asMap()
                          .entries
                          .map((entry) {
                        final data = entry.value as Map<String, dynamic>;
                        return FlSpot(
                          entry.key.toDouble(),
                          data['afterScore']?.toDouble() ?? 0,
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnxietyTendency(Report report) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'あなたの不安傾向',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTendencyItem('天気', report.anxietyTendency['weather']),
            _buildTendencyItem('気温', report.anxietyTendency['temperature']),
            _buildTendencyItem('気圧', report.anxietyTendency['pressure']),
            _buildTendencyItem('月齢', report.anxietyTendency['lunarAge']),
          ],
        ),
      ),
    );
  }

  Widget _buildTendencyItem(String title, Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...data.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key),
                  Text(
                    '平均不安度: ${entry.value['averageAnxiety']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEffectiveCopingMethods(Report report) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '効果的な対処法',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...report.effectiveCopingMethods.map((method) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text(method)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildComfortingWords(Report report) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '安心につながる言葉',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...report.comfortingWords.map((word) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.favorite_border, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(word)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
