import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anshin_step/models/app_user.dart';
import 'package:anshin_step/pages/step_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

final profileProvider =
    StateNotifierProvider.autoDispose<ProfileNotifier, AppUser>(
  (ref) => ProfileNotifier(),
);

class ProfileNotifier extends StateNotifier<AppUser> {
  ProfileNotifier()
      : super(
          AppUser(
            userName: 'ユーザー',
            createdBy: '',
            createdAt: DateTime.now(),
            updatedBy: '',
            updatedAt: DateTime.now(),
          ),
        ) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final userData = AppUser.fromJson(doc.data()!);
        state = userData;
      }
    } catch (e) {
      if (kDebugMode) {
        print('プロフィール読み込みエラー: $e');
      }
    }
  }

  void updateUserName(String value) {
    state = state.copyWith(userName: value);
  }

  void updateAge(String value) {
    state = state.copyWith(age: int.tryParse(value));
  }

  void updateGender(String? value) {
    state = state.copyWith(gender: value);
  }

  void updateAttribute(String value) {
    state = state.copyWith(attribute: value);
  }

  void updateMentalIllness(bool? value) {
    state = state.copyWith(hasMentalIllness: value);
  }

  void updateMentalIllnesses(List<String> values) {
    state = state.copyWith(mentalIllnesses: values);
  }

  Future<void> saveProfile(String userId) async {
    final userData = state.copyWith(
      createdBy: userId,
      updatedBy: userId,
      updatedAt: DateTime.now(),
    );

    // Firestoreに保存
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(userData.toJson());

    state = userData;
  }
}

class Profile extends ConsumerWidget {
  Profile({super.key, this.isNewUser = false});
  final bool isNewUser;
  final _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await ref.read(profileProvider.notifier).saveProfile(user.uid);

      if (isNewUser) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StepList()),
        );
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('プロフィール設定'),
        actions: [
          if (isNewUser)
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StepList()),
                );
              },
              child: const Text('スキップ'),
            ),
          TextButton(
            onPressed: () => _submitForm(context, ref),
            child: const Text('確定'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            color: const Color(0xFFE0E3E8),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      key: ValueKey(state.userName),
                      decoration: const InputDecoration(
                        labelText: 'ニックネーム',
                        hintText: 'ユーザー',
                      ),
                      initialValue: state.userName,
                      onChanged: (value) => ref
                          .read(profileProvider.notifier)
                          .updateUserName(value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ニックネームを入力してください';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: ValueKey(state.age?.toString() ?? ''),
                      decoration: const InputDecoration(
                        labelText: '年齢',
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: state.age?.toString() ?? '',
                      onChanged: (value) =>
                          ref.read(profileProvider.notifier).updateAge(value),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('性別'),
                        RadioListTile<String>(
                          title: const Text('男性'),
                          value: 'male',
                          groupValue: state.gender,
                          onChanged: (value) => ref
                              .read(profileProvider.notifier)
                              .updateGender(value),
                        ),
                        RadioListTile<String>(
                          title: const Text('女性'),
                          value: 'female',
                          groupValue: state.gender,
                          onChanged: (value) => ref
                              .read(profileProvider.notifier)
                              .updateGender(value),
                        ),
                        RadioListTile<String>(
                          title: const Text('その他'),
                          value: 'other',
                          groupValue: state.gender,
                          onChanged: (value) => ref
                              .read(profileProvider.notifier)
                              .updateGender(value),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: '属性',
                      ),
                      initialValue: state.attribute,
                      onChanged: (value) => ref
                          .read(profileProvider.notifier)
                          .updateAttribute(value),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('精神疾患の有無'),
                        RadioListTile<bool>(
                          title: const Text('あり'),
                          value: true,
                          groupValue: state.hasMentalIllness,
                          onChanged: (value) => ref
                              .read(profileProvider.notifier)
                              .updateMentalIllness(value),
                        ),
                        RadioListTile<bool>(
                          title: const Text('なし'),
                          value: false,
                          groupValue: state.hasMentalIllness,
                          onChanged: (value) => ref
                              .read(profileProvider.notifier)
                              .updateMentalIllness(value),
                        ),
                        if (state.hasMentalIllness == true) ...[
                          const SizedBox(height: 16),
                          const Text('診断名（複数選択可）'),
                          ...[
                            '全般性不安障害',
                            'パニック障害',
                            '社交不安障害',
                            '強迫性障害',
                            'PTSD',
                            'うつ病',
                            'その他'
                          ].map((diagnosis) => CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(diagnosis),
                                value: state.mentalIllnesses
                                        ?.contains(diagnosis) ??
                                    false,
                                onChanged: (checked) {
                                  final newList = List<String>.from(
                                      state.mentalIllnesses ?? []);
                                  if (checked == true) {
                                    newList.add(diagnosis);
                                  } else {
                                    newList.remove(diagnosis);
                                  }
                                  ref
                                      .read(profileProvider.notifier)
                                      .updateMentalIllnesses(newList);
                                },
                              )),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
