import 'package:flutter/material.dart';
import 'package:anshin_step/models/baby_step.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _goalController = TextEditingController();
  final _concernController = TextEditingController();
  List<BabyStep> _steps = [];

  void _generateSteps() {
    // 仮のハードコードされたベイビーステップ
    setState(() {
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

  void _saveSteps() {
    // TODO: 保存処理実装
    Navigator.pop(context);
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
      floatingActionButton: FloatingActionButton(
        onPressed: _generateSteps,
        child: const Icon(Icons.send),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }
}
