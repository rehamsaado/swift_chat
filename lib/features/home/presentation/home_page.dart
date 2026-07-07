import 'package:flutter/material.dart';
import '../../chat/presentation/pages/chats_page.dart';
import '../../post/presentation/pages/post_pages/create_post_page.dart';
import '../../post/presentation/pages/post_pages/posts_page.dart';
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

  UniqueKey _postsPageKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<AppTabBarItem> _tabs = const [
    AppTabBarItem(text: "المحادثات", iconData: Icons.chat_bubble_outline),
    AppTabBarItem(text: "المنشورات", iconData: Icons.dynamic_feed_outlined),
    AppTabBarItem(text: "الحالات", iconData: Icons.vignette_outlined),
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
       PostsPage(key: _postsPageKey),
          const StoriesScreen(),
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatePostPage(),
                  ),
                );
                setState(() {
                  _postsPageKey = UniqueKey();
                });
              },
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
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
