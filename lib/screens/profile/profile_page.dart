import 'package:flutter/material.dart';

import '../auth/login_page.dart';
import '../../services/storage_service.dart';

class ProfilePage extends StatelessWidget {

  final Map<String, dynamic> user;

  const ProfilePage({
    super.key,
    required this.user,
  });


  @override
  Widget build(BuildContext context) {

    final name =
        user['name'] ?? 'User';

    final email =
        user['email'] ?? '';

    final role =
        user['role'] ?? '';

    final subject =
        user['subject'] ?? '';


    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'My Profile',
        ),
      ),


      body:
          SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            const CircleAvatar(

              radius: 55,

              child: Icon(
                Icons.person,
                size: 60,
              ),
            ),


            const SizedBox(
              height: 20,
            ),


            Text(
              name,

              style:
                  const TextStyle(
                fontSize: 25,
                fontWeight:
                    FontWeight.bold,
              ),
            ),


            const SizedBox(
              height: 5,
            ),


            Text(
              email,

              style:
                  TextStyle(
                color:
                    Colors.grey.shade700,
              ),
            ),


            const SizedBox(
              height: 25,
            ),


            profileCard(
              Icons.person,
              'Role',
              role,
            ),


            profileCard(
              Icons.school,
              'Subject / Domain',
              subject,
            ),


            const SizedBox(
              height: 25,
            ),


            SizedBox(

              width:
                  double.infinity,

              height: 50,

              child:
                  ElevatedButton.icon(

                icon:
                    const Icon(
                  Icons.logout,
                ),

                label:
                    const Text(
                  'Logout',
                ),

                onPressed: () async {

                  await StorageService
                      .logout();


                  if (!context.mounted) {
                    return;
                  }


                  Navigator.pushAndRemoveUntil(

                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          const LoginPage(),
                    ),

                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget profileCard(
    IconData icon,
    String title,
    String value,
  ) {

    return Card(

      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      child: ListTile(

        leading:
            CircleAvatar(
          child:
              Icon(icon),
        ),

        title: Text(
          title,

          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        subtitle:
            Text(value),
      ),
    );
  }
}