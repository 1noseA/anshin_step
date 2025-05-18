import 'package:flutter/material.dart';
import 'package:anshin_step/pages/chat.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anshin_step/models/goal.dart';
import 'package:anshin_step/models/baby_step.dart';
import 'package:anshin_step/pages/step_detail.dart';

final goalsProvider = StreamProvider<List<Goal>>((ref) {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value([]);
  }

  return firestore
      .collection('goals')
      .where('created_by', isEqualTo: user.uid)
      .where('isDeleted', isEqualTo: false)
      .snapshots()
      .asyncMap((snapshot) async {
    final goals = await Future.wait(
      snapshot.docs.map((doc) async {
        final goalData = doc.data();
        goalData['id'] = doc.id;

        // サブコレクションからbabyStepsを取得
        final babyStepsSnapshot = await doc.reference
            .collection('babySteps')
            .where('isDeleted', isEqualTo: false)
            .get();
        final babyStepsData = babyStepsSnapshot.docs.map((stepDoc) {
          final stepData = stepDoc.data();
          stepData['id'] = stepDoc.id;
          return stepData;
        }).toList();

        goalData['babySteps'] = babyStepsData;
        return Goal.fromJson(goalData);
      }),
    );
    // createdAtの降順でソート
    goals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    // 将来的にdisplayOrderによる並び替えが必要な場合のためのコード
    // goals.sort((a, b) => (a.displayOrder ?? 0).compareTo(b.displayOrder ?? 0));
    return goals;
  });
});

// 更新されたBabyStepを保持するProvider
final updatedBabyStepProvider =
    StateProvider<Map<String, BabyStep>>((ref) => {});

class StepList extends ConsumerWidget {
  const StepList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メイン画面'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _showMenuDialog(context),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final goalsAsync = ref.watch(goalsProvider);
          final updatedBabySteps = ref.watch(updatedBabyStepProvider);

          return goalsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('エラーが発生しました: $error')),
            data: (goals) {
              if (goals.isEmpty) {
                return const Center(
                  child: Text('まずは右下の「＋」ボタンから行動プランを追加してください'),
                );
              }
              return ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ExpansionTile(
                      title: Text(goal.goal),
                      subtitle: Text(goal.anxiety),
                      children: [
                        if (goal.babySteps != null &&
                            goal.babySteps!.isNotEmpty)
                          ...goal.babySteps!.map((step) {
                            // 更新された値がある場合はそれを使用
                            final updatedStep = updatedBabySteps[step.id];
                            final displayStep = updatedStep ?? step;
                            return InkWell(
                              onTap: () => _navigateToStepDetail(
                                  context, displayStep, ref),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: displayStep.isDone ?? false,
                                    onChanged: null,
                                  ),
                                  Expanded(
                                    child: Text(displayStep.action),
                                  ),
                                  SizedBox(
                                    width: 48, // 2桁+余白程度の幅
                                    child: Text(
                                      displayStep.beforeAnxietyScore == null
                                          ? '   '
                                          : displayStep.beforeAnxietyScore
                                              .toString(),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        if (goal.babySteps == null || goal.babySteps!.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('ベイビーステップが設定されていません'),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Chat()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('メニュー'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('プロフィール設定'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('利用規約'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('プライバシーポリシー'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.contact_support),
              title: const Text('お問い合わせ'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('ログアウト'),
              onTap: () => _handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    final auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  void _navigateToStepDetail(
      BuildContext context, BabyStep step, WidgetRef ref) {
    // Firestoreから最新データを取得
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // まずgoalを取得
    firestore
        .collection('goals')
        .where('created_by', isEqualTo: user.uid)
        .where('isDeleted', isEqualTo: false)
        .get()
        .then((goalsSnapshot) {
      for (var goalDoc in goalsSnapshot.docs) {
        // 各goalのbabyStepsサブコレクションを確認
        goalDoc.reference
            .collection('babySteps')
            .doc(step.id)
            .get()
            .then((stepDoc) {
          if (stepDoc.exists) {
            final latestData = stepDoc.data();
            latestData!['id'] = stepDoc.id;
            final latestStep = BabyStep.fromJson(latestData);

            // 最新データで詳細画面を表示
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StepDetail(step: latestStep),
              ),
            ).then((updatedStep) {
              if (updatedStep != null && updatedStep is BabyStep) {
                // 一覧画面を再描画
                ref.refresh(goalsProvider);
              }
            });
            return; // 見つかったら処理を終了
          }
        });
      }
    }).catchError((error) {
      print('データ取得エラー: $error');
    });
  }
}
