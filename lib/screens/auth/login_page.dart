import 'package:flutter/material.dart';

import '../../main.dart';
import '../../services/storage_service.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;

  bool hidePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> login() async {
    final email =
        emailController.text.trim();

    final password =
        passwordController.text.trim();

    if (email.isEmpty ||
        password.isEmpty) {
      showMessage(
        'Please enter email and password.',
      );

      return;
    }

    setState(() {
      loading = true;
    });

    final user =
        await StorageService.getUser();

    if (!mounted) return;

    if (user == null) {
      setState(() {
        loading = false;
      });

      showMessage(
        'No account found. Please register first.',
      );

      return;
    }

    if (user['email'] == email &&
        user['password'] == password) {

      await StorageService.setLoggedIn(
        true,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigation(
            user: user,
          ),
        ),
      );

    } else {

      setState(() {
        loading = false;
      });

      showMessage(
        'Incorrect email or password.',
      );
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [

              const SizedBox(
                height: 50,
              ),

              const Icon(
                Icons.school,
                size: 80,
              ),

              const SizedBox(
                height: 20,
              ),

              const Text(
                'SkillSetu',

                style: TextStyle(
                  fontSize: 32,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              const Text(
                'Academia • Industry • Skills',
              ),

              const SizedBox(
                height: 40,
              ),

              TextField(
                controller:
                    emailController,

                keyboardType:
                    TextInputType.emailAddress,

                decoration:
                    const InputDecoration(
                  labelText: 'Email',
                  prefixIcon:
                      Icon(Icons.email),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              TextField(
                controller:
                    passwordController,

                obscureText:
                    hidePassword,

                decoration:
                    InputDecoration(
                  labelText: 'Password',

                  prefixIcon:
                      const Icon(
                    Icons.lock,
                  ),

                  suffixIcon:
                      IconButton(
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),

                    onPressed: () {
                      setState(() {
                        hidePassword =
                            !hidePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed:
                      loading ? null : login,

                  child: loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,

                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'LOGIN',
                        ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  const Text(
                    "Don't have an account?",
                  ),

                  TextButton(
                    onPressed: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              const RegisterPage(),
                        ),
                      );

                    },

                    child: const Text(
                      'Register',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}