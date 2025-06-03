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
import 'package:anshin_step/services/report_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

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
        leading: const BackButton(),
        centerTitle: true,
        title: const Text(
          'ステップ',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        surfaceTintColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
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
                                ? _buildModernDetailRow(
                                    Icons.sentiment_satisfied,
                                    '事前不安得点',
                                    _currentStep.beforeAnxietyScore == null
                                        ? ''
                                        : _currentStep.beforeAnxietyScore
                                            .toString(),
                                    isEditing: _isEditing,
                                    controller: _preAnxietyController,
                                    keyboardType: TextInputType.number,
                                    hintText: '数値を入力',
                                  )
                                : _buildModernDetailRow(
                                    Icons.sentiment_satisfied,
                                    '事前不安得点',
                                    _currentStep.beforeAnxietyScore == null
                                        ? ''
                                        : _currentStep.beforeAnxietyScore
                                            .toString()),
                            _isEditing
                                ? _buildModernDetailRow(
                                    Icons.sentiment_very_satisfied,
                                    '事後不安得点',
                                    _currentStep.afterAnxietyScore?.toString(),
                                    isEditing: _isEditing,
                                    controller: _postAnxietyController,
                                    keyboardType: TextInputType.number,
                                    hintText: '数値を入力',
                                  )
                                : _buildModernDetailRow(
                                    Icons.sentiment_very_satisfied,
                                    '事後不安得点',
                                    _currentStep.afterAnxietyScore?.toString()),
                            if (_isEditing) ...[
                              // 実施日時
                              _buildModernDetailRow(
                                Icons.event,
                                '実施日時',
                                _currentStep.executionDate
                                    ?.toString()
                                    .split(' ')[0],
                                isEditing: _isEditing,
                                controller: TextEditingController(
                                    text: _executionDate
                                            ?.toString()
                                            .split(' ')[0] ??
                                        ''),
                                onTap: _isEditing
                                    ? () async {
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
                                                datePickerTheme:
                                                    DatePickerThemeData(
                                                  todayBackgroundColor:
                                                      MaterialStateProperty.all(
                                                          AppColors.primary
                                                              .withOpacity(
                                                                  0.2)),
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
                                      }
                                    : null,
                                hintText: '日付が未入力です',
                              ),

                              // 達成度
                              _isEditing
                                  ? _buildModernDetailRow(
                                      Icons.emoji_events,
                                      '達成度',
                                      _currentStep.achievementScore?.toString(),
                                      isEditing: _isEditing,
                                      controller: _achievementScoreController,
                                      keyboardType: TextInputType.number,
                                      hintText: '1-100',
                                    )
                                  : _buildModernDetailRow(
                                      Icons.emoji_events,
                                      '達成度',
                                      _currentStep.achievementScore
                                          ?.toString()),

                              // 体調
                              _isEditing
                                  ? _buildModernDetailRow(
                                      Icons.favorite,
                                      '体調',
                                      _currentStep.physicalData ?? '',
                                      isEditing: _isEditing,
                                      controller: _physicalDataController,
                                      hintText: '体調について入力',
                                    )
                                  : _buildModernDetailRow(Icons.favorite, '体調',
                                      _currentStep.physicalData ?? ''),

                              // 言葉
                              _isEditing
                                  ? _buildModernDetailRow(
                                      Icons.format_quote,
                                      '言葉',
                                      _currentStep.word,
                                      isEditing: _isEditing,
                                      controller: _wordController,
                                      hintText: '支えになった言葉',
                                      isMultiline: true,
                                    )
                                  : _buildModernDetailRow(
                                      Icons.format_quote,
                                      '言葉',
                                      _currentStep.word,
                                      isMultiline: true,
                                    ),

                              // 対処法
                              _isEditing
                                  ? _buildModernDetailRow(
                                      Icons.psychology,
                                      '対処法',
                                      _currentStep.copingMethod,
                                      isEditing: _isEditing,
                                      controller: _copingMethodController,
                                      hintText: '試してみた対処法',
                                      isMultiline: true,
                                    )
                                  : _buildModernDetailRow(
                                      Icons.psychology,
                                      '対処法',
                                      _currentStep.copingMethod,
                                      isMultiline: true,
                                    ),

                              // 感想
                              _isEditing
                                  ? _buildModernDetailRow(
                                      Icons.comment,
                                      '感想',
                                      _currentStep.impression,
                                      isEditing: _isEditing,
                                      controller: _impressionController,
                                      maxLines: 3,
                                      hintText: '感想や気づき',
                                      isMultiline: true,
                                    )
                                  : _buildModernDetailRow(
                                      Icons.comment,
                                      '感想',
                                      _currentStep.impression,
                                      isMultiline: true,
                                    ),
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
                                  Icons.format_quote, '言葉', _currentStep.word,
                                  isMultiline: true),
                              _buildModernDetailRow(Icons.psychology, '対処法',
                                  _currentStep.copingMethod,
                                  isMultiline: true),
                              _buildModernDetailRow(
                                  Icons.comment, '感想', _currentStep.impression,
                                  isMultiline: true),
                            ],
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
                      child: TextButton(
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
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                              side: BorderSide(
                                  color: AppColors.primary, width: 2)),
                        ),
                        child: const Text('キャンセル'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
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
                            : const Text('保存'),
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

      // 天気、気温、気圧、月齢の仮値を設定
      final weather = 'sunny'; // 天気: sunny, rainy, cloudy
      final temperature = 25; // 気温（摂氏）
      final pressure = 1013; // 気圧（hPa）
      final lunarAge = 15; // 月齢（0-29.5）

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
        'weather': weather,
        'temperature': temperature,
        'pressure': pressure,
        'lunarAge': lunarAge,
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

      // _currentStepを更新
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
          weather: weather,
          temperature: temperature,
          pressure: pressure,
          lunarAge: lunarAge,
        );
      });

      // AIコメントの生成
      if (_currentStep.achievementScore != null) {
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
        try {
          final aiComment = await commentService.generateComment(
            profileContext: profileContext,
            action: _currentStep.action,
            beforeAnxietyScore:
                _currentStep.beforeAnxietyScore?.toString() ?? '未入力',
            afterAnxietyScore:
                _currentStep.afterAnxietyScore?.toString() ?? '未入力',
            userComment: _currentStep.impression ?? '',
          );

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
          }
        } catch (e) {
          print('AIコメント生成エラー: $e');
        }
      }

      // レポートの再生成
      try {
        print('=== レポート生成開始 ===');
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          print('ユーザーがログインしていません');
          return;
        }
        print('現在のユーザー情報:');
        print('- UID: ${currentUser.uid}');
        print('- Email: ${currentUser.email}');
        print('- DisplayName: ${currentUser.displayName}');
        print('ステップのユーザー情報:');
        print('- createdBy: ${_currentStep.createdBy}');
        print('- goalId: ${_currentStep.goalId}');

        final reportService = ReportService();
        if (_currentStep.createdBy != null) {
          await reportService.generateReport(
            _currentStep.createdBy!,
            goalId: _currentStep.goalId,
          );
        } else {
          print('ステップのcreatedByがnullのため、レポート生成をスキップします');
        }
        print('レポートの再生成が完了しました');
      } catch (e) {
        print('レポートの再生成中にエラーが発生しました: $e');
        print('エラーの詳細: ${e.toString()}');
        // レポート生成のエラーは全体の処理を中断しない
      }

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存しました')),
        );
        // 詳細画面に戻る（編集モードを解除）
        setState(() {
          _isEditing = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
        );
      }
    }
  }

  // 感情分析の関数
  Future<String> _analyzeEmotion(String text) async {
    // TODO: 感情分析の実装
    // ここでは簡易的な実装として、impressionの最初の100文字を返す
    return text.substring(0, text.length.clamp(0, 100));
  }

  Widget _buildModernDetailRow(
    IconData icon,
    String label,
    String? value, {
    Color? iconColor,
    bool isEditing = false,
    TextEditingController? controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hintText,
    bool isMultiline = false,
    VoidCallback? onTap,
    Widget? trailingWidget,
  }) {
    final displayValue = (label == '事前不安得点' && (value == null || value.isEmpty))
        ? ''
        : (value ?? '');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: isMultiline
              ? ((displayValue == null || displayValue.isEmpty) &&
                      !(isEditing && controller != null)
                  ? Row(
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
                        if (trailingWidget != null) ...[
                          const SizedBox(width: 8),
                          trailingWidget,
                        ],
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                            if (trailingWidget != null) ...[
                              const SizedBox(width: 8),
                              trailingWidget,
                            ],
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 32, top: 4),
                          child: (isEditing && controller != null)
                              ? TextField(
                                  controller: controller,
                                  keyboardType: keyboardType,
                                  maxLines: maxLines,
                                  cursorColor: AppColors.primary,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: hintText,
                                    hintStyle: const TextStyle(
                                        color: Color(0xFFBDBDBD)),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF222222),
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.left,
                                )
                              : Text(
                                  displayValue,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF222222),
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                        ),
                      ],
                    ))
              : Row(
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
                      child: isEditing && controller != null
                          ? (onTap != null
                              ? InkWell(
                                  onTap: onTap,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        controller.text.isEmpty
                                            ? (hintText ?? '')
                                            : controller.text,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF222222),
                                          fontWeight: FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(Icons.calendar_today,
                                          size: 18, color: AppColors.primary),
                                    ],
                                  ),
                                )
                              : TextField(
                                  controller: controller,
                                  keyboardType: keyboardType,
                                  maxLines: maxLines,
                                  cursorColor: AppColors.primary,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: hintText,
                                    hintStyle: const TextStyle(
                                        color: Color(0xFFBDBDBD)),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF222222),
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.right,
                                ))
                          : Text(
                              displayValue,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF222222),
                                fontWeight: FontWeight.normal,
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
