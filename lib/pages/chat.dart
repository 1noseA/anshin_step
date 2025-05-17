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
import 'package:anshin_step/constants/action_suggestion_prompts.dart';

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
  final _goalController = TextEditingController();
  final _concernController = TextEditingController();
  List<BabyStep> _steps = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _goalController.dispose();
    _concernController.dispose();
    super.dispose();
  }

  /// AIを使用してベイビーステップを生成する
  Future<void> _generateStepsWithAI() async {
    final goal = _goalController.text.trim();
    final anxiety = _concernController.text.trim();

    if (goal.isEmpty || anxiety.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('やりたいことと不安なことを入力してください')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _steps.clear();
    });

    try {
      // .envからAPI Keyを取得
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        throw Exception('API Keyが設定されていません');
      }

      // プロフィール情報を取得
      final userProfileAsync = ref.watch(userProfileProvider);
      final isProfileReady = userProfileAsync is AsyncData<AppUser?> &&
          userProfileAsync.value != null;
      String role = '不安を抱える人々のためのベイビーステップ生成アシスタント';
      String profileContext = '';

      // プロフィール情報が取得できていない場合はAIリクエストを中断
      if (!isProfileReady) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('プロフィール情報の取得中です。しばらくお待ちください')),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final userProfile = userProfileAsync.value;
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
      } else {
        if (kDebugMode) {
          print('プロフィール情報がnullでした。');
        }
      }

      final actionService = ActionSuggestionService(apiKey);
      final aiSteps = await actionService.generateBabySteps(
        goal: goal,
        anxiety: anxiety,
        role: role,
        profileContext: profileContext,
      );

      if (kDebugMode) {
        print('\n=== 生成されたベイビーステップ ===');
        for (var i = 0; i < aiSteps.length; i++) {
          print('${i + 1}. ${aiSteps[i]}');
        }
        print('==============================\n');
      }

      setState(() {
        _steps = List.generate(
            aiSteps.length,
            (index) => BabyStep(
                  id: '${DateTime.now().millisecondsSinceEpoch}_$index',
                  action: aiSteps[index],
                  isDone: false,
                  createdBy: 'system',
                  createdAt: DateTime.now(),
                  updatedBy: 'system',
                  updatedAt: DateTime.now(),
                ));
      });
    } catch (e) {
      print('エラー詳細: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('AI提案エラー: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
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

      final goal = _goalController.text.trim();
      final anxiety = _concernController.text.trim();

      if (goal.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('やりたいことを入力してください')),
        );
        return;
      }

      if (anxiety.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('不安なことを入力してください')),
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

      final newGoal = Goal(
        id: _uuid.v4(),
        goal: goal,
        anxiety: anxiety,
        babySteps: stepsWithOrder,
        displayOrder: userGoals.docs.length + 1, // 既存のGoal数 + 1
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
          print('目標: ${_goalController.text}');
          print('不安: ${_concernController.text}');
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
        title: const Text('新しい行動プラン作成'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _goalController,
              decoration: const InputDecoration(
                labelText: 'やりたいこと',
                hintText: '達成したい目標を入力',
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              enableSuggestions: true,
              autocorrect: true,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _concernController,
              decoration: const InputDecoration(
                labelText: '不安なこと',
                hintText: '心配な点や障害を入力',
              ),
              maxLines: 3,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              enableSuggestions: true,
              autocorrect: true,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isLoading || !isProfileReady
                      ? null
                      : _generateStepsWithAI,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('AIに提案を依頼'),
                ),
                if (_steps.isNotEmpty)
                  TextButton(
                    onPressed: _clearSteps,
                    child: const Text('クリア'),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (_steps.isNotEmpty) ...[
              const Text(
                '生成されたベイビーステップ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ..._steps.map((step) => ListTile(
                    title: Text(step.action),
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSteps,
                child: const Text('保存して次へ'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
