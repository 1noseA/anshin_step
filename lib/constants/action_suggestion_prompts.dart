import 'dart:convert';

class ActionSuggestionPrompts {
  /// ベイビーステップ生成用のプロンプト
  static String generateBabyStepsPrompt({
    required String goal,
    required String anxiety,
  }) {
    return jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": '''
あなたは、不安を抱える人々のためのベイビーステップ生成アシスタントです。
以下の目標と不安に対して、10個の具体的なベイビーステップを生成してください。

目標: $goal
不安: $anxiety

以下の形式で10個のベイビーステップを生成してください：
1. 最初のステップ
2. 次のステップ
...

注意点：
- 各ステップは具体的で実行可能なものにしてください
- 不安を軽減するような優しい言葉遣いを心がけてください
- 各ステップは1行で簡潔に表現してください
- 必ず10個のステップを生成してください
- 番号付きのリスト形式で出力してください
'''
            }
          ]
        }
      ]
    });
  }
}
