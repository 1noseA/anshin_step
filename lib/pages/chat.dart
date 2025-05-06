import 'package:flutter/material.dart';
import 'package:anshin_step/models/baby_step.dart';
import 'package:anshin_step/models/goal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final Uuid _uuid = const Uuid();
  final _goalController = TextEditingController();
  final _concernController = TextEditingController();
  List<BabyStep> _steps = [];

  void _generateSteps() {
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

    setState(() {
      _steps.clear();
      _steps = List.generate(
          10,
          (index) => BabyStep(
                id: '${DateTime.now().millisecondsSinceEpoch}_$index',
                action: 'ステップ ${index + 1}: 具体的なアクション内容',
                isDone: false,
                createdBy: 'system',
                createdAt: DateTime.now(),
                updatedBy: 'system',
                updatedAt: DateTime.now(),
              ));
    });
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
        Navigator.pop(context);
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
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _concernController,
              decoration: const InputDecoration(
                labelText: '不安なこと',
                hintText: '心配な点や障害を入力',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            if (_steps.isNotEmpty)
              ..._steps.map((step) => ListTile(
                    title: Text(step.action),
                  )),
          ],
        ),
      ),
      floatingActionButton: _steps.isEmpty
          ? FloatingActionButton(
              onPressed: _generateSteps,
              child: const Icon(Icons.send),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            )
          : null,
      bottomNavigationBar: _steps.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('もう一度生成'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                      ),
                      onPressed: _clearSteps,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('保存する'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _saveSteps,
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
