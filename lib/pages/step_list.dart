import 'package:flutter/material.dart';
import 'package:anshin_step/pages/chat.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anshin_step/models/goal.dart';
import 'package:anshin_step/models/baby_step.dart';
import 'package:anshin_step/pages/step_detail.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:anshin_step/components/colors.dart';
import 'package:anshin_step/components/text_styles.dart';
import 'package:anshin_step/services/report_service.dart';
import 'package:anshin_step/pages/main_navigation.dart';

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

// レポートサービスのProvider
final reportServiceProvider = Provider((ref) => ReportService());

class StepList extends ConsumerWidget {
  const StepList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud, color: Color(0xFF5bc2dc)),
            const SizedBox(width: 4),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'Varela Round',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5bc2dc),
                  letterSpacing: 1.2,
                ),
                children: [
                  TextSpan(
                    text: 'S',
                    style: const TextStyle(
                      fontFamily: 'Varela Round',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5bc2dc),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const TextSpan(
                    text: 'tepumo',
                    style: TextStyle(
                      fontFamily: 'Varela Round',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _showMenuDialog(context),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              height: 1,
              color: const Color(0xFFE0E3E8),
            ),
            Expanded(
              child: SafeArea(
                child: Consumer(
                  builder: (context, ref, child) {
                    final goalsAsync = ref.watch(goalsProvider);
                    final updatedBabySteps = ref.watch(updatedBabyStepProvider);

                    return goalsAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) =>
                          Center(child: Text('エラーが発生しました: $error')),
                      data: (goals) {
                        if (goals.isEmpty) {
                          return const Center(
                            child: Text('まずは右下の「＋」ボタンから行動プランを追加してください'),
                          );
                        }
                        return ListView.builder(
                          itemCount: goals.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return const SizedBox(height: 16);
                            }
                            final goal = goals[index - 1];
                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              clipBehavior: Clip.antiAlias,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme:
                                      Theme.of(context).colorScheme.copyWith(
                                            outlineVariant: Colors.transparent,
                                          ),
                                ),
                                child: ExpansionTile(
                                  title: Text(
                                    goal.content.split('\\n')[0],
                                    style: TextStyles.h3,
                                  ),
                                  subtitle: Text(
                                    goal.content.split('\\n').length > 1
                                        ? goal.content.split('\\n')[1]
                                        : '',
                                    style: TextStyles.body.copyWith(
                                      color: AppColors.text.withOpacity(0.7),
                                    ),
                                  ),
                                  iconColor: AppColors.text,
                                  collapsedIconColor: AppColors.text,
                                  childrenPadding: EdgeInsets.zero,
                                  children: [
                                    const Divider(
                                        height: 0,
                                        thickness: 0,
                                        color: Colors.transparent),
                                    if (goal.babySteps != null &&
                                        goal.babySteps!.isNotEmpty)
                                      ...(() {
                                        final sortedSteps = [
                                          ...goal.babySteps!
                                        ];
                                        sortedSteps.sort((a, b) =>
                                            (a.displayOrder ?? 0).compareTo(
                                                b.displayOrder ?? 0));
                                        return sortedSteps.asMap().entries;
                                      })()
                                          .map((entry) {
                                        final step = entry.value;
                                        final updatedStep =
                                            updatedBabySteps[step.id];
                                        final displayStep = updatedStep ?? step;
                                        final isLast = entry.key ==
                                            goal.babySteps!.length - 1;
                                        return Column(
                                          children: [
                                            IntrinsicHeight(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  SizedBox(
                                                    width: 32,
                                                    child: Stack(
                                                      children: [
                                                        if (!isLast)
                                                          Positioned(
                                                            left: 14,
                                                            top: 24,
                                                            bottom: -24,
                                                            child: Container(
                                                              width: 2,
                                                              color: AppColors
                                                                  .primary
                                                                  .withOpacity(
                                                                      0.3),
                                                            ),
                                                          ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topCenter,
                                                          child: Container(
                                                            width: 24,
                                                            height: 24,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border: Border.all(
                                                                  color: AppColors
                                                                      .primary,
                                                                  width: 2),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Text(
                                                              '${displayStep.displayOrder ?? entry.key + 1}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .primary,
                                                                fontSize: 16,
                                                                height: 1.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () =>
                                                          _navigateToStepDetail(
                                                              context,
                                                              displayStep,
                                                              ref),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                displayStep
                                                                    .action
                                                                    .replaceAll(
                                                                        RegExp(
                                                                            r'（[^）]*）|\([^\)]*\)'),
                                                                        '')
                                                                    .trim(),
                                                                style: TextStyles
                                                                    .body
                                                                    .copyWith(
                                                                        height:
                                                                            1.2),
                                                              ),
                                                            ),
                                                            Checkbox(
                                                              value: displayStep
                                                                      .isDone ??
                                                                  false,
                                                              activeColor:
                                                                  AppColors
                                                                      .primary,
                                                              side: const BorderSide(
                                                                  color:
                                                                      AppColors
                                                                          .text,
                                                                  width: 2),
                                                              onChanged:
                                                                  (checked) async {
                                                                final user =
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser;
                                                                if (user ==
                                                                    null)
                                                                  return;
                                                                final newIsDone =
                                                                    checked ??
                                                                        false;
                                                                final newExecutionDate =
                                                                    newIsDone
                                                                        ? DateTime
                                                                            .now()
                                                                        : null;
                                                                final firestore =
                                                                    FirebaseFirestore
                                                                        .instance;
                                                                if (displayStep
                                                                        .goalId ==
                                                                    null)
                                                                  return;
                                                                final stepRef = firestore
                                                                    .collection(
                                                                        'goals')
                                                                    .doc(displayStep
                                                                        .goalId)
                                                                    .collection(
                                                                        'babySteps')
                                                                    .doc(displayStep
                                                                        .id);
                                                                await stepRef
                                                                    .update({
                                                                  'isDone':
                                                                      newIsDone,
                                                                  'executionDate':
                                                                      newExecutionDate,
                                                                  'updatedBy':
                                                                      user.uid,
                                                                  'updatedAt':
                                                                      DateTime
                                                                          .now(),
                                                                });
                                                                final updatedStep =
                                                                    displayStep
                                                                        .copyWith(
                                                                  isDone:
                                                                      newIsDone,
                                                                  executionDate:
                                                                      newExecutionDate,
                                                                  updatedBy:
                                                                      user.uid,
                                                                  updatedAt:
                                                                      DateTime
                                                                          .now(),
                                                                );
                                                                final updatedMap = Map<
                                                                        String,
                                                                        BabyStep>.from(
                                                                    updatedBabySteps);
                                                                updatedMap[
                                                                        displayStep
                                                                            .id] =
                                                                    updatedStep;
                                                                ref
                                                                    .read(updatedBabyStepProvider
                                                                        .notifier)
                                                                    .state = updatedMap;

                                                                // レポートを生成
                                                                await ref
                                                                    .read(
                                                                        reportServiceProvider)
                                                                    .generateReport(
                                                                        user.uid);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if ((entry.key == 9))
                                              const SizedBox(height: 16),
                                          ],
                                        );
                                      }),
                                    if (goal.babySteps == null ||
                                        goal.babySteps!.isEmpty)
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text('ベイビーステップが設定されていません'),
                                      ),
                                    const Divider(
                                        height: 0,
                                        thickness: 0,
                                        color: Colors.transparent),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MainNavigation(initialIndex: 1)),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('メニュー', style: TextStyle(color: AppColors.text)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('プロフィール設定'),
              textColor: AppColors.text,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('利用規約'),
              textColor: AppColors.text,
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('プライバシーポリシー'),
              textColor: AppColors.text,
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.contact_support),
              title: const Text('お問い合わせ'),
              textColor: AppColors.text,
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('ログアウト'),
              textColor: AppColors.text,
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
