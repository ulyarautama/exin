import 'package:flutter/material.dart';

import '../../content/presentation/content_screen.dart';
import '../../discover/presentation/discover_screen.dart';
import '../../feed/presentation/home_screen.dart';
import '../../messaging/presentation/messages_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  final _pages = [
    HomeScreen(),
    DiscoverScreen(),
    ContentScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  Widget _icon(IconData icon, String label) => Tooltip(
    message: label,
    triggerMode: TooltipTriggerMode.longPress,
    child: Icon(icon),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: IndexedStack(index: _index, children: _pages),
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _index,
      indicatorColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      onDestinationSelected: (index) => setState(() => _index = index),
      destinations: [
        NavigationDestination(
          icon: _icon(Icons.home_outlined, 'Home'),
          selectedIcon: _icon(Icons.home_rounded, 'Home'),
          label: 'Home',
        ),
        NavigationDestination(
          icon: _icon(Icons.explore_outlined, 'Discover'),
          selectedIcon: _icon(Icons.explore_rounded, 'Discover'),
          label: 'Discover',
        ),
        NavigationDestination(
          icon: _icon(Icons.video_library_outlined, 'Content'),
          selectedIcon: _icon(Icons.video_library_rounded, 'Content'),
          label: 'Content',
        ),
        NavigationDestination(
          icon: _icon(Icons.mail_outline_rounded, 'Messages'),
          selectedIcon: _icon(Icons.mail_rounded, 'Messages'),
          label: 'Messages',
        ),
        NavigationDestination(
          icon: _icon(Icons.person_outline_rounded, 'Profile'),
          selectedIcon: _icon(Icons.person_rounded, 'Profile'),
          label: 'Profile',
        ),
      ],
    ),
  );
}
