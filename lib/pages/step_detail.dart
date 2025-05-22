import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anshin_step/models/baby_step.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anshin_step/services/comment_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:anshin_step/pages/chat.dart'; // userProfileProvider用
import 'package:anshin_step/models/app_user.dart';
import 'package:flutter/foundation.dart';
import 'package:anshin_step/components/text_styles.dart';

class StepDetail extends ConsumerStatefulWidget {
  final BabyStep step;

  const StepDetail({super.key, required this.step});

  @override
  ConsumerState<StepDetail> createState() => _StepDetailState();
}

class _StepDetailState extends ConsumerState<StepDetail> {
  final _postAnxietyController = TextEditingController();
  final _commentController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false; // ローディング状態を追加
  late BabyStep _currentStep;
  ({bool shouldRecommend, String reason})? _lastRecommendResult;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.step;
    _postAnxietyController.text =
        _currentStep.afterAnxietyScore?.toString() ?? '';
    _commentController.text = _currentStep.comment ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        title: const Text('ステップ詳細'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _isLoading ? null : _saveStep, // ローディング中は無効化
            ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF6F7FB), // 柔らかいグレー背景
        child: Column(
          children: [
            Container(
              height: 1,
              color: const Color(0xFFE0E3E8),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 32.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentStep.action,
                          style: TextStyles.h2,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Text('事前不安得点:', style: TextStyles.body),
                            const SizedBox(width: 8),
                            Text('${_currentStep.beforeAnxietyScore ?? 0}',
                                style: TextStyles.body),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _isEditing
                            ? TextField(
                                controller: _postAnxietyController,
                                decoration: const InputDecoration(
                                  labelText: '事後不安得点',
                                  hintText: '数値を入力',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFE0E3E8)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFE0E3E8)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF3EA8FF), width: 2),
                                  ),
                                  labelStyle:
                                      TextStyle(color: Color(0xFF1A1A1A)),
                                  floatingLabelStyle:
                                      TextStyle(color: Color(0xFF1A1A1A)),
                                ),
                                keyboardType: TextInputType.number,
                              )
                            : Row(
                                children: [
                                  const Text('事後不安得点:', style: TextStyles.body),
                                  const SizedBox(width: 8),
                                  Text('${_currentStep.afterAnxietyScore ?? 0}',
                                      style: TextStyles.body),
                                ],
                              ),
                        const SizedBox(height: 16),
                        _isEditing
                            ? TextField(
                                controller: _commentController,
                                decoration: const InputDecoration(
                                  labelText: 'コメント',
                                  hintText: '感想や気付きを入力',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFE0E3E8)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFE0E3E8)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF3EA8FF), width: 2),
                                  ),
                                  labelStyle:
                                      TextStyle(color: Color(0xFF1A1A1A)),
                                  floatingLabelStyle:
                                      TextStyle(color: Color(0xFF1A1A1A)),
                                ),
                                maxLines: 3,
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('コメント:', style: TextStyles.body),
                                  const SizedBox(height: 4),
                                  Text(
                                    _currentStep.comment ?? 'コメントはありません',
                                    style: TextStyles.body,
                                  ),
                                ],
                              ),
                        const SizedBox(height: 32),
                        if (_isEditing)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveStep,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: const Color(0xFF3EA8FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      '保存',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveStep() async {
    try {
      setState(() {
        _isLoading = true; // ローディング開始
      });

      final postAnxiety = int.tryParse(_postAnxietyController.text) ?? 0;
      final comment = _commentController.text;

      // デバッグ情報の出力
      print('入力値の確認:');
      print('事後不安得点: $postAnxiety');
      print('コメント: $comment');
      print('現在のステップID: ${_currentStep.id}');
      print('ゴールID: ${_currentStep.goalId}');

      // 親ドキュメントの参照を取得
      final parentRef = FirebaseFirestore.instance
          .collection('goals')
          .doc(_currentStep.goalId ?? '');

      // サブコレクションに保存
      final stepData = {
        'action': _currentStep.action,
        'beforeAnxietyScore': _currentStep.beforeAnxietyScore,
        'afterAnxietyScore': postAnxiety,
        'comment': comment,
        'isDone': _currentStep.isDone,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user',
        'goalId': _currentStep.goalId,
        'displayOrder': _currentStep.displayOrder,
        'isDeleted': _currentStep.isDeleted,
        'createdBy': _currentStep.createdBy,
        'createdAt': _currentStep.createdAt,
      };

      print('保存するデータ:');
      print(stepData);

      // 保存前のデータを確認
      final beforeDoc =
          await parentRef.collection('babySteps').doc(_currentStep.id).get();
      print('保存前のデータ:');
      print(beforeDoc.data());

      await parentRef
          .collection('babySteps')
          .doc(_currentStep.id)
          .set(stepData);

      // 保存後のデータを確認
      final afterDoc =
          await parentRef.collection('babySteps').doc(_currentStep.id).get();
      print('保存後のデータ:');
      print(afterDoc.data());

      // AIコメント生成処理
      String profileContext = '';
      bool isProfileReady = false;
      int retryCount = 0;
      const maxRetries = 5; // 最大リトライ回数

      // プロフィール情報の取得を待機
      while (!isProfileReady && retryCount < maxRetries) {
        final userProfileAsync = ref.read(userProfileProvider);
        if (userProfileAsync is AsyncData<AppUser?> &&
            userProfileAsync.value != null) {
          final userProfile = userProfileAsync.value;
          if (userProfile != null) {
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
              profileInfo
                  .add('診断名: 「${userProfile.mentalIllnesses!.join("、")}」');
            profileContext = '\n\nユーザーのプロフィール情報:\n${profileInfo.join("\n")}';
            isProfileReady = true;
          }
        }

        if (!isProfileReady) {
          retryCount++;
          if (retryCount < maxRetries) {
            await Future.delayed(const Duration(milliseconds: 500)); // 0.5秒待機
          }
        }
      }

      if (!isProfileReady) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('プロフィール情報の取得に失敗しました')),
          );
        }
        return;
      }

      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      final commentService = CommentService(apiKey);
      String aiComment = '';
      try {
        aiComment = await commentService.generateComment(
          profileContext: profileContext,
          action: _currentStep.action,
          beforeAnxietyScore:
              _currentStep.beforeAnxietyScore?.toString() ?? '未入力',
          afterAnxietyScore: postAnxiety.toString(),
          userComment: comment,
        );
      } catch (e) {
        aiComment = 'AIコメントの生成に失敗しました。';
      }

      // ★ここで専門家受診レコメンド判定を実施
      try {
        _lastRecommendResult = await commentService.checkRecommendConsultation(
          profileContext: profileContext,
          action: _currentStep.action,
          beforeAnxietyScore:
              _currentStep.beforeAnxietyScore?.toString() ?? '未入力',
          afterAnxietyScore: postAnxiety.toString(),
          userComment: comment,
        );
      } catch (e) {
        if (kDebugMode) {
          print('専門家受診レコメンド判定エラー: $e');
        }
        _lastRecommendResult = null;
      }

      if (mounted) {
        // まずAIコメントダイアログを表示
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('あなたへのメッセージ'),
            content: Text(aiComment),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('閉じる'),
              ),
            ],
          ),
        );

        // _lastRecommendResultをローカル変数に退避してからnullにリセット
        final recommendResult = _lastRecommendResult;
        _lastRecommendResult = null;
        if (recommendResult != null && recommendResult.shouldRecommend) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('サポートのご案内',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              content: const Text(
                  'あなたの状態について、専門家（精神科・カウンセリング等）への相談を強くおすすめします。\nオンラインで相談できるサービスもあります。'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('閉じる'),
                ),
              ],
            ),
          );
        }

        // 更新後のデータを画面に反映
        setState(() {
          _currentStep = _currentStep.copyWith(
            afterAnxietyScore: postAnxiety,
            comment: comment,
          );
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('更新が完了しました')),
        );
      }
    } catch (e) {
      print('エラーが発生しました:');
      print(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('更新に失敗しました: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // ローディング終了
        });
      }
    }
  }
}
