import 'dart:io';
import 'package:anshin_step/ui/profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import 'package:anshin_step/ui/main/main_screen.dart';

final authProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Consumer(
        builder: (context, ref, _) {
          final authState = ref.watch(authProvider);
          return authState.when(
            data: (user) => user == null
                ? const SignInPage()
                : user.displayName?.isEmpty ?? true
                    ? ProfileScreen(isNewUser: true)
                    : const MainScreen(),
            loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator())),
            error: (error, _) =>
                Scaffold(body: Center(child: Text('エラー: $error'))),
          );
        },
      ),
      routes: {
        '/main': (context) => const MainScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _googleSignIn = GoogleSignIn(scopes: ['profile', 'email', 'openid']);

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null && googleAuth.accessToken == null) {
        throw Exception('Google認証でトークンの取得に失敗しました');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // ignore: avoid_print
      print('Googleサインインエラー: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('サインインに失敗しました: ${e.toString()}')),
      );
    }
  }

  bool _showEmailPasswordForm = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _authError = '';

  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('匿名認証に失敗しました: ${e.toString()}')),
      );
    }
  }

  Future<void> _signInWithEmailPassword(bool isNewUser) async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty || !email.contains('@')) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: '有効なメールアドレスを入力してください',
        );
      }

      if (password.length < 6) {
        throw FirebaseAuthException(
          code: 'weak-password',
          message: 'パスワードは6文字以上必要です',
        );
      }

      if (isNewUser) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'ユーザーが存在しません';
          break;
        case 'wrong-password':
          errorMessage = 'パスワードが間違っています';
          break;
        case 'email-already-in-use':
          errorMessage = 'このメールアドレスは既に使用されています';
          break;
        default:
          errorMessage = e.message ?? '認証に失敗しました';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン方法を選択'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_showEmailPasswordForm) ...[
              ElevatedButton.icon(
                icon: const Icon(Icons.mail),
                label: const Text('Googleで続行'),
                onPressed: signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                icon: const Icon(Icons.person),
                label: const Text('匿名で続行'),
                onPressed: _signInAnonymously,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                child: const Text('Email/Passwordで続行'),
                onPressed: () => setState(() => _showEmailPasswordForm = true),
              ),
            ] else ...[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'メールアドレス',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'パスワード',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: const Text('登録'),
                    onPressed: () => _signInWithEmailPassword(true),
                  ),
                  ElevatedButton(
                    child: const Text('ログイン'),
                    onPressed: () => _signInWithEmailPassword(false),
                  ),
                ],
              ),
              TextButton(
                child: const Text('戻る'),
                onPressed: () => setState(() => _showEmailPasswordForm = false),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
