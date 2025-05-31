import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anshin_step/models/baby_step.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anshin_step/services/comment_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:anshin_step/pages/chat.dart'; // userProfileProvider用
import 'package:anshin_step/models/app_user.dart';
import 'package:flutter/foundation.dart';
import 'package:anshin_step/components/text_styles.dart';
import 'package:anshin_step/components/colors.dart';

class StepDetail extends ConsumerStatefulWidget {
  final BabyStep step;

  const StepDetail({super.key, required this.step});

  @override
  ConsumerState<StepDetail> createState() => _StepDetailState();
}

class _StepDetailState extends ConsumerState<StepDetail> {
  final _postAnxietyController = TextEditingController();
  final _impressionController = TextEditingController();
  final _achievementScoreController = TextEditingController();
  final _physicalDataController = TextEditingController();
  final _wordController = TextEditingController();
  final _copingMethodController = TextEditingController();
  final _preAnxietyController = TextEditingController();
  DateTime? _executionDate;
  bool _isEditing = false;
  bool _isLoading = false;
  late BabyStep _currentStep;
  ({bool shouldRecommend, String reason})? _lastRecommendResult;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.step;
    _preAnxietyController.text =
        _currentStep.beforeAnxietyScore?.toString() ?? '';
    _postAnxietyController.text =
        _currentStep.afterAnxietyScore?.toString() ?? '';
    _impressionController.text = _currentStep.impression ?? '';
    _achievementScoreController.text =
        _currentStep.achievementScore?.toString() ?? '';
    _physicalDataController.text = _currentStep.physicalData ?? '';
    _wordController.text = _currentStep.word ?? '';
    _copingMethodController.text = _currentStep.copingMethod ?? '';
    _executionDate = _currentStep.executionDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        title: const Text('ステップ詳細'),
        actions: [],
      ),
      body: Container(
        color: const Color(0xFFF6F7FB),
        child: Column(
          children: [
            Container(
              height: 1,
              color: const Color(0xFFE0E3E8),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 32.0),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 丸数字を上中央、その下にステップ内容を中央揃えで表示
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: AppColors.primary, width: 2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    (_currentStep.displayOrder ?? 1).toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontSize: 18,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _currentStep.action,
                                  style: TextStyles.h2.copyWith(height: 1.4),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            _isEditing
                                ? TextField(
                                    controller: _preAnxietyController,
                                    decoration: const InputDecoration(
                                      labelText: '事前不安得点',
                                      hintText: '数値を入力',
                                      hintStyle:
                                          TextStyle(color: Color(0xFF757575)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        borderSide: BorderSide(
                                            color: Color(0xFFE0E3E8)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        borderSide: BorderSide(
                                            color: Color(0xFFE0E3E8)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        borderSide: BorderSide(
                                            color: AppColors.primary, width: 2),
                                      ),
                                      labelStyle:
                                          TextStyle(color: AppColors.text),
                                      floatingLabelStyle:
                                          TextStyle(color: AppColors.text),
                                    ),
                                    keyboardType: TextInputType.number,
                                  )
                                : _buildModernDetailRow(
                                    Icons.sentiment_satisfied,
                                    '事前不安得点',
                                    _currentStep.beforeAnxietyScore
                                        ?.toString()),
                            _isEditing
                                ? TextField(
                                    controller: _postAnxietyController,
                                    decoration: const InputDecoration(
                                      labelText: '事後不安得点',
                                      hintText: '数値を入力',
                                      hintStyle:
                                          TextStyle(color: Color(0xFF757575)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        borderSide: BorderSide(
                                            color: Color(0xFFE0E3E8)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        borderSide: BorderSide(
                                            color: Color(0xFFE0E3E8)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        borderSide: BorderSide(
                                            color: AppColors.primary, width: 2),
                                      ),
                                      labelStyle:
                                          TextStyle(color: AppColors.text),
                                      floatingLabelStyle:
                                          TextStyle(color: AppColors.text),
                                    ),
                                    keyboardType: TextInputType.number,
                                  )
                                : _buildModernDetailRow(
                                    Icons.sentiment_very_satisfied,
                                    '事後不安得点',
                                    _currentStep.afterAnxietyScore?.toString()),
                            if (_isEditing) ...[
                              // 実施日時
                              const Text('実施日時:', style: TextStyles.body),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        _executionDate ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    locale: const Locale('ja'),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: AppColors.primary,
                                            onPrimary: Colors.white,
                                            onSurface: AppColors.text,
                                          ),
                                          datePickerTheme: DatePickerThemeData(
                                            todayBackgroundColor:
                                                MaterialStateProperty.all(
                                                    AppColors.primary
                                                        .withOpacity(0.2)),
                                            todayForegroundColor:
                                                MaterialStateProperty.all(
                                                    AppColors.primary),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (date != null) {
                                    setState(() {
                                      _executionDate = date;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFE0E3E8)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _executionDate
                                                ?.toString()
                                                .split(' ')[0] ??
                                            '日付を選択',
                                        style: const TextStyle(
                                            color: AppColors.text),
                                      ),
                                      const Icon(Icons.calendar_today,
                                          size: 20),
                                    ],
                                  ),
                                ),
                              ),

                              // 達成度
                              TextField(
                                controller: _achievementScoreController,
                                decoration: const InputDecoration(
                                  labelText: '達成度 (1-100)',
                                  hintText: '数値を入力',
                                  hintStyle:
                                      TextStyle(color: Color(0xFF757575)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFE0E3E8)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFE0E3E8)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: AppColors.primary, width: 2),
                                  ),
                                  labelStyle: TextStyle(color: AppColors.text),
                                  floatingLabelStyle:
                                      TextStyle(color: AppColors.text),
                                ),
                                keyboardType: TextInputType.number,
                              ),

                              // 体調
                              TextField(
                                controller: _physicalDataController,
                                decoration: const InputDecoration(
                                  labelText: '体調',
                                  hintText: '体調について入力',
                                  hintStyle:
                                      TextStyle(color: Color(0xFF757575)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFE0E3E8)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFE0E3E8)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: AppColors.primary, width: 2),
                                  ),
                                  labelStyle: TextStyle(color: AppColors.text),
                                  floatingLabelStyle:
                                      TextStyle(color: AppColors.text),
                                ),
                                maxLines: 1,
                              ),

                              // 言葉
                              _isEditing
                                  ? TextField(
                                      controller: _wordController,
                                      decoration: const InputDecoration(
                                        labelText: '支えになった言葉',
                                        hintText: '支えになった言葉を入力',
                                        hintStyle:
                                            TextStyle(color: Color(0xFF757575)),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          borderSide: BorderSide(
                                              color: Color(0xFFE0E3E8)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          borderSide: BorderSide(
                                              color: Color(0xFFE0E3E8)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          borderSide: BorderSide(
                                              color: AppColors.primary,
                                              width: 2),
                                        ),
                                        labelStyle:
                                            TextStyle(color: AppColors.text),
                                        floatingLabelStyle:
                                            TextStyle(color: AppColors.text),
                                      ),
                                      maxLines: 1,
                                    )
                                  : _buildModernDetailRow(Icons.format_quote,
                                      '言葉', _currentStep.word,
                                      iconColor: Colors.blueAccent),

                              // 対処法
                              _isEditing
                                  ? TextField(
                                      controller: _copingMethodController,
                                      decoration: const InputDecoration(
                                        labelText: '効果があった対処法',
                                        hintText: '効果があった対処法を入力',
                                        hintStyle:
                                            TextStyle(color: Color(0xFF757575)),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          borderSide: BorderSide(
                                              color: Color(0xFFE0E3E8)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          borderSide: BorderSide(
                                              color: Color(0xFFE0E3E8)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          borderSide: BorderSide(
                                              color: AppColors.primary,
                                              width: 2),
                                        ),
                                        labelStyle:
                                            TextStyle(color: AppColors.text),
                                        floatingLabelStyle:
                                            TextStyle(color: AppColors.text),
                                      ),
                                      maxLines: 1,
                                    )
                                  : _buildModernDetailRow(Icons.psychology,
                                      '対処法', _currentStep.copingMethod,
                                      iconColor: Colors.green),
                            ] else ...[
                              _buildModernDetailRow(
                                  Icons.event,
                                  '実施日時',
                                  _currentStep.executionDate
                                      ?.toString()
                                      .split(' ')[0]),
                              _buildModernDetailRow(Icons.emoji_events, '達成度',
                                  _currentStep.achievementScore?.toString()),
                              _buildModernDetailRow(Icons.favorite, '体調',
                                  _currentStep.physicalData ?? ''),
                              _buildModernDetailRow(
                                  Icons.format_quote, '言葉', _currentStep.word),
                              _buildModernDetailRow(Icons.psychology, '対処法',
                                  _currentStep.copingMethod),
                              _buildModernDetailRow(
                                  Icons.comment, '感想', _currentStep.impression),
                            ],
                            // 編集モード時の感想入力
                            if (_isEditing)
                              TextField(
                                controller: _impressionController,
                                decoration: const InputDecoration(
                                  labelText: '感想や気づき',
                                  hintText: '感想や気づきを入力',
                                  hintStyle:
                                      TextStyle(color: Color(0xFF757575)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFE0E3E8)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFE0E3E8)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: AppColors.primary, width: 2),
                                  ),
                                  labelStyle: TextStyle(color: AppColors.text),
                                  floatingLabelStyle:
                                      TextStyle(color: AppColors.text),
                                ),
                                maxLines: 3,
                              ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                      if (!_isEditing)
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: IconButton(
                            icon: const Icon(Icons.edit,
                                size: 22, color: AppColors.primary),
                            onPressed: () => setState(() => _isEditing = true),
                            tooltip: '編集',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isEditing
          ? Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _isEditing = false;
                                  // 編集内容を破棄し、元の値に戻す
                                  _preAnxietyController.text = _currentStep
                                          .beforeAnxietyScore
                                          ?.toString() ??
                                      '';
                                  _postAnxietyController.text = _currentStep
                                          .afterAnxietyScore
                                          ?.toString() ??
                                      '';
                                  _impressionController.text =
                                      _currentStep.impression ?? '';
                                  _achievementScoreController.text =
                                      _currentStep.achievementScore
                                              ?.toString() ??
                                          '';
                                  _physicalDataController.text =
                                      _currentStep.physicalData ?? '';
                                  _wordController.text =
                                      _currentStep.word ?? '';
                                  _copingMethodController.text =
                                      _currentStep.copingMethod ?? '';
                                  _executionDate = _currentStep.executionDate;
                                });
                              },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'キャンセル',
                          style:
                              TextStyle(color: AppColors.primary, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveStep,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                '保存',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Future<void> _saveStep() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final preAnxiety = int.tryParse(_preAnxietyController.text) ?? 0;
      final postAnxiety = int.tryParse(_postAnxietyController.text) ?? 0;
      final achievementScore =
          int.tryParse(_achievementScoreController.text) ?? 0;
      final impression = _impressionController.text;
      final physicalData = _physicalDataController.text;
      final word = _wordController.text;
      final copingMethod = _copingMethodController.text;

      // 感情分析の処理（impressionから感情を抽出）
      final emotion = await _analyzeEmotion(impression);

      final stepData = {
        'action': _currentStep.action,
        'beforeAnxietyScore': preAnxiety,
        'afterAnxietyScore': postAnxiety,
        'achievementScore': achievementScore,
        'physicalData': physicalData,
        'word': word,
        'copingMethod': copingMethod,
        'impression': impression,
        'emotion': emotion,
        'executionDate': _executionDate,
        'isDone': _currentStep.isDone,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user',
        'goalId': _currentStep.goalId,
        'displayOrder': _currentStep.displayOrder,
        'isDeleted': _currentStep.isDeleted,
        'createdBy': _currentStep.createdBy,
        'createdAt': _currentStep.createdAt,
      };

      // 親ドキュメントの参照を取得
      final parentRef = FirebaseFirestore.instance
          .collection('goals')
          .doc(_currentStep.goalId ?? '');

      await parentRef
          .collection('babySteps')
          .doc(_currentStep.id)
          .set(stepData);

      // AIコメント生成処理
      String profileContext = '';
      bool isProfileReady = false;
      int retryCount = 0;
      const maxRetries = 5;

      while (!isProfileReady && retryCount < maxRetries) {
        final userProfileAsync = ref.read(userProfileProvider);
        if (userProfileAsync is AsyncData<AppUser?> &&
            userProfileAsync.value != null) {
          final userProfile = userProfileAsync.value;
          if (userProfile != null) {
            List<String> profileInfo = [];
            profileInfo.add('名前: ${userProfile.userName}');
            if (userProfile.age != null)
              profileInfo.add('年齢: 「${userProfile.age}歳」');
            if (userProfile.gender != null)
              profileInfo.add('性別: 「${userProfile.gender}」');
            if (userProfile.attribute != null)
              profileInfo.add('属性: 「${userProfile.attribute}」');
            if (userProfile.hasMentalIllness != null)
              profileInfo.add(
                  '精神疾患の有無: 「${userProfile.hasMentalIllness == true ? "あり" : "なし"}」');
            if (userProfile.mentalIllnesses != null &&
                userProfile.mentalIllnesses!.isNotEmpty)
              profileInfo
                  .add('診断名: 「${userProfile.mentalIllnesses!.join("、")}」');
            profileContext = '\n\nユーザーのプロフィール情報:\n${profileInfo.join("\n")}';
            isProfileReady = true;
          }
        }

        if (!isProfileReady) {
          retryCount++;
          if (retryCount < maxRetries) {
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }
      }

      if (!isProfileReady) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('プロフィール情報の取得に失敗しました')),
          );
        }
        return;
      }

      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      final commentService = CommentService(apiKey);
      String aiComment = '';
      try {
        aiComment = await commentService.generateComment(
          profileContext: profileContext,
          action: _currentStep.action,
          beforeAnxietyScore:
              _currentStep.beforeAnxietyScore?.toString() ?? '未入力',
          afterAnxietyScore: postAnxiety.toString(),
          userComment: impression,
        );
      } catch (e) {
        aiComment = 'AIコメントの生成に失敗しました。';
      }

      try {
        _lastRecommendResult = await commentService.checkRecommendConsultation(
          profileContext: profileContext,
          action: _currentStep.action,
          beforeAnxietyScore:
              _currentStep.beforeAnxietyScore?.toString() ?? '未入力',
          afterAnxietyScore: postAnxiety.toString(),
          userComment: impression,
        );
      } catch (e) {
        if (kDebugMode) {
          print('専門家受診レコメンド判定エラー: $e');
        }
        _lastRecommendResult = null;
      }

      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('あなたへのメッセージ'),
            content: Text(aiComment),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: const TextStyle(
                    decoration: TextDecoration.none,
                  ),
                ),
                child: const Text('閉じる'),
              ),
            ],
          ),
        );

        final recommendResult = _lastRecommendResult;
        _lastRecommendResult = null;
        if (recommendResult != null && recommendResult.shouldRecommend) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('サポートのご案内',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              content: const Text(
                  'あなたの状態について、専門家（精神科・カウンセリング等）への相談を強くおすすめします。\nオンラインで相談できるサービスもあります。'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: const TextStyle(
                      decoration: TextDecoration.none,
                    ),
                  ),
                  child: const Text('閉じる'),
                ),
              ],
            ),
          );
        }

        setState(() {
          _currentStep = _currentStep.copyWith(
            beforeAnxietyScore: preAnxiety,
            afterAnxietyScore: postAnxiety,
            achievementScore: achievementScore,
            physicalData: physicalData,
            word: word,
            copingMethod: copingMethod,
            impression: impression,
            emotion: emotion,
            executionDate: _executionDate,
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 感情分析の関数
  Future<String> _analyzeEmotion(String text) async {
    // TODO: 感情分析の実装
    // ここでは簡易的な実装として、impressionの最初の100文字を返す
    return text.substring(0, text.length.clamp(0, 100));
  }

  Widget _buildModernDetailRow(IconData icon, String label, String? value,
      {Color? iconColor}) {
    final displayValue = (label == '事前不安得点' && (value == null || value.isEmpty))
        ? ''
        : (value ?? '');
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.grey[500], size: 22),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  displayValue,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 0, thickness: 0.7, color: Color(0xFFE0E3E8)),
      ],
    );
  }
}
