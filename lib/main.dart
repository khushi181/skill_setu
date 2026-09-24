import 'package:flutter/material.dart';

import 'screens/auth/login_page.dart';
import 'screens/dashboard/dashboard_page.dart';
import 'screens/opportunities/opportunities_page.dart';
import 'screens/profile/profile_page.dart';
import 'services/storage_service.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const SkillSetuApp(),
  );
}


class SkillSetuApp extends StatelessWidget {
  const SkillSetuApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'SkillSetu',

      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),

        useMaterial3: true,

        inputDecorationTheme:
            const InputDecorationTheme(
          border:
              OutlineInputBorder(),
        ),
      ),

      home:
          const StartPage(),
    );
  }
}


// ------------------------------------
// START PAGE
// ------------------------------------

class StartPage
    extends StatefulWidget {

  const StartPage({
    super.key,
  });

  @override
  State<StartPage> createState() =>
      _StartPageState();
}


class _StartPageState
    extends State<StartPage> {

  @override
  void initState() {
    super.initState();

    checkLogin();
  }


  Future<void> checkLogin() async {

    final loggedIn =
        await StorageService.isLoggedIn();

    if (!mounted) return;


    if (loggedIn) {

      final user =
          await StorageService.getUser();

      if (!mounted) return;


      if (user != null) {

        Navigator.pushReplacement(
          context,

          MaterialPageRoute(
            builder: (_) =>
                MainNavigation(
              user: user,
            ),
          ),
        );

        return;
      }
    }


    Navigator.pushReplacement(
      context,

      MaterialPageRoute(
        builder: (_) =>
            const LoginPage(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(),
      ),
    );
  }
}


// ------------------------------------
// MAIN NAVIGATION
// ------------------------------------

class MainNavigation
    extends StatefulWidget {

  final Map<String, dynamic> user;

  const MainNavigation({
    super.key,
    required this.user,
  });

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}


class _MainNavigationState
    extends State<MainNavigation> {

  int selectedIndex = 0;


  late final List<Widget> pages;


  @override
  void initState() {
    super.initState();

    pages = [
      DashboardPage(
        user: widget.user,
      ),

      OpportunitiesPage(
        user: widget.user,
      ),

      ProfilePage(
        user: widget.user,
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: IndexedStack(
        index: selectedIndex,

        children: pages,
      ),


      bottomNavigationBar:
          NavigationBar(

        selectedIndex:
            selectedIndex,

        onDestinationSelected:
            (index) {

          setState(() {
            selectedIndex =
                index;
          });
        },


        destinations: const [

          NavigationDestination(
            icon: Icon(
              Icons.dashboard_outlined,
            ),

            selectedIcon: Icon(
              Icons.dashboard,
            ),

            label: 'Home',
          ),


          NavigationDestination(
            icon: Icon(
              Icons.work_outline,
            ),

            selectedIcon: Icon(
              Icons.work,
            ),

            label: 'Opportunities',
          ),


          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
            ),

            selectedIcon: Icon(
              Icons.person,
            ),

            label: 'Profile',
          ),
        ],
      ),
    );
  }
}