import 'package:flutter/material.dart';
import '../core.dart';
import '../../features/features.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;
  
  final PageController _pageController = PageController();

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_rounded,
      activeIcon: Icons.home,
      label: 'Home',
      page: const HomeDashboard(),
    ),
    NavigationItem(
      icon: Icons.search_rounded,
      activeIcon: Icons.search,
      label: 'Search',
      page: const SearchScreen(),
    ),
    NavigationItem(
      icon: Icons.library_books_rounded,
      activeIcon: Icons.library_books,
      label: 'Library',
      page: const EpisodeLibraryScreen(),
    ),
    NavigationItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      label: 'Analytics',
      page: const LearningAnalyticsDashboard(),
    ),
    NavigationItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person,
      label: 'Profile',
      page: const ProfileScreen(),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _navigationItems.map((item) => item.page).toList(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: WismeColors.surface,
          boxShadow: [
            BoxShadow(
              color: WismeColors.textPrimary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navigationItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isActive = index == _currentIndex;
                
                return GestureDetector(
                  onTap: () => _onTabTapped(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: isActive 
                        ? WismeColors.primaryBlue.withOpacity(0.1)
                        : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? item.activeIcon : item.icon,
                          color: isActive 
                            ? WismeColors.primaryBlue
                            : WismeColors.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            color: isActive 
                              ? WismeColors.primaryBlue
                              : WismeColors.textSecondary,
                            fontSize: 12,
                            fontWeight: isActive 
                              ? FontWeight.w600
                              : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Widget page;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.page,
  });
}

// Placeholder Library Screen
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        backgroundColor: WismeColors.surface,
        foregroundColor: WismeColors.textPrimary,
        elevation: 0,
      ),
      backgroundColor: WismeColors.backgroundSecondary,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_rounded,
              size: 64,
              color: WismeColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'Your Learning Library',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: WismeColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'All your episodes and learning content will appear here',
              style: TextStyle(
                fontSize: 16,
                color: WismeColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
