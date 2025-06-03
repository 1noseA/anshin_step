import 'package:flutter/material.dart';
import 'package:anshin_step/models/baby_step.dart';
import 'package:anshin_step/models/goal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:anshin_step/pages/anxiety_score_input.dart';
import 'package:anshin_step/services/action_suggestion_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anshin_step/models/app_user.dart';
import 'package:anshin_step/components/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:anshin_step/constants/action_suggestion_prompts.dart';
import 'package:flutter/services.dart';
import 'dart:math';

// プロフィール情報を取得するProvider
final userProfileProvider = StreamProvider<AppUser?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) {
    return doc.exists ? AppUser.fromJson(doc.data()!) : null;
  });
});

class Chat extends ConsumerStatefulWidget {
  const Chat({super.key});

  @override
  ConsumerState<Chat> createState() => _ChatState();
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class _ChatState extends ConsumerState<Chat> {
  final Uuid _uuid = const Uuid();
  final TextEditingController _inputController = TextEditingController();
  List<BabyStep> _steps = [];
  bool _isGenerating = false;
  String? _goalSummary;
  String? _anxietySummary;
  String? _titleSummary;
  String? _category;
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'こんにちは。不安やパニックで困っていること、今挑戦したいことがあれば教えてください。',
      isUser: false,
    ),
  ];
  bool _isLoading = false;
  bool _isReadyForStepGeneration = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  /// API Keyを取得する
  Future<String?> _getApiKey() async {
    await dotenv.load();
    return dotenv.env['GEMINI_API_KEY'];
  }

  /// ユーザープロファイルを取得する
  Future<AppUser?> _getUserProfile() async {
    final userProfileAsync = ref.watch(userProfileProvider);
    if (userProfileAsync is AsyncData<AppUser?>) {
      return userProfileAsync.value;
    }
    return null;
  }

  /// チャット履歴を1つのテキストにまとめる
  String _buildChatHistoryText() {
    return _messages
        .map((m) => (m.isUser ? 'ユーザー: ' : 'カウンセラー: ') + m.text)
        .join('\n');
  }

  /// AIを使用してベイビーステップのみ生成する
  Future<void> _generateStepsWithAI() async {
    setState(() {
      _isGenerating = true;
    });
    try {
      final userProfile = await _getUserProfile();
      if (userProfile == null) {
        throw Exception('ユーザープロファイルが見つかりません');
      }
      String role = '';
      String profileContext = '';
      if (userProfile.hasMentalIllness == true) {
        role = '認知行動療法の専門家であり、公認心理師・臨床心理士二つの有資格者です';
        if (userProfile.mentalIllnesses != null &&
            userProfile.mentalIllnesses!.isNotEmpty) {
          role = '${userProfile.mentalIllnesses!.join("、")}の臨床経験が豊富な' + role;
        }
      }
      List<String> profileInfo = [];
      profileInfo.add('名前: ${userProfile.userName}');
      if (userProfile.age != null) profileInfo.add('年齢: 「${userProfile.age}歳」');
      if (userProfile.gender != null)
        profileInfo.add('性別: 「${userProfile.gender}」');
      if (userProfile.attribute != null)
        profileInfo.add('属性: 「${userProfile.attribute}」');
      if (userProfile.hasMentalIllness != null)
        profileInfo.add(
            '精神疾患の有無: 「${userProfile.hasMentalIllness == true ? "あり" : "なし"}」');
      if (userProfile.mentalIllnesses != null &&
          userProfile.mentalIllnesses!.isNotEmpty)
        profileInfo.add('診断名: 「${userProfile.mentalIllnesses!.join("、")}"');
      profileContext = '\n\nユーザーのプロフィール情報:\n${profileInfo.join("\n")}';

      final apiKey = await _getApiKey();
      if (apiKey == null) {
        throw Exception('API Keyが取得できませんでした');
      }

      final chatHistoryText = _buildChatHistoryText();
      final actionSuggestionService = ActionSuggestionService(apiKey);
      final steps = await actionSuggestionService.generateStepsFromHistory(
        chatHistory: chatHistoryText,
        role: role,
        profileContext: profileContext,
      );

      if (!mounted) return;

      if (steps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ステップの生成に失敗しました'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      final tempGoalId = _uuid.v4();
      setState(() {
        _steps = steps
            .asMap()
            .entries
            .map((entry) => BabyStep(
                  id: const Uuid().v4(),
                  goalId: tempGoalId,
                  action: entry.value,
                  displayOrder: entry.key,
                  isDone: false,
                  isDeleted: false,
                  createdBy: userProfile.createdBy,
                  createdAt: DateTime.now(),
                  updatedBy: userProfile.updatedBy,
                  updatedAt: DateTime.now(),
                ))
            .toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ステップを生成しました'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('エラーが発生しました: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _isLoading = false;
          _isReadyForStepGeneration = false;
        });
      }
    }
  }

  void _clearSteps() {
    setState(() {
      _steps.clear();
    });
  }

  void _saveSteps() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_steps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ステップが生成されていません')),
        );
        return;
      }

      // チャット履歴のユーザー発言を連結
      final userContent =
          _messages.where((m) => m.isUser).map((m) => m.text).join('\n');

      final userProfile = await _getUserProfile();
      if (userProfile == null) {
        throw Exception('ユーザープロファイルが見つかりません');
      }
      String role = '';
      String profileContext = '';
      if (userProfile.hasMentalIllness == true) {
        role = '認知行動療法の専門家であり、公認心理師・臨床心理士二つの有資格者です';
        if (userProfile.mentalIllnesses != null &&
            userProfile.mentalIllnesses!.isNotEmpty) {
          role = '${userProfile.mentalIllnesses!.join("、")}の臨床経験が豊富な' + role;
        }
      }
      List<String> profileInfo = [];
      profileInfo.add('名前: ${userProfile.userName}');
      if (userProfile.age != null) profileInfo.add('年齢: 「${userProfile.age}歳」');
      if (userProfile.gender != null)
        profileInfo.add('性別: 「${userProfile.gender}」');
      if (userProfile.attribute != null)
        profileInfo.add('属性: 「${userProfile.attribute}」');
      if (userProfile.hasMentalIllness != null)
        profileInfo.add(
            '精神疾患の有無: 「${userProfile.hasMentalIllness == true ? "あり" : "なし"}」');
      if (userProfile.mentalIllnesses != null &&
          userProfile.mentalIllnesses!.isNotEmpty)
        profileInfo.add('診断名: 「${userProfile.mentalIllnesses!.join("、")}"');
      profileContext = '\n\nユーザーのプロフィール情報:\n${profileInfo.join("\n")}';

      final apiKey = await _getApiKey();
      if (apiKey == null) {
        throw Exception('API Keyが取得できませんでした');
      }

      final chatHistoryText = _buildChatHistoryText();
      final actionSuggestionService = ActionSuggestionService(apiKey);
      final analysis = await actionSuggestionService.extractAnalysisFromHistory(
        chatHistory: chatHistoryText,
        role: role,
        profileContext: profileContext,
      );

      // ユーザーの既存のGoal数を取得
      final userGoals = await FirebaseFirestore.instance
          .collection('goals')
          .where('created_by',
              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      // 新しいGoalのIDを生成
      final newGoalId = _uuid.v4();

      // BabyStepにdisplayOrderを設定
      final stepsWithOrder = _steps.asMap().entries.map((entry) {
        final step = entry.value;
        return BabyStep(
          id: step.id,
          goalId: newGoalId,
          action: step.action,
          displayOrder: entry.key + 1,
          isDone: step.isDone,
          isDeleted: false,
          createdBy: step.createdBy,
          createdAt: step.createdAt,
          updatedBy: step.updatedBy,
          updatedAt: step.updatedAt,
        );
      }).toList();

      // Goalを作成
      final newGoal = Goal(
        id: newGoalId,
        content: userContent,
        originalContent: userContent,
        babySteps: stepsWithOrder,
        displayOrder: userGoals.docs.length + 1,
        isDeleted: false,
        createdBy: FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user',
        createdAt: DateTime.now(),
        updatedBy: FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user',
        updatedAt: DateTime.now(),
        title: analysis['title'] ?? '',
        goal: analysis['goal'] ?? '',
        anxiety: analysis['anxiety'] ?? '',
        category: analysis['category'] ?? '',
      );

      final goalRef =
          FirebaseFirestore.instance.collection('goals').doc(newGoal.id);
      await goalRef.set(newGoal.toJson());

      // BabyStepを更新してgoalIdを設定
      final batch = FirebaseFirestore.instance.batch();
      for (final step in stepsWithOrder) {
        final stepRef = goalRef.collection('babySteps').doc(step.id);
        final stepData = {
          ...step.toJson(),
          'goalId': newGoal.id, // 必ずgoalIdを設定
          'createdBy': FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user',
          'updatedBy': FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user',
        };
        batch.set(stepRef, stepData);
      }
      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存が完了しました')),
        );
        _inputController.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AnxietyScoreInput(
              steps: stepsWithOrder,
              goalId: newGoalId,
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存エラー:  ${e.toString()}')),
        );
        if (kDebugMode) {
          print('Firestore保存エラー詳細:');
          print('エラータイプ: ${e.runtimeType}');
          print('エラーメッセージ: ${e.toString()}');
          print('スタックトレース: $stackTrace');
          print('入力データ:');
          print('内容: ${_inputController.text}');
          print('ステップ数: ${_steps.length}');
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isGenerating = false;
          _isReadyForStepGeneration = false;
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    if (_isLoading) return;

    setState(() {
      _messages.add(ChatMessage(text: input, isUser: true));
      _isLoading = true;
      _inputController.clear();
    });

    int retryCount = 0;
    const maxRetries = 3;

    // 具体的な不安点ワード（体調・吐き気なども含める）
    final extraConcreteWords = [
      '体調',
      '吐き気',
      '気分が悪い',
      '気分悪く',
      '気分がすぐれない',
      'めまい',
      '動悸',
      '息苦しい',
      '冷や汗',
      'パニック',
      '発作',
      '不安発作',
      '気持ち悪い'
    ];

    // ユーザー発言数
    final userMsgCount = _messages.where((m) => m.isUser).length;
    final isFirstUserInput = userMsgCount == 1;

    // 目標系・不安系ワードのリスト
    final goalWords = [
      'やりたい',
      'やらなければ',
      '達成したい',
      '向き合いたい',
      '挑戦したい',
      '目標',
      'したい'
    ];
    final anxietyWords = ['不安', '悩み', '困っている', '怖い', '心配', '恐怖'];
    // 具体的な不安ワードを拡充
    final concreteWords = [
      '体調',
      '吐き気',
      '息苦しい',
      '動悸',
      '汗',
      'パニック',
      '発作',
      '混雑',
      '人混み',
      'トイレ',
      '閉塞感',
      '逃げられない',
      '乗り換え',
      '車内',
      '出口',
      '座れない',
      '暑い',
      '寒い',
      '周囲の目',
      '視線',
      '話しかけられる',
      '遅延',
      '停車',
      '長時間',
      '短時間',
      '距離',
      '時間',
      '不快',
      '不安',
      '怖い',
      '心配',
      '困る',
      '緊張',
      'めまい',
      '不調',
      '不快感',
      '不安感',
    ];

    // 目標・不安の有無
    final allUserText =
        _messages.where((m) => m.isUser).map((m) => m.text).join('\n');
    final allHasGoal = goalWords.any((w) => allUserText.contains(w));
    final allHasAnxiety = anxietyWords.any((w) => allUserText.contains(w));
    // 直前のAIが深掘り質問、直後のユーザー発言にconcreteWordsが含まれる場合のみ具体的な不安とみなす
    final isDeepQuestion = concreteWords.any((w) => allUserText.contains(w));
    final isConcreteAnswer = concreteWords.any((w) => input.contains(w));
    // isEnoughは深掘り質問→具体的な答えのペアでのみtrue
    final isEnough = !isFirstUserInput &&
        allHasGoal &&
        allHasAnxiety &&
        isDeepQuestion &&
        isConcreteAnswer;

    // 具体的な不安点が入力されたらフラグを立てる（ただし最初の入力は除外）
    final hasConcreteSymptom = concreteWords.any((w) => input.contains(w)) ||
        extraConcreteWords.any((w) => input.contains(w));
    if (!isFirstUserInput && hasConcreteSymptom) {
      setState(() {
        _isReadyForStepGeneration = true;
      });
      // ここでreturnせず、AI返事も必ず返す
    }

    while (retryCount < maxRetries) {
      try {
        final apiKey = await _getApiKey();
        if (apiKey == null) throw Exception('API Keyが取得できませんでした');

        final service = ActionSuggestionService(apiKey);
        // 直近の会話履歴（ユーザー・AI合わせて直近6件＝3往復）
        final recentHistory = _messages.length > 6
            ? _messages.sublist(_messages.length - 6)
            : _messages;
        final historyText = recentHistory
            .map((m) => (m.isUser ? 'ユーザー: ' : 'カウンセラー: ') + m.text)
            .join('\n');
        final systemPrompt =
            'あなたはカウンセラーです。会話履歴を考慮し、すでに聞いた内容やユーザーが答えた内容は繰り返さず、1回につき1つだけ短い質問だけを返してください。あなたが答えるのではなく、必ずユーザーに質問してください。\n$historyText\nカウンセラー:';
        String prompt = '';
        if (isFirstUserInput) {
          prompt = systemPrompt;
        } else if (!allHasGoal) {
          prompt = systemPrompt;
        } else if (!allHasAnxiety) {
          prompt = systemPrompt;
        } else if (!isDeepQuestion || !isConcreteAnswer) {
          prompt = systemPrompt;
        }
        if (isEnough) {
          // ベイビーステップ提案APIのみ呼ぶ
          await _generateStepsWithAI();
          setState(() {
            _isLoading = false;
          });
        } else {
          // 通常会話用API呼び出し
          final aiReply = await service.summarizeContentForChat(
            content: prompt,
            role: '',
            profileContext: '',
          );
          if (mounted) {
            setState(() {
              _messages.add(
                  ChatMessage(text: aiReply ?? 'AIからの返答がありません', isUser: false));
              _isLoading = false;
            });
          }
        }
        break;
      } catch (e) {
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(Duration(seconds: 1)); // Wait between retries
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('最大リトライ回数に達しました: $e')),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final isProfileReady = userProfileAsync is AsyncData<AppUser?> &&
        userProfileAsync.value != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: (ModalRoute.of(context)?.canPop ?? false)
            ? const BackButton()
            : null,
        centerTitle: true,
        title: const Text(
          '新しい行動プランを作成',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        surfaceTintColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Container(
        color: AppColors.background,
        child: Column(
          children: [
            Container(
              height: 1,
              color: const Color(0xFFE0E3E8),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ..._messages.map((msg) => Align(
                        alignment: msg.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: msg.isUser
                                  ? AppColors.primary
                                  : const Color(0xFFE0E3E8),
                            ),
                          ),
                          child: Text(
                            msg.text.replaceAll('**', ''),
                            style: TextStyle(
                              color: msg.isUser
                                  ? AppColors.primary
                                  : AppColors.text,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      )),
                  if (_steps.isNotEmpty)
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: _steps.length == 10
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('提案されたベイビーステップ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    const SizedBox(height: 8),
                                    Text(
                                      _steps
                                          .asMap()
                                          .entries
                                          .map((entry) =>
                                              '${entry.key + 1}. ${entry.value.action.replaceAll('**', '')}')
                                          .join('\n\n'),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                )
                              : const Text('ベイビーステップが正しく抽出できませんでした',
                                  style: TextStyle(color: Colors.red)),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _saveSteps,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            minimumSize: const Size.fromHeight(44),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                          ),
                          child: const Text('保存する'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            if (_isReadyForStepGeneration && _steps.isEmpty)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await _generateStepsWithAI();
                          setState(() {
                            _isLoading = false;
                            _isReadyForStepGeneration = false;
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24))),
                  ),
                  child: const Text('ステップを生成する'),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        hintText: 'メッセージを入力...',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.primary),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: null,
    );
  }
}
