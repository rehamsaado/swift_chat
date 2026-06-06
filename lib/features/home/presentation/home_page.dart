import 'package:flutter/material.dart';

import '../../chat/presentation/pages/chats_page.dart';
import '../../stories/presentation/pages/stories_screen.dart';
import 'app_tab_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  final List<AppTabBarItem> _tabs = const [
    AppTabBarItem(text: "المحادثات", iconData: Icons.chat_bubble_outline),
    AppTabBarItem(text: "الحالات", iconData: Icons.vignette_outlined),
    AppTabBarItem(text: "المكالمات", iconData: Icons.call_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: [
          const ChatListScreen(),
          const StoriesScreen(),
          Center(
            child: Text(
              "المكالمات",
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: theme.colorScheme.surfaceContainerLow,
        child: AppTabBarWidget(
          items: _tabs,
          selectedIndex: _selectedIndex,
          isBottomIndicator: false,
          onTap: (index) {
            setState(() => _selectedIndex = index);
            _pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }
}