import 'package:flutter/material.dart';
import 'package:anshin_step/models/baby_step.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anshin_step/pages/step_list.dart';
import 'package:anshin_step/components/colors.dart';
import 'package:flutter/services.dart';
import 'package:anshin_step/pages/main_navigation.dart';

class AnxietyScoreInput extends ConsumerStatefulWidget {
  final List<BabyStep> steps;
  final String goalId;

  const AnxietyScoreInput({
    super.key,
    required this.steps,
    required this.goalId,
  });

  @override
  ConsumerState<AnxietyScoreInput> createState() => _AnxietyScoreInputState();
}

class _AnxietyScoreInputState extends ConsumerState<AnxietyScoreInput> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, int> _scores = {};
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    for (var step in widget.steps) {
      _controllers[step.id] = TextEditingController(
        text: step.beforeAnxietyScore?.toString() ?? '',
      );
      _scores[step.id] = step.beforeAnxietyScore ?? 0;
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveScore() async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final goalRef =
          FirebaseFirestore.instance.collection('goals').doc(widget.goalId);

      for (var step in widget.steps) {
        final text = _controllers[step.id]?.text ?? '';
        final score = text.isEmpty ? null : int.tryParse(text);
        final stepRef = goalRef.collection('babySteps').doc(step.id);

        // 更新データを明示的に設定
        final updateData = {
          'beforeAnxietyScore': score,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user',
          'goalId': widget.goalId, // goalIdも確実に設定
        };

        // デバッグ用に更新データを出力
        print('更新データ: $updateData');

        // updateではなくsetを使用し、merge: trueを指定
        batch.set(stepRef, updateData, SetOptions(merge: true));
      }

      await batch.commit();

      // 更新完了後、一覧画面に戻る前に少し待機
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        // goalsProviderをリフレッシュ
        ref.refresh(goalsProvider);
        // 一覧画面（MainNavigation/StepList）に遷移
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const MainNavigation(initialIndex: 0)),
          (route) => false,
        );
      }
    } catch (e) {
      print('保存エラー: $e'); // デバッグ用にエラーを出力
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存に失敗しました: $e')),
        );
      }
    }
  }

  void _skipInput() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    print(
        'DEBUG: steps.length = \\${widget.steps.length}, _currentIndex = \\$_currentIndex');
    if (widget.steps.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('ベイビーステップがありません')),
      );
    }

    final currentStep = widget.steps[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: SizedBox.shrink(),
        centerTitle: true,
        title: const Text(
          '事前不安得点の入力',
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ステップ ${_currentIndex + 1}: ${currentStep.action}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'このステップを実行する前に、不安の強さを0-100で評価してください',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _controllers[currentStep.id],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '不安得点 (0-100)',
                        hintText: '数値を入力',
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
                      onChanged: (value) {
                        final score = int.tryParse(value) ?? 0;
                        if (score >= 0 && score <= 100) {
                          setState(() {
                            _scores[currentStep.id] = score;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentIndex > 0)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentIndex--;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.primary),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(100, 44)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24)),
                                  ),
                                ),
                                overlayColor: MaterialStateProperty.all(
                                    AppColors.primary.withOpacity(0.8)),
                              ),
                              child: const Text('前へ'),
                            ),
                          if (_currentIndex > 0 &&
                              _currentIndex < widget.steps.length - 1)
                            const SizedBox(width: 16),
                          if (_currentIndex == 0)
                            const SizedBox(width: 80), // 前へボタンがない場合のスペース
                          if (_currentIndex < widget.steps.length - 1)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentIndex++;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.primary),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(100, 44)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24)),
                                  ),
                                ),
                                overlayColor: MaterialStateProperty.all(
                                    AppColors.primary.withOpacity(0.8)),
                              ),
                              child: const Text('次へ'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _skipInput,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        side: BorderSide(color: AppColors.primary, width: 2)),
                  ),
                  child: const Text('スキップ'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveScore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24))),
                  ),
                  child: const Text('保存して完了'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
