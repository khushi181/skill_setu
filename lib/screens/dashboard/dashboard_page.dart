import 'package:flutter/material.dart';

import '../../widgets/common_widgets.dart';

class DashboardPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const DashboardPage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final name =
        user['name'] ?? 'User';

    final role =
        user['role'] ?? '';

    final subject =
        user['subject'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SkillSetu',
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                'Welcome, $name 👋',

                style:
                    const TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(
                '$role • $subject',
              ),

              const SizedBox(
                height: 20,
              ),

              sectionTitle(
                'Your Overview',
              ),

              GridView.count(
                crossAxisCount: 2,

                shrinkWrap: true,

                physics:
                    const NeverScrollableScrollPhysics(),

                crossAxisSpacing: 10,
                mainAxisSpacing: 10,

                children: [

                  statCard(
                    'Skills',
                    '8',
                    Icons.psychology,
                  ),

                  statCard(
                    'Applications',
                    '3',
                    Icons.send,
                  ),

                  statCard(
                    'Learning',
                    '4',
                    Icons.school,
                  ),

                  statCard(
                    'Profile',
                    '80%',
                    Icons.person,
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              sectionTitle(
                'SkillSetu Features',
              ),

              feature(
                'Skill Assessment',
                'Evaluate your technical and soft skills.',
                Icons.assessment,
              ),

              feature(
                'Skill Gap Analysis',
                'Find skills you need to improve.',
                Icons.analytics,
              ),

              feature(
                'Career Guidance',
                'Discover suitable career paths.',
                Icons.work,
              ),

              feature(
                'Internships & Jobs',
                'Find suitable industry opportunities.',
                Icons.business_center,
              ),

              feature(
                'Digital Portfolio',
                'Showcase projects and achievements.',
                Icons.folder_special,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget feature(
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      child: ListTile(
        leading:
            CircleAvatar(
          child: Icon(icon),
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
            Text(description),

        trailing:
            const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }
}