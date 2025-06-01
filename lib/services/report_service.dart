import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anshin_step/models/report.dart';
import 'package:anshin_step/models/baby_step.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  // レポートを生成・更新する
  Future<void> generateReport(String userId) async {
    try {
      // ユーザーのベビーステップを取得
      final babyStepsSnapshot = await _firestore
          .collection('baby_steps')
          .where('createdBy', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      if (babyStepsSnapshot.docs.isEmpty) {
        return;
      }

      // ベビーステップのデータを変換
      final babyStepsData = babyStepsSnapshot.docs
          .map((stepDoc) {
            final stepData = stepDoc.data();
            stepData['id'] = stepDoc.id;
            // 必須フィールドが揃っていない場合はnullを返す
            if (stepData['id'] == null ||
                stepData['action'] == null ||
                stepData['createdAt'] == null ||
                stepData['updatedAt'] == null) {
              return null;
            }
            return BabyStep.fromJson(stepData);
          })
          .where((step) => step != null)
          .cast<BabyStep>()
          .toList();

      // 不安得点の推移を生成
      final anxietyScoreHistory = _generateAnxietyScoreHistory(babyStepsData);

      // 不安傾向を分析（AIを使用）
      final anxietyTendency = await _analyzeAnxietyTendency(babyStepsData);

      // 効果的な対処法を生成（AIを使用）
      final effectiveCopingMethods =
          await _generateEffectiveCopingMethods(babyStepsData);

      // 安心につながる言葉を生成（AIを使用）
      final comfortingWords = await _generateComfortingWords(babyStepsData);

      // レポートを作成または更新
      final report = Report(
        id: 'report_$userId',
        userId: userId,
        anxietyScoreHistory: anxietyScoreHistory,
        anxietyTendency: anxietyTendency,
        effectiveCopingMethods: effectiveCopingMethods,
        comfortingWords: comfortingWords,
        createdBy: userId,
        createdAt: DateTime.now(),
        updatedBy: userId,
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('reports')
          .doc('report_$userId')
          .set(report.toJson());
    } catch (e) {
      print('Error generating report: $e');
      rethrow;
    }
  }

  // 不安得点の推移を生成
  List<Map<String, dynamic>> _generateAnxietyScoreHistory(
      List<BabyStep> babySteps) {
    return babySteps.map((step) {
      return {
        'date': step.executionDate?.toIso8601String(),
        'beforeScore': step.beforeAnxietyScore,
        'afterScore': step.afterAnxietyScore,
        'achievementScore': step.achievementScore,
      };
    }).toList();
  }

  // レポートを取得
  Future<Report?> getReport(String userId) async {
    try {
      final doc =
          await _firestore.collection('reports').doc('report_$userId').get();
      if (!doc.exists) {
        return null;
      }
      return Report.fromJson(doc.data()!);
    } catch (e) {
      print('Error getting report: $e');
      rethrow;
    }
  }

  // --- AI統合部分 ---
  Future<Map<String, dynamic>> _analyzeAnxietyTendency(
      List<BabyStep> babySteps) async {
    final prompt = _createAnxietyTendencyPrompt(babySteps);
    final response = await _callAI(prompt);
    return _parseAnxietyTendencyResponse(response);
  }

  Future<List<String>> _generateEffectiveCopingMethods(
      List<BabyStep> babySteps) async {
    final prompt = _createCopingMethodsPrompt(babySteps);
    final response = await _callAI(prompt);
    return _parseCopingMethodsResponse(response);
  }

  Future<List<String>> _generateComfortingWords(
      List<BabyStep> babySteps) async {
    final prompt = _createComfortingWordsPrompt(babySteps);
    final response = await _callAI(prompt);
    return _parseComfortingWordsResponse(response);
  }

  Future<String> _callAI(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'あなたは不安症の専門家です。ユーザーのデータを分析し、適切なアドバイスを提供してください。\n\n$prompt'
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('API呼び出しに失敗しました: {response.statusCode}');
      }
    } catch (e) {
      print('AI呼び出しエラー: $e');
      rethrow;
    }
  }

  String _createAnxietyTendencyPrompt(List<BabyStep> babySteps) {
    final stepsData = babySteps
        .map((step) => {
              'date': step.executionDate?.toIso8601String(),
              'beforeScore': step.beforeAnxietyScore,
              'afterScore': step.afterAnxietyScore,
              'weather': step.weather,
              'temperature': step.temperature,
              'pressure': step.pressure,
              'lunarAge': step.lunarAge,
            })
        .toList();

    return '''
以下のベビーステップのデータを分析し、不安傾向を特定してください。
データはJSON形式で提供されます。

データ:
${jsonEncode(stepsData)}

以下の形式で分析結果を返してください：
{
  "weather": {
    "sunny": {"count": 数値, "averageAnxiety": 数値},
    "rainy": {"count": 数値, "averageAnxiety": 数値},
    "cloudy": {"count": 数値, "averageAnxiety": 数値}
  },
  "temperature": {
    "high": {"count": 数値, "averageAnxiety": 数値},
    "medium": {"count": 数値, "averageAnxiety": 数値},
    "low": {"count": 数値, "averageAnxiety": 数値}
  },
  "pressure": {
    "high": {"count": 数値, "averageAnxiety": 数値},
    "low": {"count": 数値, "averageAnxiety": 数値}
  },
  "lunarAge": {
    "new": {"count": 数値, "averageAnxiety": 数値},
    "waxing": {"count": 数値, "averageAnxiety": 数値},
    "full": {"count": 数値, "averageAnxiety": 数値},
    "waning": {"count": 数値, "averageAnxiety": 数値}
  }
}

必ずJSON形式で返してください。
''';
  }

  String _createCopingMethodsPrompt(List<BabyStep> babySteps) {
    final stepsData = babySteps
        .map((step) => {
              'date': step.executionDate?.toIso8601String(),
              'beforeScore': step.beforeAnxietyScore,
              'afterScore': step.afterAnxietyScore,
              'copingMethod': step.copingMethod,
            })
        .toList();

    return '''
以下のベビーステップのデータを分析し、効果的な対処法を5つ提案してください。
データはJSON形式で提供されます。

データ:
${jsonEncode(stepsData)}

以下の形式で対処法のリストを返してください：
[
  "対処法1",
  "対処法2",
  "対処法3",
  "対処法4",
  "対処法5"
]

各対処法は具体的で実践的な内容にしてください。
必ずJSON形式で返してください。
''';
  }

  String _createComfortingWordsPrompt(List<BabyStep> babySteps) {
    final stepsData = babySteps
        .map((step) => {
              'date': step.executionDate?.toIso8601String(),
              'beforeScore': step.beforeAnxietyScore,
              'afterScore': step.afterAnxietyScore,
            })
        .toList();

    return '''
以下のベビーステップのデータを分析し、安心につながる言葉を5つ提案してください。
データはJSON形式で提供されます。

データ:
${jsonEncode(stepsData)}

以下の形式で言葉のリストを返してください：
[
  "言葉1",
  "言葉2",
  "言葉3",
  "言葉4",
  "言葉5"
]

各言葉は温かみがあり、励ましになる内容にしてください。
必ずJSON形式で返してください。
''';
  }

  Map<String, dynamic> _parseAnxietyTendencyResponse(String response) {
    try {
      return jsonDecode(response);
    } catch (e) {
      print('不安傾向のパースエラー: $e');
      rethrow;
    }
  }

  List<String> _parseCopingMethodsResponse(String response) {
    try {
      return List<String>.from(jsonDecode(response));
    } catch (e) {
      print('対処法のパースエラー: $e');
      rethrow;
    }
  }

  List<String> _parseComfortingWordsResponse(String response) {
    try {
      return List<String>.from(jsonDecode(response));
    } catch (e) {
      print('安心ワードのパースエラー: $e');
      rethrow;
    }
  }
}
