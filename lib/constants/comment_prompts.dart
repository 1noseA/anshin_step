import 'dart:convert';

/// コメント生成用のプロンプトを定義するクラス
class CommentPrompts {
  /// ベイビーステップの実施結果に対するコメントを生成するプロンプトを作成
  static String generateCommentPrompt({
    required String profileContext,
    required String action,
    required String beforeAnxietyScore,
    required String afterAnxietyScore,
    required String userComment,
  }) {
    return '''
$profileContext

以下のベイビーステップの実施結果について、感情分析を行い、ユーザーに寄り添ったあたたかいコメントを作成してください。
・どのベイビーステップか: $action
・事前不安得点: $beforeAnxietyScore
・事後不安得点: $afterAnxietyScore
・ユーザーコメント: $userComment

【コメント作成時の注意】
- 「失敗」という概念はない。行動を起こしたことがまずすごいし、うまくいかないと思っても「改善点を見つけた」という捉え方を促す。
- 「安心感」「ユーザー自分自身との信頼」が育つようなコメントにする。
- 感情分析をし、ユーザーの気持ちに寄り添う。
''';
  }
}
