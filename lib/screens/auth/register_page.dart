
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? selectedRole;
  String? selectedSubject;

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool loading = false;

  List<String> get subjectOptions {
    if (selectedRole == 'Student') {
      return studentSubjects;
    }

    if (selectedRole == 'Academician') {
      return academicianSubjects;
    }

    if (selectedRole == 'Industry') {
      return industryDomains;
    }

    if (selectedRole == 'Institution') {
      return ['Institution / University'];
    }

    return [];
  }

  String get subjectLabel {
    if (selectedRole == 'Industry') {
      return 'Industry Domain';
    }

    if (selectedRole == 'Institution') {
      return 'Institution Type';
    }

    return 'Subject / Domain';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage('Please fill all fields.');
      return;
    }

    if (selectedRole == null) {
      showMessage('Please select your role.');
      return;
    }

    if (selectedSubject == null) {
      showMessage('Please select subject/domain.');
      return;
    }

    if (password.length < 6) {
      showMessage('Password must contain at least 6 characters.');
      return;
    }

    if (password != confirmPassword) {
      showMessage('Passwords do not match.');
      return;
    }

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      showMessage('Please enter a valid email address.');
      return;
    }

    final nameParts = name.split(RegExp(r'\s+'));

    final firstName = nameParts.first;

    final lastName = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : '';

    String username = email.split('@').first;

    username = username.replaceAll(
      RegExp(r'[^a-zA-Z0-9_]'),
      '',
    );

    if (username.isEmpty) {
      showMessage('Unable to create username from email.');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final response = await ApiService.register(
        username: username,
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: selectedRole!,
        subject: selectedSubject!,
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        final user = {
          'name': name,
          'email': email,
          'role': selectedRole,
          'subject': selectedSubject,
        };

        await StorageService.saveUser(user);
        await StorageService.setLoggedIn(true);

        if (!mounted) return;

        showMessage('Account created successfully!');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => MainNavigation(
              user: user,
            ),
          ),
          (route) => false,
        );

        return;
      }

      String errorMessage =
          'Registration failed. Please check your details.';

      if (response.body.isNotEmpty) {
        try {
          final decoded = jsonDecode(response.body);

          if (decoded is Map<String, dynamic>) {
            if (decoded.containsKey('username')) {
              errorMessage =
                  'Username already exists. Try another email.';
            } else if (decoded.containsKey('email')) {
              errorMessage =
                  'This email is already registered.';
            } else if (decoded.containsKey('role')) {
              errorMessage =
                  'Please select a valid role.';
            } else if (decoded.containsKey('password')) {
              errorMessage =
                  'Password does not meet the requirements.';
            } else {
              errorMessage = decoded.values
                  .map((value) => value.toString())
                  .join(' ');
            }
          }
        } catch (_) {
          errorMessage =
              'Registration failed. Server response: ${response.statusCode}';
        }
      }

      showMessage(errorMessage);
    } catch (_) {
      if (!mounted) return;

      showMessage(
        'Unable to connect to SkillSetu server. '
        'Please check your internet connection.',
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Join SkillSetu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create your Academia–Industry profile.',
              ),
              const SizedBox(height: 25),

              // Full Name
              TextField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Role
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Select Role',
                  prefixIcon: Icon(Icons.groups),
                  border: OutlineInputBorder(),
                ),
                items: roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: loading
                    ? null
                    : (value) {
                        setState(() {
                          selectedRole = value;
                          selectedSubject = null;
                        });
                      },
              ),

              const SizedBox(height: 16),

              // Subject / Domain
              if (selectedRole != null)
                DropdownButtonFormField<String>(
                  initialValue: selectedSubject,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: subjectLabel,
                    prefixIcon: const Icon(Icons.category),
                    border: const OutlineInputBorder(),
                  ),
                  items: subjectOptions.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: loading
                      ? null
                      : (value) {
                          setState(() {
                            selectedSubject = value;
                          });
                        },
                ),

              const SizedBox(height: 16),

              // Password
              TextField(
                controller: passwordController,
                obscureText: hidePassword,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Confirm Password
              TextField(
                controller: confirmPasswordController,
                obscureText: hideConfirmPassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hideConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        hideConfirmPassword =
                            !hideConfirmPassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Create Account
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : register,
                  child: loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('CREATE ACCOUNT'),
                ),
              ),

              const SizedBox(height: 10),

              // Login
              Center(
                child: TextButton(
                  onPressed: loading
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  child: const Text(
                    'Already have an account? Login',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
