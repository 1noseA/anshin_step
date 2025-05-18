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
        final rawComment = text.trim();

        // 感情分析結果とコメントを分離
        final parts = rawComment.split('\n\n');
        String analysis = '';
        String comment = '';

        for (var part in parts) {
          if (part.startsWith('## 感情分析結果')) {
            analysis = part.replaceAll('## 感情分析結果', '').trim();
          } else {
            comment = part.trim();
          }
        }

        if (kDebugMode) {
          print('=== 感情分析結果 === ');
          print(analysis);
          print('=== 生成されたコメント === ');
          print(comment);
          print('==============================');
        }

        // 「**」を削除して返す
        return comment.replaceAll('**', '');
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

  /// 専門家受診レコメンド判定用の正規表現
  static final RegExp _recommendRegExp =
      RegExp(r'^(推奨|不要)[:：]\s*(.*)', multiLine: true);

  /// GeminiAIによる専門家受診レコメンド判定
  Future<({bool shouldRecommend, String reason})> checkRecommendConsultation({
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
    final prompt = CommentPrompts.generateRecommendPrompt(
      profileContext: profileContext,
      action: action,
      beforeAnxietyScore: beforeAnxietyScore,
      afterAnxietyScore: afterAnxietyScore,
      userComment: userComment,
    );
    if (kDebugMode) {
      print('=== 専門家受診レコメンド用プロンプト === ');
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
        "temperature": 0.2,
        "topK": 40,
        "topP": 0.95,
        "maxOutputTokens": 128,
      }
    });
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
      if (kDebugMode) {
        print('=== AI返答全文 ===');
        print(text);
        print('================');
      }
      final lines = text.trim().split('\n');
      String? result;
      StringBuffer reasonBuffer = StringBuffer();
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].replaceAll('**', '').trim();
        // 新形式「判定: 推奨 理由: ...」や「判定: 不要 理由: ...」
        final judgeMatch =
            RegExp(r'^判定[:：]\s*(推奨|不要)\s*理由[:：]\s*(.*)').firstMatch(line);
        if (judgeMatch != null) {
          result = judgeMatch.group(1);
          reasonBuffer.write(judgeMatch.group(2));
          for (int j = i + 1; j < lines.length; j++) {
            reasonBuffer.writeln(lines[j]);
          }
          break;
        }
        // リスト形式「- 判定: 推奨」
        final listJudgeMatch =
            RegExp(r'^-\s*判定[:：]\s*(推奨|不要)').firstMatch(line);
        if (listJudgeMatch != null) {
          result = listJudgeMatch.group(1);
          // 「- 理由: ...」を次の行から探す
          for (int j = i + 1; j < lines.length; j++) {
            final reasonLine = lines[j].replaceAll('**', '').trim();
            final reasonMatch =
                RegExp(r'^-\s*理由[:：]\s*(.*)').firstMatch(reasonLine);
            if (reasonMatch != null) {
              reasonBuffer.write(reasonMatch.group(1));
              break;
            }
          }
          break;
        }
        // 旧形式
        if (line == '推奨' || line == '不要') {
          result = line;
          for (int j = i + 1; j < lines.length; j++) {
            reasonBuffer.writeln(lines[j]);
          }
          break;
        }
        final match = RegExp(r'^(推奨|不要)[:：]\s*(.*)').firstMatch(line);
        if (match != null) {
          result = match.group(1);
          reasonBuffer.write(match.group(2));
          for (int j = i + 1; j < lines.length; j++) {
            reasonBuffer.writeln(lines[j]);
          }
          break;
        }
      }
      if (result != null) {
        final shouldRecommend = result == '推奨';
        // 理由は1行目のみを抽出
        String reason = reasonBuffer.toString().trim();
        if (reason.contains('\n')) {
          reason = reason.split('\n').first.trim();
        }
        return (shouldRecommend: shouldRecommend, reason: reason);
      } else {
        throw Exception('APIレスポンスの解析に失敗しました: $text');
      }
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error']?['message'] ?? '不明なエラー';
      throw Exception('APIエラー: $errorMessage');
    }
  }
}
