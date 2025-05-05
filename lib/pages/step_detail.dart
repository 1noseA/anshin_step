import 'package:flutter/material.dart';
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
          ],
        ),
      ),
    );
  }

  void _saveStep() {
    // TODO: Firestoreに保存する処理を実装
    Navigator.pop(context);
  }
}
