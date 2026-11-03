import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'diary.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriTrack',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (c, s) => s.data == null ? LoginScreen() : DiaryScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailC = TextEditingController();
  final passCtrl = TextEditingController();
  bool loginMode = true;

  void _toggleMode() {
    setState(() => loginMode = !loginMode);
  }

  Future<void> _submit() async {
    var err = loginMode ? await signIn(emailC.text, passCtrl.text) : await signUp(emailC.text, passCtrl.text);
    if (err != null) _showErr(err);
  }

  void _showErr(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loginMode ? 'Log in' : 'Sign up'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            TextField(controller: emailC, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passCtrl, obscureText: true, decoration: InputDecoration(labelText: 'Password')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: Text(loginMode ? 'Log in' : 'Sign up')),
            TextButton(
              onPressed: _toggleMode,
              child: Text(loginMode ? 'No account? Sign up' : 'Have an account? Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
