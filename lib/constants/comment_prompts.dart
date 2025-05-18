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

【不安得点について】
- 不安得点は0-100の範囲で、数値が低いほど不安が少ないことを示します
- 例：10点は不安が少ない状態、90点は強い不安を感じている状態です

【実施結果】
・どのベイビーステップか: $action
・事前不安得点: $beforeAnxietyScore
・事後不安得点: $afterAnxietyScore
・ユーザーコメント: $userComment

【コメント作成時の注意】
- 「失敗」という概念はない。行動を起こしたことがまずすごいし、うまくいかないと思っても「改善点を見つけた」という捉え方を促す。
- 「安心感」「ユーザー自分自身との信頼」が育つようなコメントにする。
- 感情分析をした結果を盛り込んで、ユーザーの気持ちに寄り添ったコメントをする。
- プロフィール情報の名前を使用して「○○さん」と呼びかけてください。
- コメントは以下の形式で出力してください：
  ## 感情分析結果
  [感情分析の内容]

  [寄り添ったあたたかいコメント]
- 「**」は使用しないこと。
''';
  }
}
