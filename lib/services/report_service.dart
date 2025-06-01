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
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  // レポートを生成・更新する
  Future<void> generateReport(String userId, {String? goalId}) async {
    try {
      print('=== ReportService.generateReport開始 ===');
      print('ユーザーID: $userId');
      print('ゴールID: $goalId');

      // ユーザーのベビーステップを取得
      // まずgoalsコレクションを取得
      print('ゴール取得開始...');
      print('Firestoreのパス: goals');
      print('クエリ条件: createdBy = $userId');
      final goalsSnapshot = await _firestore
          .collection('goals')
          .where('createdBy', isEqualTo: userId)
          .get();

      print('取得したゴール数: ${goalsSnapshot.docs.length}');
      print('ゴールID一覧: ${goalsSnapshot.docs.map((doc) => doc.id).join(', ')}');
      print('ゴールのデータ: ${goalsSnapshot.docs.map((doc) => doc.data()).toList()}');

      // ベビーステップを格納するリスト
      List<QueryDocumentSnapshot> allBabySteps = [];

      // ゴールが取得できない場合、直接goalIdを使用してベビーステップを取得
      if (goalsSnapshot.docs.isEmpty && goalId != null) {
        print('ゴールが取得できませんでした。直接ベビーステップを取得します。');
        final babyStepsSnapshot = await _firestore
            .collection('goals')
            .doc(goalId)
            .collection('babySteps')
            .where('isDeleted', isEqualTo: false)
            .orderBy('createdAt', descending: true)
            .get();

        print('直接取得したベビーステップ数: ${babyStepsSnapshot.docs.length}');
        print(
            'ベビーステップのデータ: ${babyStepsSnapshot.docs.map((doc) => doc.data()).toList()}');

        if (babyStepsSnapshot.docs.isNotEmpty) {
          allBabySteps.addAll(babyStepsSnapshot.docs);
        }
      } else {
        // 各ゴールのサブコレクションからベビーステップを取得
        for (var goalDoc in goalsSnapshot.docs) {
          print('ゴールID ${goalDoc.id} のベビーステップを取得中...');
          final babyStepsSnapshot = await goalDoc.reference
              .collection('babySteps')
              .where('isDeleted', isEqualTo: false)
              .orderBy('createdAt', descending: true)
              .get();
          print(
              'ゴールID ${goalDoc.id} のベビーステップ数: ${babyStepsSnapshot.docs.length}');
          print(
              'ベビーステップのデータ: ${babyStepsSnapshot.docs.map((doc) => doc.data()).toList()}');
          allBabySteps.addAll(babyStepsSnapshot.docs);
        }
      }

      print('取得したベビーステップ数: ${allBabySteps.length}');

      if (allBabySteps.isEmpty) {
        print('ベビーステップが存在しないため、レポート生成をスキップします');
        return;
      }

      // ベビーステップのデータを変換
      final babyStepsData = allBabySteps
          .map((stepDoc) {
            final stepData = stepDoc.data() as Map<String, dynamic>;
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

      print('変換後のベビーステップ数: ${babyStepsData.length}');

      // 不安得点の推移を生成
      final anxietyScoreHistory = _generateAnxietyScoreHistory(babyStepsData);

      // 不安傾向を分析（AIを使用）
      print('不安傾向の分析を開始します');
      final anxietyTendency = await _analyzeAnxietyTendency(babyStepsData);

      // 効果的な対処法を生成（AIを使用）
      print('対処法の生成を開始します');
      final effectiveCopingMethods =
          await _generateEffectiveCopingMethods(babyStepsData);

      // 安心につながる言葉を生成（AIを使用）
      print('安心ワードの生成を開始します');
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

      print('レポートをFirestoreに保存します');
      await _firestore
          .collection('reports')
          .doc('report_$userId')
          .set(report.toJson());

      print('=== ReportService.generateReport完了 ===');
    } catch (e) {
      print('Error generating report: $e');
      print('エラーの詳細: ${e.toString()}');
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
    print('=== AIプロンプト（不安傾向分析） ===\n$prompt');
    final response = await _callAI(prompt);
    return _parseAnxietyTendencyResponse(response);
  }

  Future<List<String>> _generateEffectiveCopingMethods(
      List<BabyStep> babySteps) async {
    final prompt = _createCopingMethodsPrompt(babySteps);
    print('=== AIプロンプト（対処法生成） ===\n$prompt');
    final response = await _callAI(prompt);
    return _parseCopingMethodsResponse(response);
  }

  Future<List<String>> _generateComfortingWords(
      List<BabyStep> babySteps) async {
    final prompt = _createComfortingWordsPrompt(babySteps);
    print('=== AIプロンプト（安心ワード生成） ===\n$prompt');
    final response = await _callAI(prompt);
    return _parseComfortingWordsResponse(response);
  }

  Future<String> _callAI(String prompt) async {
    try {
      print('=== AI呼び出し開始 ===');
      print('API URL: $_apiUrl');
      print('プロンプト: $prompt');

      final response = await http.post(
        Uri.parse('$_apiUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
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

      print('APIレスポンスステータス: ${response.statusCode}');
      print('APIレスポンス本文: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['candidates'][0]['content']['parts'][0]['text'];
        print('=== AI呼び出し成功 ===');
        print('結果: $result');
        return result;
      } else {
        print('=== AI呼び出しエラー ===');
        print('エラー内容: ${response.body}');
        throw Exception('API呼び出しに失敗しました: ${response.statusCode}');
      }
    } catch (e) {
      print('=== AI呼び出し例外 ===');
      print('例外内容: $e');
      rethrow;
    }
  }

  String _createAnxietyTendencyPrompt(List<BabyStep> babySteps) {
    final stepsData = babySteps
        .map((step) => {
              'date': step.executionDate?.toIso8601String(),
              'action': step.action,
              'beforeScore': step.beforeAnxietyScore,
              'afterScore': step.afterAnxietyScore,
              'achievementScore': step.achievementScore,
              'weather': step.weather,
              'temperature': step.temperature,
              'pressure': step.pressure,
              'lunarAge': step.lunarAge,
              'impression': step.impression,
              'copingMethod': step.copingMethod,
              'physicalData': step.physicalData,
              'word': step.word,
            })
        .toList();

    return '''
以下のベビーステップのデータを分析し、不安の傾向を特定してください。
データはJSON形式で提供されます。

データ:
${jsonEncode(stepsData)}

以下の形式で分析結果を返してください。必ずJSON形式のみを返し、マークダウンやその他の装飾は含めないでください：
{
  "analysis": {
    "summary": "不安の傾向に関する自然な日本語の説明（2〜3文程度、物理名ではなく論理名（例：行動、事前不安得点、達成度、身体情報、言葉、感想、対処法など）を使って、あなたの傾向や合いそうな対処法の方向性が分かるようにまとめてください）"
  }
}

注意点：
1. データが不足している場合は、「情報が不足しています。ベビーステップを記録すると、より詳細な分析が表示されます。」と返してください
2. 不安スコアの変化（事前不安得点 - 事後不安得点）を重視して分析してください
3. 以下の要素を考慮して分析してください：
   - 行動（action）とその達成度（achievementScore）
   - 身体情報（physicalData）
   - 言葉（word）
   - 感想（impression）や対処法（copingMethod）
4. 分析結果は自然な日本語で、温かみのある説明的な内容にしてください
''';
  }

  String _createCopingMethodsPrompt(List<BabyStep> babySteps) {
    final stepsData = babySteps
        .map((step) => {
              'date': step.executionDate?.toIso8601String(),
              'action': step.action,
              'beforeScore': step.beforeAnxietyScore,
              'afterScore': step.afterAnxietyScore,
              'achievementScore': step.achievementScore,
              'physicalData': step.physicalData,
              'word': step.word,
              'copingMethod': step.copingMethod,
              'impression': step.impression,
            })
        .toList();

    return '''
以下のベビーステップのデータを分析し、効果的な対処法を5つ提案してください。
データはJSON形式で提供されます。

データ:
${jsonEncode(stepsData)}

以下の形式で対処法のリストを返してください。必ずJSON形式のみを返し、マークダウンやその他の装飾は含めないでください：
[
  "対処法1",
  "対処法2",
  "対処法3",
  "対処法4",
  "対処法5"
]

注意点：
1. 過去の対処法（copingMethod）の効果を分析し、特に効果があったものを参考にしてください
2. 行動内容（action）と達成度（achievementScore）を考慮して、実践的な対処法を提案してください
3. 身体状態（physicalData）や使用した言葉（word）も参考にしてください
4. 各対処法は具体的で実践的な内容にしてください
''';
  }

  String _createComfortingWordsPrompt(List<BabyStep> babySteps) {
    final stepsData = babySteps
        .map((step) => {
              'date': step.executionDate?.toIso8601String(),
              'action': step.action,
              'beforeScore': step.beforeAnxietyScore,
              'afterScore': step.afterAnxietyScore,
              'achievementScore': step.achievementScore,
              'physicalData': step.physicalData,
              'word': step.word,
              'impression': step.impression,
            })
        .toList();

    return '''
以下のベビーステップのデータを分析し、安心につながる言葉を5つ提案してください。
データはJSON形式で提供されます。

データ:
${jsonEncode(stepsData)}

以下の形式で言葉のリストを返してください。必ずJSON形式のみを返し、マークダウンやその他の装飾は含めないでください：
[
  "言葉1",
  "言葉2",
  "言葉3",
  "言葉4",
  "言葉5"
]

注意点：
1. 過去に使用した言葉（word）で効果があったものを参考にしてください
2. 行動内容（action）と達成度（achievementScore）を考慮して、励ましになる言葉を提案してください
3. 身体状態（physicalData）や印象（impression）も参考にしてください
4. 各言葉は温かみがあり、励ましになる内容にしてください
''';
  }

  Map<String, dynamic> _parseAnxietyTendencyResponse(String response) {
    try {
      // レスポンスからJSON部分のみを抽出
      final jsonStr =
          response.replaceAll('```json', '').replaceAll('```', '').trim();
      final result = jsonDecode(jsonStr);

      // データの制限がある場合は、その旨をログに出力
      if (result['dataLimitations'] != null) {
        print('データの制限: ${result['dataLimitations']}');
      }

      return result;
    } catch (e) {
      print('不安傾向のパースエラー: $e');
      print('パース対象のレスポンス: $response');
      rethrow;
    }
  }

  List<String> _parseCopingMethodsResponse(String response) {
    try {
      // レスポンスからJSON部分のみを抽出
      final jsonStr =
          response.replaceAll('```json', '').replaceAll('```', '').trim();
      return List<String>.from(jsonDecode(jsonStr));
    } catch (e) {
      print('対処法のパースエラー: $e');
      print('パース対象のレスポンス: $response');
      rethrow;
    }
  }

  List<String> _parseComfortingWordsResponse(String response) {
    try {
      // レスポンスからJSON部分のみを抽出
      final jsonStr =
          response.replaceAll('```json', '').replaceAll('```', '').trim();
      return List<String>.from(jsonDecode(jsonStr));
    } catch (e) {
      print('安心ワードのパースエラー: $e');
      print('パース対象のレスポンス: $response');
      rethrow;
    }
  }
}
