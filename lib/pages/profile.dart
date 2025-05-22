import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anshin_step/models/app_user.dart';
import 'package:anshin_step/pages/step_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:anshin_step/components/colors.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

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

class Profile extends ConsumerStatefulWidget {
  Profile({super.key, this.isNewUser = false});
  final bool isNewUser;
  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _userNameController;
  late final TextEditingController _ageController;
  late final TextEditingController _attributeController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(profileProvider);
    _userNameController = TextEditingController(text: state.userName);
    _ageController = TextEditingController(text: state.age?.toString() ?? '');
    _attributeController = TextEditingController(text: state.attribute ?? '');
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _ageController.dispose();
    _attributeController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await ref.read(profileProvider.notifier).saveProfile(user.uid);

      if (widget.isNewUser) {
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
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    ref.listen<AppUser>(profileProvider, (prev, next) {
      if (_userNameController.text != next.userName) {
        _userNameController.text = next.userName ?? '';
      }
      final ageStr = next.age?.toString() ?? '';
      if (_ageController.text != ageStr) {
        _ageController.text = ageStr;
      }
      if (_attributeController.text != (next.attribute ?? '')) {
        _attributeController.text = next.attribute ?? '';
      }
    });
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
        title: const Text('プロフィール設定'),
        actions: [
          if (widget.isNewUser)
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StepList()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: const TextStyle(
                  decoration: TextDecoration.none,
                ),
              ),
              child: const Text('スキップ'),
            ),
        ],
      ),
      body: Container(
        color: AppColors.background,
        child: Column(
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
                      // ニックネーム
                      TextFormField(
                        controller: _userNameController,
                        decoration: InputDecoration(
                          labelText: 'ニックネーム',
                          hintText: 'ユーザー',
                          hintStyle: const TextStyle(color: Color(0xFF757575)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E3E8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E3E8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xFF3EA8FF), width: 2),
                          ),
                          labelStyle: const TextStyle(color: AppColors.text),
                          floatingLabelStyle:
                              const TextStyle(color: AppColors.text),
                        ),
                        cursorColor: const Color(0xFF3EA8FF),
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
                      // 年齢
                      TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          labelText: '年齢',
                          hintText: '',
                          hintStyle: const TextStyle(color: Color(0xFF757575)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E3E8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E3E8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xFF3EA8FF), width: 2),
                          ),
                          labelStyle: const TextStyle(color: AppColors.text),
                          floatingLabelStyle:
                              const TextStyle(color: AppColors.text),
                        ),
                        cursorColor: const Color(0xFF3EA8FF),
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                            ref.read(profileProvider.notifier).updateAge(value),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('性別',
                              style: TextStyle(color: AppColors.text)),
                          RadioListTile<String>(
                            title: const Text('男性',
                                style: TextStyle(color: AppColors.text)),
                            value: 'male',
                            groupValue: state.gender,
                            onChanged: (value) => ref
                                .read(profileProvider.notifier)
                                .updateGender(value),
                            activeColor: AppColors.primary,
                            selectedTileColor: Color(0xFFEAF6FF),
                          ),
                          RadioListTile<String>(
                            title: const Text('女性',
                                style: TextStyle(color: AppColors.text)),
                            value: 'female',
                            groupValue: state.gender,
                            onChanged: (value) => ref
                                .read(profileProvider.notifier)
                                .updateGender(value),
                            activeColor: AppColors.primary,
                            selectedTileColor: Color(0xFFEAF6FF),
                          ),
                          RadioListTile<String>(
                            title: const Text('その他',
                                style: TextStyle(color: AppColors.text)),
                            value: 'other',
                            groupValue: state.gender,
                            onChanged: (value) => ref
                                .read(profileProvider.notifier)
                                .updateGender(value),
                            activeColor: AppColors.primary,
                            selectedTileColor: Color(0xFFEAF6FF),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // 属性
                      TextFormField(
                        controller: _attributeController,
                        decoration: InputDecoration(
                          labelText: '属性',
                          hintText: '',
                          hintStyle: const TextStyle(color: Color(0xFF757575)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E3E8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E3E8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xFF3EA8FF), width: 2),
                          ),
                          labelStyle: const TextStyle(color: AppColors.text),
                          floatingLabelStyle:
                              const TextStyle(color: AppColors.text),
                        ),
                        cursorColor: const Color(0xFF3EA8FF),
                        onChanged: (value) => ref
                            .read(profileProvider.notifier)
                            .updateAttribute(value),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('精神疾患の有無',
                              style: TextStyle(color: AppColors.text)),
                          RadioListTile<bool>(
                            title: const Text('あり',
                                style: TextStyle(color: AppColors.text)),
                            value: true,
                            groupValue: state.hasMentalIllness,
                            onChanged: (value) => ref
                                .read(profileProvider.notifier)
                                .updateMentalIllness(value),
                            activeColor: AppColors.primary,
                            selectedTileColor: Color(0xFFEAF6FF),
                          ),
                          RadioListTile<bool>(
                            title: const Text('なし',
                                style: TextStyle(color: AppColors.text)),
                            value: false,
                            groupValue: state.hasMentalIllness,
                            onChanged: (value) => ref
                                .read(profileProvider.notifier)
                                .updateMentalIllness(value),
                            activeColor: AppColors.primary,
                            selectedTileColor: Color(0xFFEAF6FF),
                          ),
                          if (state.hasMentalIllness == true) ...[
                            const SizedBox(height: 16),
                            const Text('診断名（複数選択可）',
                                style: TextStyle(color: AppColors.text)),
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
                                  title: Text(diagnosis,
                                      style: const TextStyle(
                                          color: AppColors.text)),
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
                                  activeColor: AppColors.primary,
                                  checkColor: Colors.white,
                                  tileColor: (state.mentalIllnesses
                                              ?.contains(diagnosis) ??
                                          false)
                                      ? Color(0xFFEAF6FF)
                                      : null,
                                  side: const BorderSide(
                                      color: AppColors.text, width: 2),
                                )),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _submitForm(context, ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '保存',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
