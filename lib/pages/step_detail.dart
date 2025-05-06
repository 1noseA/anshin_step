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
  bool _isEditing = false;
  late BabyStep _currentStep;

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
              onPressed: _saveStep,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(_currentStep.action,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('事前不安得点: '),
                Text('${_currentStep.beforeAnxietyScore ?? 0}'),
              ],
            ),
            const SizedBox(height: 20),
            _isEditing
                ? TextField(
                    controller: _postAnxietyController,
                    decoration: const InputDecoration(
                      labelText: '事後不安得点',
                      hintText: '数値を入力',
                    ),
                    keyboardType: TextInputType.number,
                  )
                : Row(
                    children: [
                      const Text('事後不安得点: '),
                      Text('${_currentStep.afterAnxietyScore ?? 0}'),
                    ],
                  ),
            const SizedBox(height: 20),
            _isEditing
                ? TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'コメント',
                      hintText: '感想や気付きを入力',
                    ),
                    maxLines: 3,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('コメント:'),
                      Text(_currentStep.comment ?? 'コメントはありません'),
                    ],
                  ),
            const SizedBox(height: 30),
            if (_isEditing)
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

      if (mounted) {
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
    }
  }
}
