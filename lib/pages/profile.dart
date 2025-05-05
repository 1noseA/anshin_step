import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anshin_step/models/app_user.dart';
import 'package:anshin_step/pages/step_list.dart';

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
        );

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
    // TODO: Firestoreに保存
    state = state.copyWith(
      updatedBy: userId,
      updatedAt: DateTime.now(),
    );
  }
}

class Profile extends ConsumerWidget {
  Profile({super.key, this.isNewUser = false});
  final bool isNewUser;
  final _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, WidgetRef ref) {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(profileProvider.notifier).saveProfile('current_user_id');
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
        title: const Text('プロフィール設定'),
        actions: [
          TextButton(
            onPressed: () {
              if (isNewUser) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StepList()),
                );
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text('スキップ'),
          ),
          TextButton(
            onPressed: () => _submitForm(context, ref),
            child: const Text('確定'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'ニックネーム',
                hintText: 'ユーザー',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '年齢',
              ),
              keyboardType: TextInputType.number,
              initialValue: state.age?.toString(),
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
                  onChanged: (value) =>
                      ref.read(profileProvider.notifier).updateGender(value),
                ),
                RadioListTile<String>(
                  title: const Text('女性'),
                  value: 'female',
                  groupValue: state.gender,
                  onChanged: (value) =>
                      ref.read(profileProvider.notifier).updateGender(value),
                ),
                RadioListTile<String>(
                  title: const Text('その他'),
                  value: 'other',
                  groupValue: state.gender,
                  onChanged: (value) =>
                      ref.read(profileProvider.notifier).updateGender(value),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '属性',
              ),
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
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(diagnosis),
                        value:
                            state.mentalIllnesses?.contains(diagnosis) ?? false,
                        onChanged: (checked) {
                          final newList =
                              List<String>.from(state.mentalIllnesses ?? []);
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
    );
  }
}
