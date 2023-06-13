import 'package:demeter/providers/user_provider.dart';
import 'package:demeter/resources/auth_methods.dart';
import 'package:demeter/screens/login_screen.dart';
import 'package:demeter/utils/colors.dart';
import 'package:demeter/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:demeter/models/user.dart' as model;
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  String username = "";
  int currentPageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      currentPageIndex = page;
    });
  }

  void signOut() {
    AuthMethods().signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //model.User? user = Provider.of<UserProvider>(context).getUser;
    //String username = user?.username ?? '';

    return Scaffold(
      body: PageView(
        onPageChanged: onPageChanged,
        controller: _pageController,
        children: homeScreenItems,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: goldDemeter,
        indicatorColor: lightDemeter,
        selectedIndex: currentPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add_circle),
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_outline),
            label: 'Like',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
