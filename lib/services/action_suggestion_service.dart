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

  /// 入力内容を要約・成形する（ステップ生成用）
  Future<String> summarizeContentForSteps({
    required String content,
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
      content: content,
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
        "maxOutputTokens": 2048,
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

  /// ベイビーステップを生成する
  ///
  /// [content] やりたいこと
  /// [role] ユーザーの役割
  /// [profileContext] ユーザーのプロフィールコンテキスト
  ///
  /// 戻り値: 生成されたベイビーステップのリストと分析結果を含むMap
  Future<Map<String, dynamic>> generateBabySteps({
    required String content,
    required String role,
    required String profileContext,
  }) async {
    // まず入力内容を要約（ステップ生成用）
    final summarizedContent = await summarizeContentForSteps(
      content: content,
      role: role,
      profileContext: profileContext,
    );

    if (apiKey.isEmpty) {
      throw Exception('API Keyが設定されていません');
    }

    final url = Uri.parse('$baseUrl?key=$apiKey');
    final headers = {
      'Content-Type': 'application/json',
    };

    // プロンプトの生成
    final prompt = ActionSuggestionPrompts.generateBabyStepsPrompt(
      content: summarizedContent,
      role: role,
      profileContext: profileContext,
    );

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
        "maxOutputTokens": 2048,
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

        // 分析結果を抽出
        final goalMatch = RegExp(r'やりたいこと[:：]\s*(.*)').firstMatch(text);
        final anxietyMatch = RegExp(r'不安なこと[:：]\s*(.*)').firstMatch(text);
        final titleMatch = RegExp(r'タイトル[:：]\s*(.*)').firstMatch(text);
        final categoryMatch = RegExp(r'カテゴリー[:：]\s*(.*)').firstMatch(text);

        if (kDebugMode) {
          print('=== AI分析結果 ===');
          print('やりたいこと: ${goalMatch?.group(1)?.trim() ?? ''}');
          print('不安なこと: ${anxietyMatch?.group(1)?.trim() ?? ''}');
          print('タイトル: ${titleMatch?.group(1)?.trim() ?? ''}');
          print('カテゴリー: ${categoryMatch?.group(1)?.trim() ?? ''}');
          print('=================');
        }

        // 番号付きのリストを抽出（日本語の番号にも対応）
        final steps = RegExp(r'^\d+[\.．]\s*(.+)', multiLine: true)
            .allMatches(text)
            .map((m) => m.group(1)!.trim())
            .take(10)
            .toList();

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

          return {
            'steps': fallbackSteps,
            'goal': goalMatch?.group(1)?.trim() ?? '',
            'anxiety': anxietyMatch?.group(1)?.trim() ?? '',
            'title': titleMatch?.group(1)?.trim() ?? '',
            'category': categoryMatch?.group(1)?.trim() ?? '',
          };
        }

        return {
          'steps': steps,
          'goal': goalMatch?.group(1)?.trim() ?? '',
          'anxiety': anxietyMatch?.group(1)?.trim() ?? '',
          'title': titleMatch?.group(1)?.trim() ?? '',
          'category': categoryMatch?.group(1)?.trim() ?? '',
        };
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

  /// 通常会話用（深掘り質問や共感コメントのみ）
  Future<String> summarizeContentForChat({
    required String content,
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

    // シンプルなプロンプト（contentがそのままプロンプト）
    final prompt = content;

    if (kDebugMode) {
      print('=== 通常会話用プロンプト === ');
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

  /// チャット履歴から10個のベイビーステップのみ生成
  Future<List<String>> generateStepsFromHistory({
    required String chatHistory,
    String role = '',
    String profileContext = '',
  }) async {
    if (apiKey.isEmpty) {
      throw Exception('API Keyが設定されていません');
    }
    final url = Uri.parse('$baseUrl?key=$apiKey');
    final headers = {'Content-Type': 'application/json'};
    final prompt = ActionSuggestionPrompts.generateBabyStepsPrompt(
      content: chatHistory,
      role: role,
      profileContext: profileContext,
    );
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
    final response = await http.post(url, headers: headers, body: body).timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw Exception('リクエストがタイムアウトしました'),
        );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text =
          data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
      if (text.isEmpty) throw Exception('APIからの応答が空です');
      // 1. 2. ... で始まる行のみ抽出
      final steps = RegExp(r'^\d+[\.．]\s*(.+)', multiLine: true)
          .allMatches(text)
          .map((m) => m.group(1)!.trim())
          .take(10)
          .toList();
      return steps;
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error']?['message'] ?? '不明なエラー';
      throw Exception('APIエラー: $errorMessage');
    }
  }

  /// チャット履歴からやりたいこと・不安なこと・タイトル・カテゴリーのみ抽出
  Future<Map<String, String>> extractAnalysisFromHistory({
    required String chatHistory,
    String role = '',
    String profileContext = '',
  }) async {
    if (apiKey.isEmpty) {
      throw Exception('API Keyが設定されていません');
    }
    final url = Uri.parse('$baseUrl?key=$apiKey');
    final headers = {'Content-Type': 'application/json'};
    final prompt = ActionSuggestionPrompts.generateAnalysisOnlyPrompt(
      chatHistory: chatHistory,
      role: role,
      profileContext: profileContext,
    );
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
    final response = await http.post(url, headers: headers, body: body).timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw Exception('リクエストがタイムアウトしました'),
        );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text =
          data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
      if (text.isEmpty) throw Exception('APIからの応答が空です');
      // やりたいこと/不安なこと/タイトル/カテゴリーを抽出
      final goalMatch = RegExp(r'やりたいこと[:：]\s*(.*)').firstMatch(text);
      final anxietyMatch = RegExp(r'不安なこと[:：]\s*(.*)').firstMatch(text);
      final titleMatch = RegExp(r'タイトル[:：]\s*(.*)').firstMatch(text);
      final categoryMatch = RegExp(r'カテゴリー[:：]\s*(.*)').firstMatch(text);
      return {
        'goal': goalMatch?.group(1)?.trim() ?? '',
        'anxiety': anxietyMatch?.group(1)?.trim() ?? '',
        'title': titleMatch?.group(1)?.trim() ?? '',
        'category': categoryMatch?.group(1)?.trim() ?? '',
      };
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error']?['message'] ?? '不明なエラー';
      throw Exception('APIエラー: $errorMessage');
    }
  }
}
