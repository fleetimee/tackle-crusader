import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../widgets/button.dart';
import '../../widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo-login.png",
              ),
              const SizedBox(
                height: 20.0,
              ),
              LoginForm(
                label: 'Username',
                controller: _usernameController,
                obscureText: 'false',
              ),
              const SizedBox(
                height: 20,
              ),
              LoginForm(
                label: 'Password',
                controller: _passwordController,
                obscureText: 'true',
              ),
              const SizedBox(
                height: 10,
              ),
              // Forgot Password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              PrimaryButton(
                text: 'GO',
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text.rich(
                  TextSpan(
                    text: 'Don\'t have an account yet? ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Animate(
          effects: const [FadeEffect(), ScaleEffect()],
          child: Image.asset(
            "assets/images/illust-login.png",
            height: 400,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
