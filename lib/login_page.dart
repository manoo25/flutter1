import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';
import 'custom_text.dart';
import 'snack.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  Future<void> _login() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty || !email.contains('@')) {
        throw Exception('Please enter a valid email');
      }
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      final prefs = await SharedPreferences.getInstance();
      final storedPassword = prefs.getString('user_$email');

      if (storedPassword == null) {
        throw Exception('Email not registered');
      }
      if (storedPassword != password) {
        throw Exception('Incorrect password');
      }

      if (_rememberMe) {
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('currentUser', email);
      }

      await Future.delayed(const Duration(seconds: 1));
      Snack().success(context, "User Logged in Successfully");
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const Icon(CupertinoIcons.lock, size: 100, color: Colors.white),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: _emailController,
                    hint: 'Email',
                    type: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _passwordController,
                    hint: 'Password',
                    type: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) => setState(() => _rememberMe = value!),
                      ),
                      const CustomText(text: 'Remember Me', color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    onTap: _login,
                    width: double.infinity,
                    height: 35,
                    color: Colors.black87,
                    radius: 8,
                    child: const Center(
                      child: CustomText(
                        text: "Login",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: const CustomText(
                      text: "Create an account",
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const CustomText(text: "powered by rich sonic 2025", color: Colors.white),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}