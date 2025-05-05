import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anshin_step/models/baby_step.dart';

class StepDetail extends StatefulWidget {
  final BabyStep step;

  const StepDetail({super.key, required this.step});

  @override
  State<StepDetail> createState() => _StepDetailState();
}

class _StepDetailState extends State<StepDetail> {
  final _postAnxietyController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _postAnxietyController.text =
        widget.step.afterAnxietyScore?.toString() ?? '';
    _commentController.text = widget.step.comment ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ステップ詳細'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveStep,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.step.action,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('事前不安得点: '),
                Text('${widget.step.beforeAnxietyScore ?? 0}'),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _postAnxietyController,
              decoration: const InputDecoration(
                labelText: '事後不安得点',
                hintText: '数値を入力',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'コメント',
                hintText: '感想や気付きを入力',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveStep,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  '保存',
                  style: TextStyle(color: Colors.white, fontSize: 16),
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
      final postAnxiety = int.tryParse(_postAnxietyController.text) ?? 0;
      final comment = _commentController.text;

      // 親ドキュメントの参照を取得
      final parentRef = FirebaseFirestore.instance
          .collection('goals')
          .doc(widget.step.goalId ?? '');

      // サブコレクションに保存
      await parentRef.collection('babySteps').doc(widget.step.id).set({
        'action': widget.step.action,
        'beforeAnxietyScore': widget.step.beforeAnxietyScore,
        'afterAnxietyScore': postAnxiety,
        'comment': comment,
        'isDone': widget.step.isDone,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user'
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('更新が完了しました')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('更新に失敗しました: ${e.toString()}')),
        );
      }
    }
  }
}
