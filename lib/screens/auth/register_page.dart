import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../../main.dart';
import '../../services/storage_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  String? selectedRole;

  String? selectedSubject;

  bool hidePassword = true;

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
      return [
        'Institution / University',
      ];
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

    final name =
        nameController.text.trim();

    final email =
        emailController.text.trim();

    final password =
        passwordController.text.trim();

    final confirmPassword =
        confirmPasswordController.text.trim();


    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {

      showMessage(
        'Please fill all fields.',
      );

      return;
    }


    if (selectedRole == null) {

      showMessage(
        'Please select your role.',
      );

      return;
    }


    if (selectedSubject == null) {

      showMessage(
        'Please select subject/domain.',
      );

      return;
    }


    if (password.length < 6) {

      showMessage(
        'Password must contain at least 6 characters.',
      );

      return;
    }


    if (password != confirmPassword) {

      showMessage(
        'Passwords do not match.',
      );

      return;
    }


    setState(() {
      loading = true;
    });


    final user = {
      'name': name,
      'email': email,
      'password': password,
      'role': selectedRole,
      'subject': selectedSubject,
    };


    await StorageService.saveUser(
      user,
    );

    await StorageService.setLoggedIn(
      true,
    );


    if (!mounted) return;


    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder: (_) => MainNavigation(
          user: user,
        ),
      ),

      (route) => false,
    );
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

      appBar: AppBar(
        title: const Text(
          'Create Account',
        ),
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              const Text(
                'Join SkillSetu',

                style: TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              const Text(
                'Create your Academia–Industry profile.',
              ),

              const SizedBox(
                height: 25,
              ),


              // NAME
              TextField(
                controller:
                    nameController,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Full Name',

                  prefixIcon:
                      Icon(Icons.person),
                ),
              ),

              const SizedBox(
                height: 16,
              ),


              // EMAIL
              TextField(
                controller:
                    emailController,

                keyboardType:
                    TextInputType.emailAddress,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Email',

                  prefixIcon:
                      Icon(Icons.email),
                ),
              ),

              const SizedBox(
                height: 16,
              ),


              // ROLE
              DropdownButtonFormField<String>(

                initialValue:
                    selectedRole,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Select Role',

                  prefixIcon:
                      Icon(Icons.groups),
                ),

                items:
                    roles.map(
                  (role) {

                    return DropdownMenuItem<
                        String>(
                      value: role,

                      child: Text(
                        role,
                      ),
                    );
                  },
                ).toList(),

                onChanged: (value) {

                  setState(() {

                    selectedRole =
                        value;

                    selectedSubject =
                        null;
                  });
                },
              ),

              const SizedBox(
                height: 16,
              ),


              // SUBJECT / DOMAIN
              if (selectedRole != null)

                DropdownButtonFormField<String>(

                  initialValue:
                      selectedSubject,

                  isExpanded: true,

                  decoration:
                      InputDecoration(
                    labelText:
                        subjectLabel,

                    prefixIcon:
                        const Icon(
                      Icons.category,
                    ),
                  ),

                  items:
                      subjectOptions.map(
                    (item) {

                      return DropdownMenuItem<
                          String>(
                        value: item,

                        child: Text(
                          item,

                          overflow:
                              TextOverflow
                                  .ellipsis,
                        ),
                      );
                    },
                  ).toList(),

                  onChanged: (value) {

                    setState(() {

                      selectedSubject =
                          value;
                    });
                  },
                ),

              const SizedBox(
                height: 16,
              ),


              // PASSWORD
              TextField(
                controller:
                    passwordController,

                obscureText:
                    hidePassword,

                decoration:
                    InputDecoration(
                  labelText:
                      'Password',

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
                height: 16,
              ),


              // CONFIRM PASSWORD
              TextField(
                controller:
                    confirmPasswordController,

                obscureText:
                    hidePassword,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Confirm Password',

                  prefixIcon:
                      Icon(Icons.lock),
                ),
              ),

              const SizedBox(
                height: 25,
              ),


              // REGISTER BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(

                  onPressed:
                      loading
                          ? null
                          : register,

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
                          'CREATE ACCOUNT',
                        ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),


              Center(
                child: TextButton(

                  onPressed: () {

                    Navigator.pop(
                      context,
                    );
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