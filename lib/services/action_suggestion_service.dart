import 'dart:convert';
import 'package:anshin_step/constants/action_suggestion_prompts.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// ベイビーステップ提案サービスクラス
///
/// GeminiAIのAPIを使用して、目標と不安からベイビーステップを生成します。
class ActionSuggestionService {
  final String apiKey;
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  ActionSuggestionService(this.apiKey);

  /// ベイビーステップを生成する
  ///
  /// [goal] やりたいこと
  /// [anxiety] 不安なこと
  ///
  /// 戻り値: 生成されたベイビーステップのリスト
  Future<List<String>> generateBabySteps({
    required String goal,
    required String anxiety,
    required String role,
    required String profileContext,
  }) async {
    if (apiKey.isEmpty) {
      throw Exception('API Keyが設定されていません');
    }

    final url = Uri.parse('$baseUrl?key=$apiKey');
    final headers = {
      'Content-Type': 'application/json',
    };

    // プロンプトの生成
    final prompt = ActionSuggestionPrompts.generateBabyStepsPrompt(
      goal: goal,
      anxiety: anxiety,
      role: role,
      profileContext: profileContext,
    );

    if (kDebugMode) {
      print('=== 生成されたプロンプト === ');
      print(prompt);
      print('==============================');
    }

    // リクエストボディの形式を修正
    final body = jsonEncode({
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": prompt}
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.7,
        "topK": 40,
        "topP": 0.95,
        "maxOutputTokens": 1024,
      }
    });

    try {
      final response = await http
          .post(
        url,
        headers: headers,
        body: body,
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('リクエストがタイムアウトしました');
        },
      );

      if (kDebugMode) {
        print('APIレスポンスステータス: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';

        if (text.isEmpty) {
          throw Exception('APIからの応答が空です');
        }

        // 番号付きのリストを抽出（日本語の番号にも対応）
        final steps = RegExp(r'^\d+[\.．]\s*(.+)$', multiLine: true)
            .allMatches(text)
            .map((m) => m.group(1)!.trim().replaceAll('**', ''))
            .take(10)
            .toList()
            .cast<String>();

        if (steps.length < 10) {
          final fallbackSteps = (text.split('\n') as List<String>)
              .where((e) => e.trim().isNotEmpty)
              .map((e) => e
                  .replaceAll(RegExp(r'^\d+[\.．]\s*'), '')
                  .trim()
                  .replaceAll('**', ''))
              .where((e) => e.isNotEmpty)
              .take(10)
              .toList();

          return fallbackSteps;
        }

        return steps;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']?['message'] ?? '不明なエラー';
        throw Exception('APIエラー: $errorMessage');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('エラー詳細: $e');
        print('スタックトレース: $stackTrace');
      }
      if (e is FormatException) {
        throw Exception('APIレスポンスの解析に失敗しました');
      } else if (e is http.ClientException) {
        throw Exception('ネットワークエラーが発生しました');
      } else {
        throw Exception('予期せぬエラーが発生しました');
      }
    }
  }
}
