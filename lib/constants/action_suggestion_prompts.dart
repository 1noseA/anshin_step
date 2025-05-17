import 'dart:convert';

class ActionSuggestionPrompts {
  /// ベイビーステップ生成用のプロンプト
  static String generateBabyStepsPrompt({
    required String goal,
    required String anxiety,
    String role = '認知行動療法の専門家であり、公認心理師・臨床心理士二つの有資格者です',
    String profileContext = '',
  }) {
    return '''
あなたは$role。
ユーザーの目標と不安に対して、10個の具体的なベイビーステップを提案してください。
各ステップは具体的で実行可能なものにしてください。
$profileContext

目標: $goal
不安: $anxiety

以下の形式で10個のベイビーステップを提案してください：
1. [具体的なステップ]
2. [具体的なステップ]
...

各ステップは以下の点に注意して作成してください：
- 各ステップは1行で簡潔に表現
- 段階的に難易度が上がるように構成
- 認知行動療法の不安階層表や暴露療法の知識を活用
- 不安な人が使っているアプリなので無理のない行動を提案する
''';
  }
}
