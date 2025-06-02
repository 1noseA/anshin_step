import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anshin_step/models/report.dart';
import 'package:anshin_step/services/report_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:anshin_step/components/colors.dart';
import 'package:flutter/services.dart';

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
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: const BackButton(),
        title: const Text('あんしんのくすり'),
        surfaceTintColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            color: const Color(0xFFE0E3E8),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFF6F7FB),
              child: reportAsync.when(
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
                        _buildStyledCard(_buildAnxietyScoreChart(report)),
                        const SizedBox(height: 24),
                        _buildStyledCard(_buildAnxietyTendency(report)),
                        const SizedBox(height: 24),
                        _buildStyledCard(_buildEffectiveCopingMethods(report)),
                        const SizedBox(height: 24),
                        _buildStyledCard(_buildComfortingWords(report)),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Text('エラーが発生しました: $error'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledCard(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildAnxietyScoreChart(Report report) {
    // 平均値計算
    final beforeScores = report.anxietyScoreHistory
        .map((e) => (e['beforeScore'] ?? 0) as num)
        .toList();
    final afterScores = report.anxietyScoreHistory
        .map((e) => (e['afterScore'] ?? 0) as num)
        .toList();
    final beforeAvg = beforeScores.isNotEmpty
        ? (beforeScores.reduce((a, b) => a + b) / beforeScores.length)
        : 0;
    final afterAvg = afterScores.isNotEmpty
        ? (afterScores.reduce((a, b) => a + b) / afterScores.length)
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '不安得点の推移',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B2B2B),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  beforeAvg.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '平均事前不安得点',
                  style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  afterAvg.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '平均事後不安得点',
                  style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value % 10 != 0) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.left,
                        ),
                      );
                    },
                    interval: 10,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 ||
                          index >= report.anxietyScoreHistory.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('${index + 1}',
                            style: const TextStyle(fontSize: 12)),
                      );
                    },
                    interval: 1,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(color: Colors.black, width: 1),
                  top: BorderSide(color: Color(0xFFE0E3E8), width: 1),
                  right: BorderSide(color: Color(0xFFE0E3E8), width: 1),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots:
                      report.anxietyScoreHistory.asMap().entries.map((entry) {
                    final data = entry.value as Map<String, dynamic>;
                    return FlSpot(
                      entry.key.toDouble(),
                      data['beforeScore']?.toDouble() ?? 0,
                    );
                  }).toList(),
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
                LineChartBarData(
                  spots:
                      report.anxietyScoreHistory.asMap().entries.map((entry) {
                    final data = entry.value as Map<String, dynamic>;
                    return FlSpot(
                      entry.key.toDouble(),
                      data['afterScore']?.toDouble() ?? 0,
                    );
                  }).toList(),
                  isCurved: true,
                  color: Color(0xFF4CAF50),
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnxietyTendency(Report report) {
    // データの有無をチェック
    final hasAnalysis = report.anxietyTendency['analysis'] != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '不安傾向',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B2B2B),
          ),
        ),
        const SizedBox(height: 16),
        if (!hasAnalysis)
          const Text(
            '情報が不足しています。ベビーステップを記録すると、より詳細な分析が表示されます。',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF2B2B2B),
            ),
          )
        else if (report.anxietyTendency['analysis']?['summary'] != null)
          Text(
            report.anxietyTendency['analysis']['summary'],
            style: const TextStyle(fontSize: 16, color: Color(0xFF2B2B2B)),
          ),
      ],
    );
  }

  Widget _buildEffectiveCopingMethods(Report report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '効果的な対処法',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B2B2B),
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
                Expanded(
                  child: Text(
                    method,
                    style: const TextStyle(color: Color(0xFF2B2B2B)),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildComfortingWords(Report report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '安心につながる言葉',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B2B2B),
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
                Expanded(
                  child: Text(
                    word,
                    style: const TextStyle(color: Color(0xFF2B2B2B)),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
