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

class _ChatState extends ConsumerState<Chat> {
  final Uuid _uuid = const Uuid();
  final _contentController = TextEditingController();
  List<BabyStep> _steps = [];
  bool _isGenerating = false;

  @override
  void dispose() {
    _contentController.dispose();
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

  /// Goalを保存する
  Future<void> _saveGoal(Goal goal) async {
    // TODO: データベースに保存する処理を実装
    if (kDebugMode) {
      print('Goalを保存: ${goal.content}');
    }
  }

  /// AIを使用してベイビーステップを生成する
  Future<void> _generateStepsWithAI() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('目標や不安なことを入力してください'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final apiKey = await _getApiKey();
    if (apiKey == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('API Keyが設定されていません'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    String role = '不安を抱える人々のためのベイビーステップ生成アシスタント';
    String profileContext = '';

    try {
      final userProfile = await _getUserProfile();
      if (userProfile == null) {
        throw Exception('ユーザープロファイルが見つかりません');
      }

      // プロフィール情報からrole, profileContextを組み立て
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
        profileInfo.add('診断名: 「${userProfile.mentalIllnesses!.join("、")}」');
      profileContext = '\n\nユーザーのプロフィール情報:\n${profileInfo.join("\n")}';

      final actionSuggestionService = ActionSuggestionService(apiKey);

      // 入力内容を要約（登録・表示用）
      final summarizedContent = await actionSuggestionService.summarizeContent(
        content: _contentController.text,
        role: role,
        profileContext: profileContext,
      );

      // ベイビーステップを生成
      final steps = await actionSuggestionService.generateBabySteps(
        content: _contentController.text,
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

      // 生成したステップを_stateの_stepsリストにセット
      final currentText = _contentController.text;
      setState(() {
        _steps = steps
            .map((step) => BabyStep(
                  id: const Uuid().v4(),
                  action: step,
                  isDone: false,
                  displayOrder: steps.indexOf(step),
                  isDeleted: false,
                  createdBy: userProfile.createdBy,
                  createdAt: DateTime.now(),
                  updatedBy: userProfile.updatedBy,
                  updatedAt: DateTime.now(),
                ))
            .toList();
        _contentController.text = currentText;
      });

      // 新しいGoalを作成
      final goal = Goal(
        id: const Uuid().v4(),
        content: summarizedContent, // 登録・表示用の要約
        originalContent: _contentController.text, // 元の入力内容
        babySteps: _steps,
        displayOrder: 0,
        isDeleted: false,
        createdBy: userProfile.createdBy,
        createdAt: DateTime.now(),
        updatedBy: userProfile.updatedBy,
        updatedAt: DateTime.now(),
      );

      // Goalを保存
      await _saveGoal(goal);

      // 成功メッセージを表示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ステップを生成しました'),
          duration: Duration(seconds: 2),
        ),
      );

      // ステップ一覧画面への自動遷移を削除
      // if (!mounted) return;
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const StepList(),
      //   ),
      // );
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
    try {
      if (_steps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ステップが生成されていません')),
        );
        return;
      }

      final content = _contentController.text.trim();

      if (content.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('内容を入力してください')),
        );
        return;
      }

      // ユーザーの既存のGoal数を取得
      final userGoals = await FirebaseFirestore.instance
          .collection('goals')
          .where('created_by',
              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      // BabyStepにdisplayOrderを設定
      final stepsWithOrder = _steps.asMap().entries.map((entry) {
        final step = entry.value;
        return BabyStep(
          id: step.id,
          action: step.action,
          isDone: step.isDone,
          displayOrder: entry.key + 1, // 1から10までの連番
          isDeleted: false,
          createdBy: step.createdBy,
          createdAt: step.createdAt,
          updatedBy: step.updatedBy,
          updatedAt: step.updatedAt,
          goalId: null, // 一時的にnullを設定
        );
      }).toList();

      // 入力内容を要約・成形
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        throw Exception('API Keyが設定されていません');
      }

      final actionService = ActionSuggestionService(apiKey);
      final userProfileAsync = ref.watch(userProfileProvider);
      final userProfile = userProfileAsync.value;

      String role = '不安を抱える人々のためのベイビーステップ生成アシスタント';
      String profileContext = '';

      if (userProfile != null) {
        if (userProfile.hasMentalIllness == true) {
          role = '認知行動療法の専門家であり、公認心理師・臨床心理士二つの有資格者です';
          if (userProfile.mentalIllnesses != null &&
              userProfile.mentalIllnesses!.isNotEmpty) {
            role = '${userProfile.mentalIllnesses!.join("、")}の臨床経験が豊富な$role';
          }
        }

        List<String> profileInfo = [];
        profileInfo.add('名前: ${userProfile.userName}');
        if (userProfile.age != null)
          profileInfo.add('年齢: 「${userProfile.age}歳」');
        if (userProfile.gender != null)
          profileInfo.add('性別: 「${userProfile.gender}」');
        if (userProfile.attribute != null)
          profileInfo.add('属性: 「${userProfile.attribute}」');
        if (userProfile.hasMentalIllness != null)
          profileInfo.add(
              '精神疾患の有無: 「${userProfile.hasMentalIllness == true ? "あり" : "なし"}」');
        if (userProfile.mentalIllnesses != null &&
            userProfile.mentalIllnesses!.isNotEmpty)
          profileInfo.add('診断名: 「${userProfile.mentalIllnesses!.join("、")}」');

        profileContext = '\n\nユーザーのプロフィール情報:\n${profileInfo.join("\n")}';
      }

      final summarizedContent = await actionService.summarizeContent(
        content: content,
        role: role,
        profileContext: profileContext,
      );

      final newGoal = Goal(
        id: _uuid.v4(),
        content: summarizedContent,
        originalContent: _contentController.text,
        babySteps: stepsWithOrder,
        displayOrder: userGoals.docs.length + 1,
        isDeleted: false,
        createdBy: FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user',
        createdAt: DateTime.now(),
        updatedBy: FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user',
        updatedAt: DateTime.now(),
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
        // 入力フィールドをクリア（保存完了時のみ）
        _contentController.clear();
        // 事前不安得点入力画面に遷移
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AnxietyScoreInput(
              steps: stepsWithOrder,
              goalId: newGoal.id,
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存エラー: ${e.toString()}')),
        );
        // デバッグ用にコンソール出力
        if (kDebugMode) {
          print('Firestore保存エラー詳細:');
          print('エラータイプ: ${e.runtimeType}');
          print('エラーメッセージ: ${e.toString()}');
          print('スタックトレース: $stackTrace');
          print('入力データ:');
          print('内容: ${_contentController.text}');
          print('ステップ数: ${_steps.length}');
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
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        title: const Text('新しい行動プラン作成'),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: '目標や不安なこと',
                        hintText: '達成したいこと、心配なこと、悩みなどなんでも入力してください',
                        helperText: '例：\n・目標：人前で話せるようになりたい\n・不安：声が震える、頭が真っ白になる',
                        helperMaxLines: 3,
                        hintStyle: const TextStyle(color: Color(0xFF757575)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E3E8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E3E8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 2),
                        ),
                        labelStyle: const TextStyle(color: AppColors.text),
                        floatingLabelStyle:
                            const TextStyle(color: AppColors.text),
                      ),
                      cursorColor: AppColors.primary,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      enableSuggestions: true,
                      autocorrect: true,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isGenerating ? null : _generateStepsWithAI,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isGenerating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'AIに提案を依頼',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    if (_steps.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _clearSteps,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          textStyle: const TextStyle(
                            decoration: TextDecoration.none,
                          ),
                        ),
                        child: const Text('クリア'),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(_steps.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}.',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _steps[index].action,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: 20),
                    if (_steps.isNotEmpty) ...[
                      ElevatedButton(
                        onPressed: _saveSteps,
                        child: const Text('保存して次へ'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
