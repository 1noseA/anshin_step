import 'package:flutter/material.dart';
import 'package:anshin_step/models/baby_step.dart';
import 'package:anshin_step/models/goal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Uuid _uuid = const Uuid();
  final _goalController = TextEditingController();
  final _concernController = TextEditingController();
  List<BabyStep> _steps = [];

  void _generateSteps() {
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
      final newGoal = Goal(
        id: _uuid.v4(),
        goal: _goalController.text,
        anxiety: _concernController.text,
        babySteps: _steps,
        createdBy: FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user',
        createdAt: DateTime.now(),
        updatedBy: FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user',
        updatedAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('goals')
          .doc(newGoal.id)
          .set(newGoal.toJson());

      if (mounted) {
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
