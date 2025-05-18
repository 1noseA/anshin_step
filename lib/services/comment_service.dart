import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:anshin_step/constants/comment_prompts.dart';

/// ベイビーステップの実施結果に対するAIコメント生成サービスクラス
class CommentService {
  final String apiKey;
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  CommentService(this.apiKey);

  /// AIコメントを生成する
  Future<String> generateComment({
    required String profileContext,
    required String action,
    required String beforeAnxietyScore,
    required String afterAnxietyScore,
    required String userComment,
  }) async {
    if (apiKey.isEmpty) {
      throw Exception('API Keyが設定されていません');
    }

    final url = Uri.parse('$baseUrl?key=$apiKey');
    final headers = {
      'Content-Type': 'application/json',
    };

    final prompt = CommentPrompts.generateCommentPrompt(
      profileContext: profileContext,
      action: action,
      beforeAnxietyScore: beforeAnxietyScore,
      afterAnxietyScore: afterAnxietyScore,
      userComment: userComment,
    );

    if (kDebugMode) {
      print('=== 生成されたプロンプト === ');
      print(prompt);
      print('==============================');
    }

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
        "maxOutputTokens": 512,
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
        return text.trim();
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
